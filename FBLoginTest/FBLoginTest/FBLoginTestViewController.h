//
//  FBLoginTestViewController.h
//  FBLoginTest
//
//  Created by Wayne on 4/3/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FBLoginTestViewController : UIViewController <FBLoginViewDelegate>

@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@property (strong, nonatomic) IBOutlet FBLoginView *loginDialog;
- (IBAction)pickFriend:(UIButton *)sender;

@property (strong, nonatomic) NSMutableArray *friendsContainer;

- (IBAction)clickButton:(UIButton *)sender;
@end
