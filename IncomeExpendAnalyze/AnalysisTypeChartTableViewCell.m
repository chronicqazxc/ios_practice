//
//  AnalysisTypeChartTableViewCell.m
//  IncomeExpendAnalyze
//
//  Created by Wayne on 5/29/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "AnalysisTypeChartTableViewCell.h"

@implementation AnalysisTypeChartTableViewCell

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
    [_btnInfo release];
    [super dealloc];
}
@end
