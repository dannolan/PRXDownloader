//
//  PRXDownloadProgress.m
//  PRXDownloader
//
//  Created by Dan Nolan on 8/04/2015.
//  Copyright (c) 2015 Dan Nolan. All rights reserved.
//

#import "PRXDownloadProgress.h"

@interface PRXDownloadProgress ()
@property (nonatomic, readwrite) NSNumber* downloadTotalSize;
@property (nonatomic, readwrite) NSNumber* downloadDownloadedSize;
@end

@implementation PRXDownloadProgress

- (instancetype)initWithTotalSize:(NSNumber*)totalSize andDownloadedSize:(NSNumber*)downloadedSize
{
    self = [[PRXDownloadProgress alloc] init];
    self.downloadTotalSize = totalSize;
    self.downloadDownloadedSize = downloadedSize;
    return self;
}

- (BOOL)downloadFinished
{
    return [self.downloadTotalSize isEqualToNumber:self.downloadDownloadedSize];
}

- (NSNumber*)downloadedPercentage
{
    NSNumber* downloadedAmount = @(self.downloadDownloadedSize.doubleValue / self.downloadTotalSize.doubleValue);
    return downloadedAmount;
}

@end
