//
//  AppDelegate.h
//  LazyLoadingTest
//
//  Created by Wayne on 4/7/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseOperation.h"
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, ParseOperationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *rootViewController;

@end
