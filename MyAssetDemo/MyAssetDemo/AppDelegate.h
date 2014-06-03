//
//  AppDelegate.h
//  MyAssetDemo
//
//  Created by Wayne on 4/11/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) sqlite3 *myAssetDB;

@end
