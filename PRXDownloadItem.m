//
//  PRXDownloadItem.m
//  PRXDownloader
//
//  Created by Dan Nolan on 8/04/2015.
//  Copyright (c) 2015 Dan Nolan. All rights reserved.
//

#import "PRXDownloadItem.h"
@interface PRXDownloadItem ()
@property (nonatomic, readwrite) NSURL* downloadURL;
@property (nonatomic, readwrite) NSURL* locationToDownloadTo;
@property (nonatomic, readwrite) NSDate* downloadStartDate;
@property (nonatomic, readwrite) NSString* fileName;
@end

@implementation PRXDownloadItem

+ (NSString*)documentsDirectoryPath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+ (NSString*)fileDownloadLocationInDocuments:(NSString*)fileName
{
    NSString* documentsDirectory = [PRXDownloadItem documentsDirectoryPath];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

- (instancetype)initDownloadItemInDocumentsDirectoryWithURL:(NSURL*)url fileName:(NSString*)fileName andConcludeBlock:(DownloadConcluded)concluded
{
    self = [[PRXDownloadItem alloc] init];
    self.downloadURL = url;
    self.fileName = fileName;
    self.concludedBlock = concluded;
    self.locationToDownloadTo = [NSURL URLWithString:[PRXDownloadItem fileDownloadLocationInDocuments:fileName]];
    self.downloadStartDate = [[NSDate alloc] init];
    return self;
}

- (instancetype)initWithRemoteURL:(NSURL*)remoteURL locationToDownloadTo:(NSURL*)localLocation fileName:(NSString*)fileName andConcludeBlock:(DownloadConcluded)concluded
{
    self = [[PRXDownloadItem alloc] init];
    self.downloadURL = remoteURL;
    self.locationToDownloadTo = localLocation;
    self.fileName = fileName;
    self.concludedBlock = concluded;
    self.downloadStartDate = [[NSDate alloc] init];
    return self;
}

- (NSString*)downloadURLString
{
    return self.downloadURL.absoluteString;
}

@end
