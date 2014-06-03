//
//  TallyBookDetailView.h
//  IncomeExpendAnalyze
//
//  Created by Wayne on 5/29/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterAndChartSection.h"
#import "ExpandContractProcessor.h"

@interface TallyBookDetailView : UITableView <UITableViewDataSource, UITableViewDelegate, FilterAndChartSectionDelegate, ExpandContractProcessorDelegate>

@property (retain, nonatomic) NSArray *arrayRevExpDetail;
@property (retain, nonatomic) NSArray *arraySelectedMonth;
@property (nonatomic) int nSelectedType;
@property (nonatomic) int nSelectedAcct;
@property (nonatomic) int nSelectedCategory;
@property (nonatomic) int nSelectedSubCategory;

@end
