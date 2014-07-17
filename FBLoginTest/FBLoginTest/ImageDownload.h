//
//  ImageDownload.h
//  FBLoginTest
//
//  Created by Wayne on 4/17/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Photo, ViewController;

@protocol ImageDownloadDelegate;

@interface ImageDownload : NSObject

@property (strong, nonatomic) Photo *photo;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) id <ImageDownloadDelegate> delegate;
@property (strong, nonatomic) NSMutableData *activeDownload;
@property (strong, nonatomic) NSURLConnection *imageConnection;

- (void)startDownload;
- (void)cancelDownload;

@end

@protocol ImageDownloadDelegate <NSObject>

- (void)appImageDidLoad:(NSIndexPath *)indexPath;

@end
