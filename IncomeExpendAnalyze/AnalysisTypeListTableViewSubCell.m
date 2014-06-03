//
//  AnalysisTypeListTableViewSubCell.m
//  IncomeExpendAnalyze
//
//  Created by Wayne on 5/29/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "AnalysisTypeListTableViewSubCell.h"

@implementation AnalysisTypeListTableViewSubCell

- (void)drawRect:(CGRect)rect {
    self.layer.borderColor = [UIColor purpleColor].CGColor;
    self.layer.borderWidth = 1.0;
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_title release];
    [super dealloc];
}
@end
