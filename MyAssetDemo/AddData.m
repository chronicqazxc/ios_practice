//
//  AddData.m
//  MyAssetDemo
//
//  Created by Wayne on 4/13/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "AddData.h"
#import <sqlite3.h>
#import "GetDB.h"

char *sqlForAddData = "insert into DateTime values (?,?,?,?)" ;

@interface AddData(){
    
    sqlite3 *myAssetDB;
    sqlite3_stmt *insert_statement;
}
@end

@implementation AddData

+ (BOOL)addDateWithDateTime:(DateTime *)dateTime{
    AddData *addData = [[AddData alloc] init];
   return  [addData addDateWithDateTime:dateTime];
}

- (BOOL)addDateWithDateTime:(DateTime *)dateTime{
    myAssetDB = [GetDB getDB];
    
    return [self executedInsertWithDateTime:dateTime];
}

- (BOOL)executedInsertWithDateTime:(DateTime *)dateTime{
    [self prepareWithDateTime:dateTime];
    
    return [self execInsert];
}

- (void)prepareWithDateTime:(DateTime *)dateTime{
    insert_statement = nil;
    int RESULT = sqlite3_prepare_v2(myAssetDB, sqlForAddData, -1, &insert_statement, NULL);
    
    if (RESULT != SQLITE_OK){
        NSLog(@"error happen");
        return;
    }
    
    sqlite3_bind_text(insert_statement, 1, [dateTime.date UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement, 2, [dateTime.userID UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement, 3, [dateTime.item UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(insert_statement, 4, [dateTime.cost intValue]);
    
    
}

- (BOOL)execInsert{
    double reValue = sqlite3_step(insert_statement);
    if (reValue == SQLITE_DONE)
        return YES;
    else
        return NO;
}

@end
