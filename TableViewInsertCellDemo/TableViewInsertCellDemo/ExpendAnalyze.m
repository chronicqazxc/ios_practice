//
//  ExpendAnalyze.m
//  ChartDemo
//
//  Created by Wayne on 5/14/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ExpendAnalyze.h"

@interface ExpendAnalyze()
@property (strong, nonatomic) CPTXYGraph *graph;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSArray *pieColors;
@property (nonatomic) int maxIndex;
@property (strong, nonatomic) NSMutableArray *shouldResetPie;

- (void)initPlot;
- (void)configureHostView;
- (void)configureGraph;
- (void)configureChart;
- (void)configureLegend;
- (void)configurePlotAreaFrame;
@end

@implementation ExpendAnalyze

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPieChartData:(NSArray *)dataArray andColors:(NSArray *)colorArray{
    self.data = dataArray;
    self.pieColors = colorArray;
}

- (void)initPlot{
    self.shouldResetPie = [NSMutableArray array];
    [self configureHostView];
    [self configureGraph];
    [self configurePlotAreaFrame];
    [self configureChart];
//    [self configureLegend];
}

//*** No use
- (int)getMaxIndex{
    int temp = 0;
    int current = 0;
    int maxIndex = 0;
    BOOL isFirstEntry = YES;
    for (int i = 0; i < [self.data count]; i++){
        current = [((NSDecimalNumber *)self.data[i]) intValue];
        if (isFirstEntry) {
            temp = current;
            isFirstEntry = NO;
        } else {
            if (temp < current) {
                temp = current;
                maxIndex = i;
            }
        }
    }
    return maxIndex;
}
//**

- (void)configureHostView{
    self.graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    self.hostedGraph = self.graph;
}

- (void)configureGraph{
    self.hostedGraph.paddingLeft = 0.0f;
    self.hostedGraph.paddingTop = 0.0f;
    self.hostedGraph.paddingRight = 0.0f;
    self.hostedGraph.paddingBottom = 0.0f;
    self.hostedGraph.axisSet = nil;
    [self.hostedGraph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
}

- (void)configurePlotAreaFrame{
    CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
    borderLineStyle.lineColor = [CPTColor clearColor];
    borderLineStyle.lineWidth = 2.0f;
    self.hostedGraph.plotAreaFrame.cornerRadius = 5.0;
    self.hostedGraph.plotAreaFrame.borderLineStyle = borderLineStyle;
    self.hostedGraph.plotAreaFrame.paddingTop = -10.0f;
    self.hostedGraph.plotAreaFrame.paddingRight = 10.0f;
    self.hostedGraph.plotAreaFrame.paddingBottom = 45.0f;
    self.hostedGraph.plotAreaFrame.paddingLeft = 10.0f;
}

- (void)configureChart{
    CPTPieChart *pieChart = [[CPTPieChart alloc] init];
    pieChart.paddingBottom = 0.0f;
    pieChart.paddingTop = 0.0f;
    pieChart.paddingLeft = 0.0f;
    pieChart.paddingRight = 0.0f;
    pieChart.dataSource = self;
    pieChart.delegate = self;
    pieChart.pieRadius = (self.hostedGraph.bounds.size.height*0.4);
    pieChart.pieInnerRadius = pieChart.pieRadius * 0.45;
    pieChart.startAngle = M_PI_4;
    pieChart.sliceDirection = CPTPieDirectionClockwise;
    pieChart.labelOffset = -45.0f;
    CPTGradient *overlayGradient = [[CPTGradient alloc] init];
    overlayGradient.gradientType = CPTGradientTypeRadial;
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.9];
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.4] atPosition:1.0];
    pieChart.overlayFill = [CPTFill fillWithGradient:overlayGradient];
    [self.hostedGraph addPlot:pieChart];
}

- (void)configureLegend{
    CPTMutableTextStyle *blackTextStyle = [CPTMutableTextStyle textStyle];
    CPTMutableLineStyle *legendLineStyle = [CPTMutableLineStyle lineStyle];
    legendLineStyle.lineColor = [CPTColor clearColor];
    CPTLegend *legend = [CPTLegend legendWithGraph:self.hostedGraph];
    legend.numberOfColumns = [self.data count];
    legend.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    legend.borderLineStyle = legendLineStyle;
    legend.cornerRadius = 5.0;
    legend.swatchSize = CGSizeMake(10.0, 10.0);
    blackTextStyle.fontSize = 10.0;
    legend.textStyle = blackTextStyle;
    self.hostedGraph.legend = legend;
    self.hostedGraph.legendAnchor = CPTRectAnchorBottom;
    self.hostedGraph.legendDisplacement = CGPointMake(0.0, 0.0);
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [self.data count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    NSDecimalNumber *value = self.data[index];
    NSNumber *number = [NSNumber numberWithInt:value.integerValue];
    return number;
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
    CPTMutableTextStyle *labelText = nil;
    if (!labelText) {
        labelText = [[CPTMutableTextStyle alloc] init];
    }
    CGColorRef cgColor = ((UIColor *)self.pieColors[index]).CGColor;
    labelText.color = [CPTColor colorWithCGColor:cgColor];
    labelText.color = [CPTColor blackColor];
    
    NSDecimalNumber *portfolioSum = [NSDecimalNumber zero];
    for (NSDecimalNumber *price in self.data) {
        portfolioSum = [portfolioSum decimalNumberByAdding:price];
    }
    NSDecimalNumber *price = self.data[index];
    NSDecimalNumber *percent = [price decimalNumberByDividingBy:portfolioSum];
    NSString *labelValue = [NSString stringWithFormat:@"%0.1f %%", ([percent floatValue]*100.0f)];
    return [[CPTTextLayer alloc] initWithText:labelValue style:labelText];
}

-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
    if (index < [self.data count]) {
        return [NSString stringWithFormat:@"NT$%d", [(NSDecimalNumber *)self.data[index] intValue]];
    }
    return @"N/A";
}

#pragma mark - CPTPieChartDataSource
-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index
{
    CPTFill *color;
    CGColorRef cgColor = ((UIColor *)self.pieColors[index]).CGColor;
    color = [CPTFill fillWithColor:[CPTColor colorWithCGColor:cgColor]];
    return color;
}

-(CGFloat)radialOffsetForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index{
    CGFloat offset = 0.0;
    if ([(NSString *)pieChart.identifier isEqualToString:[NSString stringWithFormat:@"%d",index]])
        offset = 10.0;
    self.shouldResetPie[index] = [NSNumber numberWithFloat:offset];
    return offset;
}

#pragma mark - CPTPieChartDelegate
-(void)pieChart:(CPTPieChart *)plot sliceWasSelectedAtRecordIndex:(NSUInteger)index{
    if ([self.shouldResetPie[index] floatValue] != 0.0) {
        plot.identifier = @"reset";
    } else {
        plot.identifier = [NSString stringWithFormat:@"%d",index];
    }
    [plot reloadData];
}

@end
