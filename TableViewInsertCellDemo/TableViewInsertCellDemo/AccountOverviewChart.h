//  賬戶總覽趨勢分析
//  AccountOverviewChart.h
//  ChartDemo
//
//  Created by Wayne on 5/13/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "CPTGraphHostingView.h"
#import "CorePlot-CocoaTouch.h"

@interface AccountOverviewChart : CPTGraphHostingView <CPTPlotDataSource, CPTPlotSpaceDelegate>

@property (nonatomic) BOOL isPlotColorWithGradient;

- (void)generateXAxisContents:(NSArray *)array;
- (void)generatePlotsWithColors:(NSDictionary *)dictionary andSort:(NSArray *)sortedPlots;
- (void)generateData:(NSDictionary *)theDatas;
- (void)generateLayout;

@end
