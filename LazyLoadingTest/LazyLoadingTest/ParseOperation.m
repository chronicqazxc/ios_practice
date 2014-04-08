//
//  ParseOperation.m
//  LazyLoadingTest
//
//  Created by Wayne on 4/7/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ParseOperation.h"
#import "MyXMLData.h"

@interface ParseOperation(){
    
    id <ParseOperationDelegate> delegate;
}
@end

@implementation ParseOperation

- (id)initWithData:(NSData *)data delegate:(id <ParseOperationDelegate>)theDelegate{
    if(self = [super init]){
        
        _results = [[NSMutableArray alloc]init];
        delegate = theDelegate;
        [self parsingData:data];
    }
    
    return self;
}

- (void)parsingData:(NSData *)data{
    
    NSString *xmlStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    xmlStr = [xmlStr stringByReplacingOccurrencesOfString:@"xmlns" withString:@"noxmlns"];
    
    NSError *error = nil;
    
    CXMLDocument *xmlDoc = [[CXMLDocument alloc] initWithXMLString:xmlStr options:0 error:&error];
    
    if(error){
        NSLog(@"%@",[error localizedDescription]);
    }
    
    
    NSArray *xmlItems = NULL;
    
    xmlItems = [xmlDoc nodesForXPath:@"feed/entry" error:&error];
    
    int count = [xmlItems count];
    
    [_results removeAllObjects];
    
    for(int i=0; i<count; i++){
        
        MyXMLData *xmlData = [[MyXMLData alloc]init];
        
        CXMLElement *child = xmlItems[i];
        
        xmlData.idStr = [[child childAtIndex:3] stringValue];
        xmlData.nameStr = [[child childAtIndex:5] stringValue];
        xmlData.imageStr = [[child childAtIndex:25] stringValue];
        xmlData.artistStr = [[child childAtIndex:17] stringValue];
        
        [_results addObject:xmlData];
    }
    
    [delegate didFinishParsing:_results];
    
}
@end
