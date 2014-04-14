//
//  Search.m
//  MyAssetDemo
//
//  Created by Wayne on 4/12/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "Search.h"
#import <sqlite3.h>
#import "GetDB.h"

char *sqlchar = "select user_id, user_name, user_password from Account where user_id = ?;" ;
char *sqlSearchForDateTime = "select date_time, user_id, item, price from DateTime where user_id = ? order by date_time desc;";

@interface Search(){
    sqlite3 *myAssetDB;
    sqlite3_stmt *stmt;
    Account *account;
    DateTime *dateTime;
    NSMutableArray *dateTimes;
}

@end

@implementation Search

+ (Account *)queryAccountWithUserID:(NSString *)userID{
    Search *query = [[Search alloc] init];
    
    return [query queryAccountWithUserID:(NSString *)userID];
}

- (Account *)queryAccountWithUserID:(NSString *)userID{
    
    [self prepareForQueryWithUserID:userID];
    
    [self executeQuery];
    
    if (account)
        return account;
    else
        return nil;
}

- (void)prepareForQueryWithUserID:(NSString *)userID{
    stmt = nil;
    
    myAssetDB = [GetDB getDB];
    
    account = [[Account alloc] init];
    
    int result = sqlite3_prepare_v2(myAssetDB, sqlchar, -1, &stmt, NULL);
    
    if(result == SQLITE_OK)
        sqlite3_bind_text(stmt, 1, [userID UTF8String], -1, SQLITE_TRANSIENT);
}

- (void)executeQuery{
    
    while(sqlite3_step(stmt) == SQLITE_ROW){
        account.user_id       = [NSString stringWithUTF8String: (char *) sqlite3_column_text(stmt, 0)];
        account.user_name     = [NSString stringWithUTF8String: (char *) sqlite3_column_text(stmt, 1)];
        account.user_password = [[NSData alloc] initWithBytes: sqlite3_column_blob(stmt, 2) length: sqlite3_column_bytes(stmt, 2)];
    }
}

#pragma mark -
#pragma mark Search for DateTime

+ (NSMutableArray *)queryDateTimeWithUserID:(NSString *)userID{
    Search *searchForDateTime = [[Search alloc] init];
   return [searchForDateTime queryDateTimeWithUserID:userID];
    
}

- (NSMutableArray *)queryDateTimeWithUserID:(NSString *)userID{
    [self prepareForQueryWithUserIDForDateTime:userID];
    
    return [self executeQueryForDateTime];
}

- (void)prepareForQueryWithUserIDForDateTime:(NSString *)userID{
    
    dateTimes = [[NSMutableArray alloc] init];
    
    stmt = nil;
    
    myAssetDB = [GetDB getDB];
    
    
    int result = sqlite3_prepare_v2(myAssetDB, sqlSearchForDateTime, -1, &stmt, NULL);
    
    if(result == SQLITE_OK)
        sqlite3_bind_text(stmt, 1, [userID UTF8String], -1, SQLITE_TRANSIENT);
}

- (NSMutableArray *)executeQueryForDateTime{
    
    while(sqlite3_step(stmt) == SQLITE_ROW){
        
        dateTime = [[DateTime alloc] init];
        
        dateTime.date       = [NSString stringWithUTF8String: (char *) sqlite3_column_text(stmt, 0)];
        dateTime.userID     = [NSString stringWithUTF8String: (char *) sqlite3_column_text(stmt, 1)];
        dateTime.item       = [NSString stringWithUTF8String: (char *) sqlite3_column_text(stmt, 2)];
        dateTime.cost       = [NSString stringWithFormat:@"%d", sqlite3_column_int(stmt, 3)];
        
        [dateTimes addObject:dateTime];
    }
    
    return dateTimes;
}

@end
