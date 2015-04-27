//
//  PRXDownloader.h
//  PRXDownloader
//
//  Created by Dan Nolan on 8/04/2015.
//  Copyright (c) 2015 Dan Nolan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PRXDownloadItem.h"
#import "PRXDownloadProgress.h"
#import "PRXDownloaderConstants.h"

@interface PRXDownloader : NSObject
+ (instancetype)defaultDownloader;

- (void)addDownloadItemWithURL:(NSURL*)url fileName:(NSString*)fileName andSaveLocation:(NSURL*)saveLocation andCompleteBlock:(DownloadConcluded)concluded;
- (void)addDownloadItem:(PRXDownloadItem*)item;

//Accessors to internal values
- (NSDictionary*)currentProgressItems;
- (NSDictionary*)currentQueueItems;

- (BOOL)objectExistsForDownload:(NSString*)downloadURL;

- (BOOL)currentlyDownloading;






@end
