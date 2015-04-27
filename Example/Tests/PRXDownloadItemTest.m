//
//  PRXDownloadItemTest.m
//  PRXDownloader
//
//  Created by Dan Nolan on 8/04/2015.
//  Copyright (c) 2015 Dan Nolan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <PRXDownloader/PRXDownload.h>
//#import "PRXd

@interface PRXDownloadItemTest : XCTestCase

@end

@implementation PRXDownloadItemTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDownloadItemCreation
{
    NSURL* downloadURL = [NSURL URLWithString:@"http://www.google.com/favicon.ico"];
    NSString* fileName = @"favicon.ico";
    PRXDownloadItem* item = [[PRXDownloadItem alloc] initDownloadItemInDocumentsDirectoryWithURL:downloadURL fileName:fileName andConcludeBlock:^(BOOL success) {
        NSLog(@"The download was a success");
    }];
    XCTAssertNotNil(item, @"The item should not be nil");
    XCTAssertTrue([item.downloadURL.absoluteString isEqualToString:downloadURL.absoluteString], @"The URLs should be equivalent");
}

- (void)testDocumentsFolderItemCreation
{
    NSString* downloadDirectoryString = [PRXDownloadItem fileDownloadLocationInDocuments:@"downloadedfile.txt"];
    NSURL* downloadLocationURL = [NSURL fileURLWithPath:downloadDirectoryString];
    NSURL* downloadURL = [NSURL URLWithString:@"http://www.google.com/favicon.ico"];
    NSString* fileName = @"favicon.ico";

    PRXDownloadItem* item = [[PRXDownloadItem alloc] initWithRemoteURL:downloadURL locationToDownloadTo:downloadLocationURL fileName:fileName andConcludeBlock:nil];
    XCTAssertNotNil(item, @"The created item should not be nil");
}

@end
