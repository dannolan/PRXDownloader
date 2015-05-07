//
//  PRXDownloader.m
//  PRXDownloader
//
//  Created by Dan Nolan on 8/04/2015.
//  Copyright (c) 2015 Dan Nolan. All rights reserved.
//

#import "PRXDownloader.h"

@interface PRXDownloader () <NSURLSessionDownloadDelegate, NSURLSessionTaskDelegate, NSURLSessionDelegate>

@property (nonatomic, readwrite) NSMutableDictionary* downloadingDict;
@property (nonatomic, readwrite) NSMutableDictionary* progressDict;
@property (nonatomic, readwrite) NSURLSession* downloaderURLSession;
@property (nonatomic) dispatch_queue_t downloaderQueue;
@end

@implementation PRXDownloader

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.downloadingDict = [[NSMutableDictionary alloc] init];
        self.progressDict = [[NSMutableDictionary alloc] init];
        //explicitly serial because duh
        self.downloaderQueue = dispatch_queue_create("io.proxima.opensource.downloader", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

+ (instancetype)defaultDownloader
{
    PRXDownloader* downloader = [[PRXDownloader alloc] init];
    //Just use the default session who cares
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    downloader.downloaderURLSession = [NSURLSession sessionWithConfiguration:config delegate:downloader delegateQueue:nil];
    return downloader;
}

#pragma mark accessors for current dictionaries

- (NSDictionary*)currentProgressItems
{
    __block NSDictionary* theDictionary;
    dispatch_sync(self.downloaderQueue, ^{
        theDictionary = [NSDictionary dictionaryWithDictionary:self.progressDict];
    });
    return theDictionary;
}

- (NSDictionary*)currentQueueItems
{
    __block NSDictionary* theDictionary;
    dispatch_sync(self.downloaderQueue, ^{
        theDictionary = [NSDictionary dictionaryWithDictionary:self.downloadingDict];
    });
    return theDictionary;
}

#pragma mark interaction with our progress dictionaries

- (void)clearItemWithIdentifier:(NSString*)key
{
    dispatch_sync(self.downloaderQueue, ^{
        [self.downloadingDict removeObjectForKey:key];
        [self.progressDict removeObjectForKey:key];
    });
}

#pragma mark adding downloads

- (void)addDownloadItemWithURL:(NSURL*)url fileName:(NSString*)fileName andSaveLocation:(NSURL*)saveLocation andCompleteBlock:(DownloadConcluded)concluded
{
    PRXDownloadItem* item = [[PRXDownloadItem alloc] initWithRemoteURL:url locationToDownloadTo:saveLocation fileName:fileName andConcludeBlock:concluded];
    [self addDownloadItem:item andProcess:true];
}

- (void)addDownloadItem:(PRXDownloadItem*)item
{
    [self addDownloadItem:item andProcess:true];
}

//for testing purposes
- (void)addDownloadItem:(PRXDownloadItem*)item andProcess:(BOOL)process
{
    NSString* identifierString = item.downloadURLString;
    if ([self objectExistsForDownload:identifierString]) {
        NSLog(@"You are currently trying to download this item, chill my dude it will be okay or it wont be");
        return;
    }
    else {
        NSURLRequest* request = [NSURLRequest requestWithURL:item.downloadURL];
        NSURLSessionDownloadTask* task = [self.downloaderURLSession downloadTaskWithRequest:request];
        //We don't know how big the file is yet so we're not saving it yet
        PRXDownloadProgress* progress = [[PRXDownloadProgress alloc] initWithTotalSize:@(-1) andDownloadedSize:@(0)];
        [self addQueueItems:item andProgress:progress forIdentifier:identifierString];
        if (process == true) {
            [self postDownloadStateUpdatedNotification];
            [task resume];
        }
    }
}

- (void)addQueueItems:(PRXDownloadItem*)item andProgress:(PRXDownloadProgress*)progress forIdentifier:(NSString*)key
{
    dispatch_sync(self.downloaderQueue, ^{
        [self.downloadingDict setObject:item forKey:key];
        [self.progressDict setObject:progress forKey:key];
    });
}

- (BOOL)objectExistsForDownload:(NSString*)downloadURL
{
    id object = [self.downloadingDict objectForKey:downloadURL];
    if (object != nil) {
        return YES;
    }
    else {
        return FALSE;
    }
}

- (BOOL)currentlyDownloading
{
    NSDictionary* dict = [self currentQueueItems];
    NSArray* items = dict.allValues;
    if (items.count == 0) {
        return NO;
    }
    else {
        return YES;
    }
}

#pragma mark download end of life

- (void)downloadFinished:(PRXDownloadItem*)downloadItem withDownloadedLocation:(NSURL*)downloadedFileLocation
{
    NSURL* locationToMoveTo = [downloadItem locationToDownloadTo];
    NSFileManager* manager = [NSFileManager defaultManager];
    NSError* fileMoveError;
    [manager moveItemAtURL:downloadedFileLocation toURL:locationToMoveTo error:&fileMoveError];
    if (fileMoveError) {
        NSLog(@"There was an error moving the file: %@", fileMoveError.localizedDescription);
        if (downloadItem.concludedBlock != nil) {
            downloadItem.concludedBlock(false);
        }
    }
    else {
        if (downloadItem.concludedBlock != nil) {
            downloadItem.concludedBlock(true);
        }
    }
    [self clearItemWithIdentifier:downloadItem.downloadURLString];
    [self postDownloadStateUpdatedNotification];
}

#pragma mark downloading amount updated

- (void)downloadingItemIncremented:(int64_t)totalWritten withExpectedSize:(int64_t)expectedSize andIdentifier:(NSString*)identifier
{
    NSNumber* downloadedSize = [NSNumber numberWithUnsignedLongLong:totalWritten];
    NSNumber* totalSize = [NSNumber numberWithUnsignedLongLong:expectedSize];
    PRXDownloadProgress* progress = [[PRXDownloadProgress alloc] initWithTotalSize:totalSize andDownloadedSize:downloadedSize];
    dispatch_sync(self.downloaderQueue, ^{
        [self.progressDict setObject:progress forKey:identifier];
        //if I want to potentially I could post the notification here?
    });
}

#pragma mark NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession*)session downloadTask:(NSURLSessionDownloadTask*)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSString* identifier = downloadTask.originalRequest.URL.absoluteString;
    [self downloadingItemIncremented:totalBytesWritten withExpectedSize:totalBytesExpectedToWrite andIdentifier:identifier];
}

- (void)URLSession:(NSURLSession*)session downloadTask:(NSURLSessionDownloadTask*)downloadTask didFinishDownloadingToURL:(NSURL*)location
{
    NSString* identifier = downloadTask.originalRequest.URL.absoluteString;
    if (self.downloadingDict[identifier] != nil) {
        NSLog(@"Did finish downloading this item to the right location now");
        PRXDownloadItem* item = self.downloadingDict[identifier];
        [self downloadFinished:item withDownloadedLocation:location];
    }
    else {
        NSLog(@"There was no item for this download task");
    }
}

#pragma mark NSURLSessionTaskDelegate

//http://danieltull.co.uk/blog/2014/08/04/notes-on-nsurlsession-task/ cop this, this method is fucked
- (void)URLSession:(NSURLSession*)session task:(NSURLSessionTask*)task didCompleteWithError:(NSError*)error
{
    BOOL downloadSucceeded;
    if (error) {
        NSLog(@"The download task failed");
        NSLog(@"The reason for the download failure was: %@", error.localizedDescription);
        downloadSucceeded = NO;
    }
    else {
        NSLog(@"Task did complete with error was called but there was no error object, so we are assuming the downloaded data is somewhat valid");
        downloadSucceeded = YES;
    }

    NSString* identifier = task.originalRequest.URL.absoluteString;
    if (self.downloadingDict[identifier] != nil) {
        PRXDownloadItem* item = self.downloadingDict[identifier];
        if (item.concludedBlock != nil) {
            item.concludedBlock(downloadSucceeded);
        }
        //        item.concludedBlock(false);
        [self clearItemWithIdentifier:identifier];
    }
}

#pragma mark progress accessors

- (PRXDownloadProgress*)progressItemForURL:(NSString*)urlString
{
    NSDictionary* dict = [self currentProgressItems];
    if (dict[urlString]) {
        return dict[urlString];
    }
    return nil;
}

- (PRXDownloadItem*)downloadItemForURL:(NSString*)urlString
{
    NSDictionary* dict = [self currentQueueItems];
    if (dict[urlString]) {
        return dict[urlString];
    }
    return nil;x
}

#pragma mark Notification mechanisms

- (void)postDownloadStateUpdatedNotification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:DOWNLOADS_CHANGED object:nil];
    });
}
@end
