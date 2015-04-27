//
//  PRXDownloadProgressSpec.m
//  PRXDownloader
//
//  Created by Dan Nolan on 8/04/2015.
//  Copyright 2015 Dan Nolan. All rights reserved.
//

#import "Specta.h"
#import <PRXDownloader/PRXDownload.h>

SpecBegin()

    //This is the spec for the download progress testor
    describe(@"The downloader progress testy", ^{
    
    beforeAll(^{

        
    });
    
    beforeEach(^{

        
    });
    
    it(@"should allow for the creation of a download progress item", ^{
        NSNumber *fullSize = @(100);
        NSNumber *downloadedSize = @(0);
        PRXDownloadProgress *progress = [[PRXDownloadProgress alloc] initWithTotalSize:fullSize andDownloadedSize:downloadedSize];
        expect(progress).toNot.beNil;
        expect(progress.downloadTotalSize).to.equal(@(100));
        expect(progress.downloadDownloadedSize).to.equal(@(0));
    });
        
        it(@"Should return the correct state for a download being completed", ^{
            NSNumber *fullSize = @(100);
            NSNumber *downloadedSize = @(0);
            PRXDownloadProgress *progress = [[PRXDownloadProgress alloc] initWithTotalSize:fullSize andDownloadedSize:downloadedSize];
            expect(progress.downloadFinished).to.equal(false);
        });
        
        
        it(@"should return the correct state for a completed download", ^{
            NSNumber *fullSize = @(100);
            NSNumber *downloadedSize = @(100);
            PRXDownloadProgress *progress = [[PRXDownloadProgress alloc] initWithTotalSize:fullSize andDownloadedSize:downloadedSize];
            expect(progress.downloadFinished).to.equal(true);
        });
        
        it(@"should return the correct progress percentage for a download in progress", ^{
            NSNumber *fullSize = @(100);
            NSNumber *downloadedSize = @(0);
            PRXDownloadProgress *progress = [[PRXDownloadProgress alloc] initWithTotalSize:fullSize andDownloadedSize:downloadedSize];
            expect(progress.downloadedPercentage).to.equal(@(0.0));
        });
        
        it(@"should return the correct progress percentage for a download with progress", ^{
            NSNumber *fullSize = @(100);
            NSNumber *downloadedSize = @(50);
            PRXDownloadProgress *progress = [[PRXDownloadProgress alloc] initWithTotalSize:fullSize andDownloadedSize:downloadedSize];
            expect(progress.downloadedPercentage).to.equal(@(0.5));
        });
        
        it(@"should return the correct progress percentage for a download that is completed", ^{
            NSNumber *fullSize = @(100);
            NSNumber *downloadedSize = @(100);
            PRXDownloadProgress *progress = [[PRXDownloadProgress alloc] initWithTotalSize:fullSize andDownloadedSize:downloadedSize];
            expect(progress.downloadedPercentage).to.equal(@(1.0));
        });
        
    afterEach(^{

    });
    
    afterAll(^{

    });
    });

SpecEnd
