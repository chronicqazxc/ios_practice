//
//  FriendCell.h
//  FBLoginTest
//
//  Created by Wayne on 4/8/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FriendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet FBProfilePictureView *icon;
@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UILabel *brithday;

@end
