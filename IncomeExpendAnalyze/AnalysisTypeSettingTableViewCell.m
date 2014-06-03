//
//  AnalysisTypeSettingTableViewCell.m
//  IncomeExpendAnalyze
//
//  Created by Wayne on 5/29/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "AnalysisTypeSettingTableViewCell.h"

@implementation AnalysisTypeSettingTableViewCell

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
    [_btnClickHere release];
    [_btnAccount release];
    [super dealloc];
}
@end
