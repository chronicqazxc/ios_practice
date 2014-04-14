//
//  Authentication.m
//  MyAssetDemo
//
//  Created by Wayne on 4/11/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "Authentication.h"
#import "AppDelegate.h"
#import <sqlite3.h>
#import "Account.h"
#import "NSData+Encryption.h"
#import "GetDB.h"

const NSString *sqlString = @"select user_id, user_name, user_password from Account where user_id = ?";

@interface Authentication(){
    sqlite3 *myAssetDB;
    const char *sqlChar;
    sqlite3_stmt *stmt;
    Account *account;
    NSData *plain;
}

@end

@implementation Authentication

+ (BOOL)authenticateAccount:(Account *)account withPassword:(NSString *)password{
    
    Authentication *authenticate = [[Authentication alloc] init];
    return [authenticate authenticateAccount:account withPassword:password];
}

+ (BOOL)authenticateUserID:(NSString *)userID{
    
    Authentication *authenticate = [[Authentication alloc] init];
    return [authenticate authenticateUserID:userID];
}

- (BOOL)authenticateUserID:(NSString *)userID{
    
    account = [[Account alloc] init];
    
    myAssetDB = [GetDB getDB];
    
    [self getAccountWithUserID:userID];
    
    return [self authenticateUser:userID];
}

- (BOOL)authenticateAccount:(Account *)aAccount withPassword:(NSString *)password{
    
    account = aAccount;
    
    plain = [account.user_password AES256DecryptWithKey:password];
    
    
    NSString *answer = [[NSString alloc] initWithData:plain encoding:NSUTF8StringEncoding];
    
    if ([answer isEqualToString:password])
        return YES;
    else
        return NO;
    
}

- (void)getAccountWithUserID:(NSString *)userID{
    
    [self prepareForQueryWithUserID:userID];
    
    [self query];
}

- (void)prepareForQueryWithUserID:(NSString *)userID{
    
    sqlChar = [sqlString UTF8String];
    
    int result = sqlite3_prepare_v2(myAssetDB, sqlChar, -1, &stmt, NULL);
    
    if(result == SQLITE_OK)
        sqlite3_bind_text(stmt, 1, [userID UTF8String], -1, SQLITE_TRANSIENT);
    
}

- (void)query{
    while(sqlite3_step(stmt) == SQLITE_ROW){
        account.user_id       = [NSString stringWithUTF8String: (char *) sqlite3_column_text(stmt, 0)];
        account.user_name     = [NSString stringWithUTF8String: (char *) sqlite3_column_text(stmt, 1)];
        account.user_password = [[NSData alloc] initWithBytes: sqlite3_column_blob(stmt, 2) length: sqlite3_column_bytes(stmt, 2)];
    }
}

- (BOOL)authenticateUser:(NSString *)userID{
    if ([userID isEqualToString:account.user_id]){
        NSLog(@"User ID duplicate");
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark Encrypte data

+ (NSData *)encrypteData:(NSString *)data withKey:(NSString *)key{
    Authentication *authentication = [[Authentication alloc] init];
    return [authentication encrypteData:data withKey:key];
}

- (NSData *)encrypteData:(NSString *)data withKey:(NSString *)key{
    
    NSData *cipher;
    
    plain = [data dataUsingEncoding:NSUTF8StringEncoding];
    cipher = [plain AES256EncryptWithKey:key];
    
    return cipher;
    
}
@end
