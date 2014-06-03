//
//  ParseOperation.h
//  ParsingXMLTest
//
//  Created by Wayne on 4/6/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDXML.h"

@interface ParseOperation : NSObject

@property (strong, nonatomic) NSMutableArray *result;

-(id)initWithData:(NSData *)data;

@end
