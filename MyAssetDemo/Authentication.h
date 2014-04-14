//
//  Authentication.h
//  MyAssetDemo
//
//  Created by Wayne on 4/11/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Account;

@interface Authentication : NSObject

+ (BOOL)authenticateAccount:(Account *)account withPassword:(NSString *)password;

+ (BOOL)authenticateUserID:(NSString *)userID;

+ (NSData *)encrypteData:(NSString *)data withKey:(NSString *)key;

@end
