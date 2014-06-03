//
//  PieChart.h
//  ChartDemo
//
//  Created by Wayne on 5/14/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "CPTGraphHostingView.h"
#import "CorePlot-CocoaTouch.h"

@interface PieChart : CPTGraphHostingView <CPTPlotDataSource, CPTPieChartDataSource>

- (void)setPieChartData:(NSArray *)dataArray andColors:(NSArray *)colorArray;
- (void)initPlot;

@end
