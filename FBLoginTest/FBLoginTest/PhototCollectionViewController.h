//
//  PhototCollectionViewController.h
//  FBLoginTest
//
//  Created by Wayne on 4/22/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownload.h"

@class People, Photo, Friend, Album;

@interface PhototCollectionViewController : UICollectionViewController <ImageDownloadDelegate>

@property (strong, nonatomic) People *likedPeople;
@property (strong, nonatomic) Photo  *photos;
@property (strong, nonatomic) Friend *theFriend;
@property (strong, nonatomic) Album  *album;

@end
