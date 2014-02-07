//
//  RSSReader.h
//  RSSReaderDemo2
//
//  Created by Wayne on 1/10/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>

// indicater tags
// tagTitle       = <title>
// tagLink        = <link>
// tagDescription = <description>
// tagUnknow      = unknow
typedef enum{
    tagTitle,
    tagLink,
    tagDescription,
    tagUnknow
}RSSTag;

@interface RSSReader : NSObject <NSXMLParserDelegate>{
    // every news
    NSMutableDictionary *item;
    
    // tag parsed currently
    RSSTag currentTag;
    
    // is start to parse
    BOOL startItem;
}

// news after parsed
@property (nonatomic,retain) NSMutableArray *result;
-(id) initWithData: (NSData *) data;

@end
