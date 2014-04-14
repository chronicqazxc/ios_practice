//
//  Search.h
//  MyAssetDemo
//
//  Created by Wayne on 4/12/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"
#import "DateTime.h"

@interface Search : NSObject

+ (Account *)queryAccountWithUserID:(NSString *)userID;
+ (NSMutableArray *)queryDateTimeWithUserID:(NSString *)userID;

@end
