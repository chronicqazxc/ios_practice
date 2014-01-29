//
//  DatabaseSQLite.m
//  NovelDemo
//
//  Created by Wayne on 1/15/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "DatabaseSQLite.h"

@implementation DatabaseSQLite{
    sqlite3 *database;
    NSMutableString *querySQL;
    NSString *databaseInDocumentPath;
    NSString *databaseInAppPath;
    NSString *appPath;
    NSMutableArray *resultMutableArray;
    NSArray *resultArray;
}

#pragma mark - OpenDB
// Open database
-(BOOL) openDatabase{
    // 1. Get <Home>/Documents path
    NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents"];
    
    // 2. Append database name <Home>/Documents/novel.sqlite
    databaseInDocumentPath = [documentsPath stringByAppendingPathComponent: @"novels.sqlite"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 3. Check database whether exists in <Home>/Document/novel.sqlite
    BOOL exists = [fileManager fileExistsAtPath:databaseInDocumentPath];
    
    // 4. If not exist then copy database from .app folder
    databaseInAppPath = [[NSBundle mainBundle] pathForResource:@"novels" ofType:@"sqlite"];
    if (!exists)
        [fileManager copyItemAtPath: databaseInAppPath toPath: databaseInDocumentPath error: nil];
    
    // 5. Open database
    if(sqlite3_open([databaseInDocumentPath UTF8String], &database) == SQLITE_OK)
        return 1;
    else
        return 0;
}

#pragma mark - Search titles
// Get catagories
-(NSArray *) catagories{
    resultMutableArray = [[NSMutableArray alloc] init];
    querySQL = [[NSMutableString alloc] init];
    
    if([self openDatabase]){
        [querySQL appendString: @"select title from book;"];
        const char *sql = [querySQL UTF8String];
        sqlite3_stmt *stm;
        // Excute sql statement
        sqlite3_prepare_v2(database,sql,-1,&stm,NULL);
        while(sqlite3_step(stm) == SQLITE_ROW){
            [resultMutableArray addObject:[NSString stringWithUTF8String: (char *)sqlite3_column_text(stm,0)]];
        }
        resultArray = [[NSArray alloc] initWithArray: resultMutableArray];
    }else NSLog(@"Open databse faild");
    
    return resultArray;
}

#pragma mark - Search content
// Get content by index
-(NSString *) contentForIndex: (int) index{
    NSString *result;
    querySQL = [[NSMutableString alloc] init];
    
    if([self openDatabase]){
        [querySQL appendString: @"select content from book where rowid = ?;"];
        const char *sql = [querySQL UTF8String];
        sqlite3_stmt *stm;
        // Excute sql statement
        if(sqlite3_prepare_v2(database,sql,-1,&stm,NULL) == SQLITE_OK)
            sqlite3_bind_int(stm,1,index);
        if(sqlite3_step(stm) == SQLITE_ROW)
            result = [NSString stringWithUTF8String: (char *)sqlite3_column_text(stm,0)];
    }else NSLog(@"Query faild");
    
    return result;
}

#pragma mark - Search rowid
// Get index by title
-(int) indexForTitle: (NSString *) title{
    int result = 0;
    querySQL = [[NSMutableString alloc] init];
    if([self openDatabase]){
        [querySQL appendString: @"select rowid from book where title = ?;"];
        const char *sql = [querySQL UTF8String];
        sqlite3_stmt *stm;
        // Excute sql statement
        if (sqlite3_prepare_v2(database,sql,-1,&stm,NULL) == SQLITE_OK)
            sqlite3_bind_text(stm,1,[title UTF8String],-1,SQLITE_TRANSIENT);
        if(sqlite3_step(stm) == SQLITE_ROW)
            result = (int) sqlite3_column_int(stm, 0);
    }else NSLog(@"Query faild");
    return result;
}

#pragma mark - Search title by index
// Get title by index
-(NSString *) titleForIndex: (int) index{
    NSString *result;
    querySQL = [[NSMutableString alloc] init];
    
    if([self openDatabase]){
        [querySQL appendString: @"select title from book where rowid = ?;"];
        const char *sql = [querySQL UTF8String];
        sqlite3_stmt *stm;
        // Excute sql statement
        if( sqlite3_prepare_v2(database,sql,-1,&stm,NULL) == SQLITE_OK)
            sqlite3_bind_int(stm, 1, index);
        if(sqlite3_step(stm) == SQLITE_ROW)
            result = [NSString stringWithUTF8String: (char *)sqlite3_column_text(stm,0)];
    }else NSLog(@"Query faild");
    
    return result;
}

#pragma mark - Search titles by input
-(NSArray *) titlesByInput: (NSString *) inputString{
    resultMutableArray = [[NSMutableArray alloc] init];
    querySQL = [[NSMutableString alloc] init];
    
    if([self openDatabase]){
        [querySQL appendString: @"select title from book where title like '%"];
        [querySQL appendString: inputString];
        [querySQL appendString: @"%';"];
        const char *sql = [querySQL UTF8String];
        sqlite3_stmt *stm;
        // Excute sql statemant
        if(sqlite3_prepare_v2(database,sql,strlen(sql),&stm,NULL) == SQLITE_OK){
            while(sqlite3_step(stm) == SQLITE_ROW){
                [resultMutableArray addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(stm,0)]];
            }
        }
        resultArray = [[NSArray alloc] initWithArray:resultMutableArray];
    }else NSLog(@"Open database faild");
    return resultArray;
}

#pragma mark - Search content by input
-(NSArray *) contentsByInput: (NSString *) inputString{
    resultMutableArray = [[NSMutableArray alloc] init];
    querySQL = [[NSMutableString alloc] init];
    
    if([self openDatabase]){
        [querySQL appendString: @"select title from book where content like '%"];
        [querySQL appendString:inputString];
        [querySQL appendString: @"%'"];
        const char *sql = [querySQL UTF8String];
        sqlite3_stmt *stm;
        // Excute sql statement
        if(sqlite3_prepare_v2(database,sql,-1,&stm,NULL) == SQLITE_OK){
            while(sqlite3_step(stm) == SQLITE_ROW){
                [resultMutableArray addObject:[NSString stringWithUTF8String:(char *) sqlite3_column_text(stm,0)]];
            }
        }
        resultArray = [[NSArray alloc] initWithArray:resultMutableArray];
    }else NSLog(@"Open database faild");
    return resultArray;
}
@end
