//
//  AlbumTableViewController.h
//  FBLoginTest
//
//  Created by Wayne on 4/21/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownload.h"

@class People, Photo, Friend;

@interface AlbumTableViewController : UITableViewController <ImageDownloadDelegate>

@property (strong, nonatomic) People *likedPeople;
@property (strong, nonatomic) Photo  *photos;
@property (strong, nonatomic) Friend *theFriend;

@end
