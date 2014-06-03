//
//  GetDB.h
//  MyAssetDemo
//
//  Created by Wayne on 4/11/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface GetDB : NSObject

+(sqlite3 *)getDB;

@end
