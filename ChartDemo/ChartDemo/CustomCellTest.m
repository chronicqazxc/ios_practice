//
//  CustomCellTest.m
//  ChartDemo
//
//  Created by Wayne on 5/22/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "CustomCellTest.h"

@implementation CustomCellTest

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickButton:(id)sender {
    NSLog(@"click button");
}
@end
