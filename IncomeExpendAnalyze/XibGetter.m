//
//  XibGetter.m
//  IncomeExpendAnalyze
//
//  Created by Wayne on 5/29/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "XibGetter.h"

@implementation XibGetter

+ (id)getCustomViewByName:(NSString *)name{
    XibGetter *xibGetter = [[XibGetter alloc] init];
    [xibGetter release];
    return [xibGetter getCustomViewByName:name];
}

- (id)getCustomViewByName:(NSString *)name{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil];
    Class customClass = NSClassFromString(name);
    UIView *view;
    for(view in views){
        if([view isKindOfClass:[customClass class]]){
            break;
        }
    }
    return view;
}

@end
