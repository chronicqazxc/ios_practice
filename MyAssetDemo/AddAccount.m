//
//  AddAccount.m
//  MyAssetDemo
//
//  Created by Wayne on 4/11/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "AddAccount.h"
#import <sqlite3.h>
#import "Account.h"
#import "GetDB.h"
#import "NSData+Encryption.h"

char *sql = "insert into Account values(?,?,?);" ;

@interface AddAccount(){
    sqlite3 *myAssetDB;
    sqlite3_stmt *insert_statement;
}

@end

@implementation AddAccount

+ (BOOL)addAccountWithAccount:(Account *)account{
    AddAccount *addAccount =  [[self alloc] init];
    return [addAccount addAccountWithAccount:account];
}

- (BOOL)addAccountWithAccount:(Account *)account{
    myAssetDB = [GetDB getDB];
    
    return [self executedInsertWithAccount:account];
}

- (BOOL)executedInsertWithAccount:(Account *)account{
    
    [self prepareInsertWithAccount:account];
    
    return [self execInsert];
}

- (void)prepareInsertWithAccount:(Account *)account{
    insert_statement = nil;
    int RESULT = sqlite3_prepare_v2(myAssetDB, sql, -1, &insert_statement, NULL);
    if(RESULT != SQLITE_OK)
    {
        //handle error
        NSLog(@"error happen");
        return;
    }
    
    [self encryptPasswordWithAccount:account];
    
    sqlite3_bind_text(insert_statement, 1, [account.user_id UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement, 2, [account.user_name UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_blob(insert_statement, 3, [account.user_password bytes], [account.user_password length], NULL);
}

- (void)encryptPasswordWithAccount:(Account *)account{
    
    account.user_password = [account.user_password AES256EncryptWithKey:[[NSString alloc] initWithData:account.user_password encoding:NSUTF8StringEncoding]];
    
}

- (BOOL)execInsert{
    double reValue = sqlite3_step(insert_statement);
    if (reValue == SQLITE_DONE){
        return YES;
    }
    return NO;
}
@end
