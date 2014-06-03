//
//  GetDB.m
//  MyAssetDemo
//
//  Created by Wayne on 4/11/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "GetDB.h"
#import <sqlite3.h>
#import "AppDelegate.h"

@implementation GetDB

+(sqlite3 *)getDB{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate.myAssetDB;
}

@end
