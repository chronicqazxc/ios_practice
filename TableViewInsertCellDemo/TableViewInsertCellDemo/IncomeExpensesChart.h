//  活存收支概要
//  IncomeExpensesChart.h
//  ChartDemo
//
//  Created by Wayne on 5/16/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "CPTGraphHostingView.h"
#import "CorePlot-CocoaTouch.h"

@interface IncomeExpensesChart : CPTGraphHostingView <CPTPlotDataSource, CPTPlotSpaceDelegate>

@property (nonatomic) BOOL isPlotColorWithGradient;

- (void)generateXAxisContents:(NSArray *)array;
- (void)generatePlotsAndColors:(NSDictionary *)dictionary sortedKeys:(NSArray *)sortedKeys;
- (void)generateData:(NSDictionary *)theDatas;
- (void)generateLayout;

@end
