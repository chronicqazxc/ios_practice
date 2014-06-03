//
//  AnalysisTrendTableView.h
//  IncomeExpendAnalyze
//
//  Created by Wayne on 5/29/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterAndChartSection.h"
#import "ExpandContractProcessor.h"

@interface AnalysisTrendTableView : UITableView <UITableViewDataSource, UITableViewDelegate, FilterAndChartSectionDelegate, ExpandContractProcessorDelegate>

@property (retain, nonatomic) NSArray *arrayRevExpAnalysis;
@property (nonatomic) int nSelectedAccount;
@property (nonatomic) int nSelectedCategory;

- (void)getData;
- (void)showAcctPicker;
- (void)showStackedBarChart;
- (void)showInfo;

@end
