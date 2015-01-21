//
//  AppDelegate.h
//  ScrollAndZoomingView
//
//  Created by Wayne on 1/21/15.
//  Copyright (c) 2015 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *imageViews;
@property (weak, nonatomic) ViewController *viewController;
@end

