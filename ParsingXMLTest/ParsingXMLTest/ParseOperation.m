//
//  ParseOperation.m
//  ParsingXMLTest
//
//  Created by Wayne on 4/6/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ParseOperation.h"
#import "MyXMLData.h"

@implementation ParseOperation

- (id)initWithData:(NSData *)data{
    if(self = [super init]){
        _result = [[NSMutableArray alloc]init];
        [self parsingData:data];
    }
    return self;
}

- (void)parsingData:(NSData *)data{
    NSString* xmlStr = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    xmlStr = [xmlStr stringByReplacingOccurrencesOfString:@"xmlns" withString:@"noNSxml"];
    
    NSError* error = nil;
    DDXMLDocument* xmlDoc = [[DDXMLDocument alloc] initWithXMLString:xmlStr options:0 error:&error];
    
    if (error) {
        NSLog(@"%@",[error localizedDescription]);
        
    }
    
    NSArray *xmlItems = [xmlDoc nodesForXPath:@"rss/channel/item" error:&error];
    int count = (int)[xmlItems count];
    
    [_result removeAllObjects];
    
    for (int i=0; i < count; i++) {
        
        MyXMLData *xmlData = [[MyXMLData alloc] init];
        
        DDXMLNode *child = [xmlItems objectAtIndex:i];
        xmlData.title = [[child childAtIndex:0] stringValue];
        xmlData.link = [[child childAtIndex:1] stringValue];
        xmlData.description = [[child childAtIndex:2] stringValue];
        xmlData.author = [[child childAtIndex:3] stringValue];
        
        [_result addObject:xmlData];
    }
    
}
@end
