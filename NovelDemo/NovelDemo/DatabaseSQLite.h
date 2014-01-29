//
//  DatabaseSQLite.h
//  NovelDemo
//
//  Created by Wayne on 1/15/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DatabaseSQLite : NSObject
// Get catagories
-(NSArray *) catagories;
// Get content by index
-(NSString *) contentForIndex: (int) index;
// Get index by title
-(int) indexForTitle: (NSString *)title;
// Get title by index
-(NSString *) titleForIndex: (int) index;
// Get title by input
-(NSArray *) titlesByInput: (NSString *) inputString;
// Get content by input
-(NSArray *) contentsByInput: (NSString *) inputString;
@end
