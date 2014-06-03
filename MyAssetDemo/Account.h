//
//  Account.h
//  MyAssetDemo
//
//  Created by Wayne on 4/11/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject

@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *user_name;
@property (strong, nonatomic) NSData   *user_password;

@end
