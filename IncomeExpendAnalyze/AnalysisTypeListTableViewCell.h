//
//  AnalysisTypeListTableViewCell.h
//  IncomeExpendAnalyze
//
//  Created by Wayne on 5/29/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnalysisTypeListTableViewCell : UITableViewCell

@property (nonatomic) BOOL isExpand;
@property (retain, nonatomic) IBOutlet UILabel *title;
@property (retain, nonatomic) IBOutlet UIView *thumbnail;

@end
