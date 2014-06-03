//
//  DetailSettingTableViewCell.h
//  IncomeExpendAnalyze
//
//  Created by Wayne on 5/29/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailSettingTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIButton *btnTypeAll;
@property (retain, nonatomic) IBOutlet UIButton *btnTypeRev;
@property (retain, nonatomic) IBOutlet UIButton *btnTypeExp;
@property (retain, nonatomic) IBOutlet UIButton *btnAcct;
@property (retain, nonatomic) IBOutlet UIButton *btnCategory;
@property (retain, nonatomic) IBOutlet UIButton *btnSubCategory;
@end
