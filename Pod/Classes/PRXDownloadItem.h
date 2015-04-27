//
//  PRXDownloadItem.h
//  PRXDownloader
//
//  Created by Dan Nolan on 8/04/2015.
//  Copyright (c) 2015 Dan Nolan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DownloadConcluded)(BOOL success);

@interface PRXDownloadItem : NSObject

@property (nonatomic, readonly) NSURL* downloadURL;
@property (nonatomic, readonly) NSURL* locationToDownloadTo;
@property (nonatomic, readonly) NSDate* downloadStartDate;
@property (nonatomic, readonly) NSString* fileName;
@property (nonatomic, copy) DownloadConcluded concludedBlock;

- (instancetype)initDownloadItemInDocumentsDirectoryWithURL:(NSURL*)url fileName:(NSString*)fileName andConcludeBlock:(DownloadConcluded)concluded;
- (instancetype)initWithRemoteURL:(NSURL*)remoteURL locationToDownloadTo:(NSURL*)localLocation fileName:(NSString*)fileName andConcludeBlock:(DownloadConcluded)concluded;
- (NSString*)downloadURLString;

//Exposed for testing
+ (NSString*)fileDownloadLocationInDocuments:(NSString*)fileName;

//@prperty (nonatomic, readonly) NSString *downloadIdentifier;
//@property (nonatomic, readonly)

@end
