//
//  DetailSettingTableViewCell.m
//  IncomeExpendAnalyze
//
//  Created by Wayne on 5/29/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "DetailSettingTableViewCell.h"

@implementation DetailSettingTableViewCell

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
    [_btnTypeAll release];
    [_btnTypeRev release];
    [_btnTypeExp release];
    [_btnAcct release];
    [_btnCategory release];
    [_btnSubCategory release];
    [super dealloc];
}
@end
