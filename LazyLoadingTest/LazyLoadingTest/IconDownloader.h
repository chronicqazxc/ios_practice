//
//  IconDownloader.h
//  LazyLoadingTest
//
//  Created by Wayne on 4/7/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MyXMLData;
@class ViewController;

@protocol IconDownloderDelegate;

@interface IconDownloader : NSObject

@property (strong, nonatomic) MyXMLData *appRecord;
@property (strong, nonatomic) NSIndexPath *indexPathInTableView;
@property (strong, nonatomic) id <IconDownloderDelegate> delegate;
@property (strong, nonatomic) NSMutableData *activeDownload;
@property (strong, nonatomic) NSURLConnection *imageConnnection;

- (void)startDownload;
- (void)cancelDownload;

@end

@protocol IconDownloderDelegate

- (void)appImageDidLoad:(NSIndexPath *)indexPath;

@end