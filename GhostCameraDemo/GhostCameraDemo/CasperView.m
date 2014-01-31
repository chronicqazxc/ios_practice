//
//  CasperView.m
//  GhostCameraDemo
//
//  Created by Wayne on 1/20/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "CasperView.h"

@implementation CasperView

-(void) notifyTakePicture:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TakePictureNotofy" object:nil];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIButton *shot = [[UIButton alloc] initWithFrame:CGRectMake(120,380,80,80)];
        [shot setImage:[UIImage imageNamed:@"lens.png"] forState:UIControlStateNormal];
        
        // Call notifyTakePicture by touch button
        [shot addTarget:self action:@selector(notifyTakePicture:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: shot];
    }
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
