//
//  RSSReader.m
//  RSSReaderDemo2
//
//  Created by Wayne on 1/10/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "RSSReader.h"

@implementation RSSReader

-(id) initWithData: (NSData *) data{
    self = [super init];
    if (self){
        // initial result array
        self.result = [[NSMutableArray alloc] init];
        
        // initial parser
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData: data];
        parser.delegate = self;
        
        // start parse
        [parser parse];
        return self;
    }
    return self;
}

#pragma mark - NSXMLParserDelegate

// find begin tag
-(void) parser: (NSXMLParser *) parser didStartElement: (NSString *) elementName
  namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName
    attributes: (NSDictionary *) attributeDict{
    
    /*  <item>
     *    <title></title>
     *    <link></link>
     *    <description></description>
     *  </item>
     */
    
    if( [elementName isEqualToString: @"item"] ){
        startItem = 1;
        item = [NSMutableDictionary new];
    }
    
    if (startItem){
        if ( [elementName isEqualToString: @"title"] ){
            currentTag = tagTitle;
        }else if ( [elementName isEqualToString: @"description"] ){
            currentTag = tagDescription;
        }else if ( [elementName isEqualToString: @"link"] ){
            currentTag = tagLink;
        }else{
            currentTag = tagUnknow;
        }
    }
}

// find end tag
-(void) parser: (NSXMLParser *) parser didEndElement: (NSString *) elementName
  namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName{
    if ( [elementName isEqualToString: @"item"] ){
        NSDictionary *parsedItem = [[NSDictionary alloc] initWithDictionary: item];
        [self.result addObject:parsedItem];
        item = nil;
        startItem = 0;
    }
}

// contant of XML
-(void) parser: (NSXMLParser *) parser foundCharacters: (NSString *) string {
    // trimString
    NSString *value = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ( [value length] == 0 || currentTag == tagUnknow ){
        return;
    }
    
    if (startItem){
    switch (currentTag){
        case tagTitle:
            [item setValue: value forKey:@"title"];
            break;
        case tagDescription:
            [item setValue: value forKey:@"description"];
            break;
        case tagLink:
            [item setValue: value forKey:@"link"];
            break;
        default:
            break;
    }
    }
}
@end
