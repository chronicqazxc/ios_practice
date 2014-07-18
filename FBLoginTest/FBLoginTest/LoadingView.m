//
//  LoadingView.m
//  FBLoginTest
//
//  Created by Wayne on 4/21/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    UIActivityIndicatorView *indicator = indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    
    [indicator setCenter:CGPointMake(160.0f,208.0f)];
    
    indicator.color = [UIColor whiteColor];
    
    [self addSubview: indicator];
    
    [indicator startAnimating];
    
    [self addSubview:indicator];
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
