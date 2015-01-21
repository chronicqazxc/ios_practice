//
//  AppDelegate.m
//  ScrollAndZoomingView
//
//  Created by Wayne on 1/21/15.
//  Copyright (c) 2015 Wayne. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.viewController = nil;
    self.imageViews = [NSMutableArray array];
    // Override point for customization after application launch.
    dispatch_queue_t myQueue = dispatch_queue_create("Download images",NULL);
    dispatch_async(myQueue, ^{
        // Perform long running process
        NSData *data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: @"http://static.adzerk.net/Advertisers/d47c809dea6241b9933a81fe1d0f7085.jpg"]];
        NSData *data2 = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: @"https://www.gravatar.com/avatar/01a51566f6163e6e9608b7c1f80ec258?s=32&d=identicon&r=PG"]];
        NSData *data3 = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: @"https://www.gravatar.com/avatar/92fb4563ddc5ceeaa8b19b60a7a172f4?s=32&d=identicon&r=PG"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            if (data != nil) {
                [self.imageViews addObject:[[UIImageView alloc] initWithImage:[UIImage imageWithData: data]]];
                [self.imageViews addObject:[[UIImageView alloc] initWithImage:[UIImage imageWithData: data2]]];
                [self.imageViews addObject:[[UIImageView alloc] initWithImage:[UIImage imageWithData: data3]]];
                if (self.viewController) {
                    [self.viewController reloadImage:0 withImages:self.imageViews];
                }
            } else {
                return;
            }
        });
    });
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
