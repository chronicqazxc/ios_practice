//
//  ParseOperation.h
//  LazyLoadingTest
//
//  Created by Wayne on 4/7/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchXML.h"

@protocol ParseOperationDelegate;

@interface ParseOperation : NSOperation

@property (strong, nonatomic) NSMutableArray *results;

- (id)initWithData:(NSData *)data delegate:(id <ParseOperationDelegate>)theDelegate;

@end

@protocol ParseOperationDelegate
- (void)didFinishParsing:(NSArray *)appList;
- (void)parseErrorOccurred:(NSError *)error;
@end