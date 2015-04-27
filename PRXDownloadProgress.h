//
//  PRXDownloadProgress.h
//  PRXDownloader
//
//  Created by Dan Nolan on 8/04/2015.
//  Copyright (c) 2015 Dan Nolan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRXDownloadProgress : NSObject

@property (nonatomic, readonly) NSNumber* downloadTotalSize;
@property (nonatomic, readonly) NSNumber* downloadDownloadedSize;

- (instancetype)initWithTotalSize:(NSNumber*)totalSize andDownloadedSize:(NSNumber*)downloadedSize;
- (BOOL)downloadFinished;
- (NSNumber*)downloadedPercentage;

@end
