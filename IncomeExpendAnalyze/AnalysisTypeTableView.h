//
//  AnalysisTypeTableView.h
//  IncomeExpendAnalyze
//
//  Created by Wayne on 5/29/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterAndChartSection.h"
#import "ExpandContractProcessor.h"

@interface AnalysisTypeTableView : UITableView <UITableViewDataSource, UITableViewDelegate, FilterAndChartSectionDelegate, ExpandContractProcessorDelegate>

@property (retain, nonatomic) NSArray *arrayRevExpAnalysis;
@property (retain, nonatomic) NSArray *arraySelectedMonth;
@property (nonatomic) int nSelectedAccount;

- (void)getData;
- (void)sendRexExpImportMod;
- (void)showDateSettingView;
- (void)showAccountPicker;
- (void)drawPieChart;
- (void)gotoDetail;
- (void)showInfo;

@end
