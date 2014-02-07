//
//  AppDelegate.h
//  AccessImageWithDBTest
//
//  Created by Wayne on 2/7/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
-(sqlite3 *)getDB;
@property (strong, nonatomic) UIWindow *window;

@end
