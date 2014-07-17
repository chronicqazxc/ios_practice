//
//  FBLoginTestAppDelegate.h
//  FBLoginTest
//
//  Created by Wayne on 4/3/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@class FBLoginTestAppDelegate;
@class LoadingView;

FBLoginTestAppDelegate *gAppDelegate;

@interface FBLoginTestAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoadingView *loadingView;

-(void) startLoading;
-(void) stopLoading;

@end
