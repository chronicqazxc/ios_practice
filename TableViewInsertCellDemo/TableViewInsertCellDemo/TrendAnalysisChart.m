//  賬戶總覽趨勢分析
//  TrendAnalysisChart.m
//  ChartDemo
//
//  Created by Wayne on 5/13/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "TrendAnalysisChart.h"

#define kXAxis 0
#define kYAxisStartPoint 2
#define kYAxisEndPoint 1

CGFloat const CPDBarWidth = 0.25f;
CGFloat const CPDBarInitialX = 0.25f;

@interface TrendAnalysisChart()
@property (strong, nonatomic) CPTXYGraph *graph;
@property (strong, nonatomic) NSDictionary *data;
@property (strong, nonatomic) NSDictionary *plotsWithColors;
@property (strong, nonatomic) NSArray *sortedPlots;
@property (strong, nonatomic) NSArray *xAxisContents;
@property (strong, nonatomic) CPTMutableLineStyle *majorGridLineStyle;
@property (strong, nonatomic) CPTMutableLineStyle *minorGridLineStyle;
@property (strong, nonatomic) CPTPlotSpaceAnnotation *annotation;
@property (strong, nonatomic) NSMutableArray *sumValueOfPlots;
@property (nonatomic) int maxValue;

- (int)getMaxValue;
- (NSMutableArray *)getAllDataContent;
- (void)configureHostView;
- (void)configurePlotAreaFrame;
- (void)generateGridLineStyle;
- (void)configureXYAxis;
- (void)configurePlot;
- (void)configureLegend;
- (void)generateNTDollarWithPlot:(CPTBarPlot *)plot inIndex:(NSUInteger)index;
@end

@implementation TrendAnalysisChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)generateXAxisContents:(NSArray *)xAxisContents{
    self.xAxisContents = xAxisContents;
}

- (void)generatePlotsWithColors:(NSDictionary *)plotsWithcolors andSort:(NSArray *)sortedPlots{
    self.sortedPlots = sortedPlots;
    self.plotsWithColors = plotsWithcolors;
}

- (void)generateData:(NSDictionary *)data{
    self.data = data;
    self.sumValueOfPlots = [NSMutableArray array];
    self.maxValue = [self getMaxValue];
}

- (int)getMaxValue{
    int temp = 0;
    int current = 0;
    int maxValue = 0;
    BOOL isFirstEntry = YES;
    
    NSMutableArray *allContent;
    allContent = [self getAllDataContent];
    
    for (int i = 0; i < [allContent count]; i++){
        current = [((NSNumber *)allContent[i]) intValue];
        if (isFirstEntry) {
            temp = current;
            isFirstEntry = NO;
        } else {
            if (temp < current) {
                temp = current;
                maxValue = current;
            }
        }
    }
    return maxValue;
}

- (NSMutableArray *)getAllDataContent{
    NSMutableArray *allContent = [NSMutableArray array];
    for (NSString *dataKeys in [self.data allKeys]) {
        for (NSString *plotKeys in [[self.data objectForKey:dataKeys] allKeys]) {
            NSNumber *plotsValue = [[self.data objectForKey:dataKeys] valueForKey:plotKeys];
            [allContent addObject:plotsValue];
        }
    }
    return allContent;
}

- (void)generateLayout{
    [self configureHostView];
    [self configurePlotAreaFrame];
    [self generateGridLineStyle];
    [self configureXYAxis];
    [self configurePlot];
    [self configureLegend];
}

- (void)configureHostView{
    self.graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    self.hostedGraph = self.graph;
    self.hostedGraph.plotAreaFrame.masksToBorder = NO;
    self.hostedGraph.paddingLeft = 20.0f;
    self.hostedGraph.paddingTop = 0.0f;
    self.hostedGraph.paddingRight = 0.0f;
    self.hostedGraph.paddingBottom = 0.0f;
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

- (void)generateGridLineStyle{
    self.majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    self.majorGridLineStyle.lineWidth = 0.75f;
    self.majorGridLineStyle.lineColor = [[CPTColor blackColor] colorWithAlphaComponent:0.1f];
    self.minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    self.minorGridLineStyle.lineWidth = 0.25f;
    self.minorGridLineStyle.lineColor = [[CPTColor blackColor] colorWithAlphaComponent:0.1f];
}

- (void)configureXYAxis{
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    CPTXYAxis *graphXAxis = axisSet.xAxis;
    CPTMutableTextStyle *xAxisLabelStyle = [CPTMutableTextStyle textStyle];
    xAxisLabelStyle.fontSize = 8.0;
    
    graphXAxis.labelTextStyle = xAxisLabelStyle;
    graphXAxis.orthogonalCoordinateDecimal = CPTDecimalFromInt(0);
    graphXAxis.majorIntervalLength = CPTDecimalFromInt(1);
    graphXAxis.minorTicksPerInterval = 0;
    graphXAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    graphXAxis.majorGridLineStyle = self.majorGridLineStyle;
    graphXAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0f];
    
    int labelLocations = 0;
    NSMutableArray *customXLabels = [NSMutableArray array];
    for (NSString *xAxisContent in self.xAxisContents) {
        CPTAxisLabel *newLabel;
        NSString *labelString = [NSString stringWithString:[xAxisContent substringFromIndex:4]];
        newLabel = [[CPTAxisLabel alloc] initWithText:labelString textStyle:graphXAxis.labelTextStyle];
        newLabel.tickLocation = [[NSNumber numberWithInt:labelLocations] decimalValue];
        newLabel.offset = 0.0;
        newLabel.rotation = M_PI * 90;
        [customXLabels addObject:newLabel];
        labelLocations++;
    }
    graphXAxis.axisLabels = [NSSet setWithArray:customXLabels];
    
    CPTXYAxis *graphYAxis = axisSet.yAxis;
    graphYAxis.labelTextStyle = xAxisLabelStyle;
    graphYAxis.labelingPolicy = CPTAxisLabelingPolicyLocationsProvided;
    graphYAxis.majorGridLineStyle = self.majorGridLineStyle;
    graphYAxis.minorGridLineStyle = self.minorGridLineStyle;
    graphYAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0f];
    
    
    NSSet *majorTickLocations = [NSSet setWithObjects:[NSDecimalNumber zero],
                                 [NSDecimalNumber numberWithUnsignedInteger:100],
                                 [NSDecimalNumber numberWithUnsignedInteger:200],
                                 [NSDecimalNumber numberWithUnsignedInteger:300],
                                 [NSDecimalNumber numberWithUnsignedInteger:400],
                                 [NSDecimalNumber numberWithUnsignedInteger:500],
                                 nil];
    NSMutableSet *minorTickLocations = [NSMutableSet set];
    for (int i = 0; i < 500; i+=10) {
        [minorTickLocations addObject:[NSDecimalNumber numberWithUnsignedInteger:i]];
    }
    graphYAxis.majorTickLocations = majorTickLocations;
    graphYAxis.minorTickLocations = minorTickLocations;
    //    graphYAxis.minorTicksPerInterval = 50;
    //    graphYAxis.preferredNumberOfMajorTicks = 8;
    //    graphYAxis.axisLineStyle = nil;
    //    graphYAxis.labelOffset = 10.0;
    //    graphYAxis.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(30.0f)];
    //    graphYAxis.gridLinesRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(18.5f)];
    //    graphYAxis.title = @"Sparbetrag";
    //    graphYAxis.titleOffset = 40.0f;
}

//*****
-(void) addAxis{
    
    // Create grid line styles
    //    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    //    majorGridLineStyle.lineWidth = 1.0f;
    //    majorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.75];
    //
    //    NSSet *majorTickLocations = [NSSet setWithObjects:[NSDecimalNumber zero],
    //                                 [NSDecimalNumber numberWithUnsignedInteger:5],
    //                                 [NSDecimalNumber numberWithUnsignedInteger:10],
    //                                 [NSDecimalNumber numberWithUnsignedInteger:15],
    //                                 [NSDecimalNumber numberWithUnsignedInteger:20],
    //                                 nil];
    //
    //    // Create axes
    //    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    //    CPTXYAxis *x = axisSet.xAxis;
    //    {
    //        x.labelingPolicy = CPTAxisLabelingPolicyLocationsProvided;
    //        x.tickDirection = CPTSignNone;
    //        x.majorTickLocations = majorTickLocations;
    //        x.labelOffset = 6.0;
    //        x.labelRotation = M_PI/2;
    //        x.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(19.0f)];
    //        x.gridLinesRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(30.0f)];
    //        x.title = @"Jahre";
    //        x.titleOffset = 35.0f;
    //        x.titleLocation = CPTDecimalFromFloat(x.visibleRange.lengthDouble / 2.0);
    //        x.plotSpace = self.barPlotSpace;
    //    }
    //
    //    CPTXYAxis *y = axisSet.yAxis;
    //    {
    //        y.labelingPolicy = CPTAxisLabelingPolicyLocationsProvided;
    //        y.majorTickLocations = majorTickLocations;
    //        y.minorTicksPerInterval = 0;
    //        y.preferredNumberOfMajorTicks = 8;
    //        y.majorGridLineStyle = majorGridLineStyle;
    //        y.axisLineStyle = nil;
    //        y.majorTickLineStyle = nil;
    //        y.minorTickLineStyle = nil;
    //        y.labelOffset = 10.0;
    //        y.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(30.0f)];
    //        y.gridLinesRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(18.5f)];
    //        y.title = @"Sparbetrag";
    //        y.titleOffset = 40.0f;
    //        y.titleLocation = CPTDecimalFromFloat(y.visibleRange.lengthDouble / 2.0);
    //        y.plotSpace = barPlotSpace;
    //    }
    //
    //    // Set axes
    //    self.graph.axisSet.axes = [NSArray arrayWithObjects:x, y, nil];
}
//*****

- (void)configurePlot{
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    plotSpace.delegate = self;
    CGFloat xMin = -1.0f;
    CGFloat xMax = [self.xAxisContents count] + 1;
    CGFloat yMin = 0.0f;
    CGFloat yMax = self.maxValue * [self.sortedPlots count];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(yMin) length:CPTDecimalFromCGFloat(yMax)];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(xMin) length:CPTDecimalFromCGFloat(xMax)];
    
    CPTMutableLineStyle *barLineStyle = [[CPTMutableLineStyle alloc] init];
    barLineStyle.lineWidth = 0.0f;
    barLineStyle.lineColor = [CPTColor clearColor];
    
    BOOL firstPlot = YES;
    for (NSString *keyForDetermindColor in self.sortedPlots) {
        CPTBarPlot *plot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor] horizontalBars:NO];
        plot.lineStyle = barLineStyle;
        CGColorRef plotColor = ((UIColor *)[self.plotsWithColors objectForKey:keyForDetermindColor]).CGColor;
        CPTGradient *plotGradient = [CPTGradient gradientWithBeginningColor:[CPTColor colorWithCGColor:plotColor] endingColor:[[CPTColor blackColor] colorWithAlphaComponent:0.9] beginningPosition:0.0 endingPosition:0.995];
        plotGradient.angle = CPTFloat(plot.barsAreHorizontal ? -90.0 : 0.0);
        if (self.isPlotColorWithGradient)
            plot.fill = [CPTFill fillWithGradient:plotGradient];
        else
            plot.fill = [CPTFill fillWithColor:[CPTColor colorWithCGColor:plotColor]];
        plot.barCornerRadius = 0.99;
        if (firstPlot) {
            plot.barBasesVary = NO;
            firstPlot = NO;
        } else {
            plot.barBasesVary = YES;
        }
        plot.barWidth = CPTDecimalFromFloat(0.8f);
        plot.barsAreHorizontal = NO;
        plot.dataSource = self;
        plot.delegate = self;
        plot.identifier = keyForDetermindColor;
        [self.hostedGraph addPlot:plot toPlotSpace:plotSpace];
    }
}

- (void)configureLegend{
    CPTMutableTextStyle *blackTextStyle = [CPTMutableTextStyle textStyle];
    blackTextStyle.color = [CPTColor blackColor];
    CPTLegend *theLegend = [CPTLegend legendWithGraph:self.graph];
    theLegend.numberOfRows = 2;
    theLegend.fill = [CPTFill fillWithColor:[CPTColor colorWithGenericGray:1.0f]];
    theLegend.borderLineStyle = nil;
    theLegend.cornerRadius = 0.0;
    theLegend.swatchSize = CGSizeMake(10.0, 10.0);
    blackTextStyle.fontSize = 10.0;
    theLegend.textStyle = blackTextStyle;
    theLegend.paddingLeft = 10.0;
    theLegend.paddingTop = 0.0;
    theLegend.paddingRight = 10.0;
    theLegend.paddingBottom = 0.0;
    self.hostedGraph.legend = theLegend;
    self.hostedGraph.legendAnchor = CPTRectAnchorBottom;
    self.hostedGraph.legendDisplacement = CGPointMake(0.0, 5.0);
}

#pragma mark -
#pragma mark - CPTPlotDataSource
- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot{
    return [self.xAxisContents count];
}

- (double)doubleForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index{
    double num = NAN;
    
    if (fieldEnum == kXAxis) {
        num = index;
    } else {
        double offset = 0;
        if (((CPTBarPlot *)plot).barBasesVary) {
            for (NSString *keyForValue in self.sortedPlots) {
                if ([plot.identifier isEqual:keyForValue]) {
                    break;
                }
                NSString *date = [self.xAxisContents objectAtIndex:index];
                NSDictionary *data = [self.data objectForKey:date];
                NSNumber *value = [data objectForKey:keyForValue];
                offset += [value doubleValue];
            }
        }
        if (fieldEnum == kYAxisEndPoint) {
            NSString *date = [self.xAxisContents objectAtIndex:index];
            NSDictionary *data = [self.data objectForKey:date];
            NSNumber *value = [data objectForKey:plot.identifier];
            num = [value doubleValue] + offset;
        } else if (fieldEnum == kYAxisStartPoint) {
            num = offset;
        }
        if ([((NSString *)plot.identifier) isEqualToString:(NSString *)[self.sortedPlots lastObject]] && fieldEnum == kYAxisEndPoint) {
            NSNumber *number = [NSNumber numberWithDouble:num];
            [self.sumValueOfPlots addObject:number];
        }
    }
    return num;
}

#pragma mark - CPTBarPlotDelegate methods
- (void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index{
    [self generateNTDollarWithPlot:plot inIndex:index];
}

#pragma mark -
- (void)generateNTDollarWithPlot:(CPTBarPlot *)plot inIndex:(NSUInteger)index{
    if (!self.annotation) {
        NSNumber *x = [NSNumber numberWithInt:0];
        NSNumber *y = [NSNumber numberWithInt:0];
        NSArray *anchorPoint = [NSArray arrayWithObjects:x, y, nil];
        self.annotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:plot.plotSpace anchorPlotPoint:anchorPoint];
    }
    static NSNumberFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    static CPTMutableTextStyle *annotationTextStyle = nil;
    if (!annotationTextStyle) {
        annotationTextStyle = [CPTMutableTextStyle textStyle];
        annotationTextStyle.color = [CPTColor blackColor];
        annotationTextStyle.fontSize = 10.0f;
    }
    NSNumber *sumValueNumber = self.sumValueOfPlots[index];
    NSString *sumValueString = [formatter stringFromNumber:sumValueNumber];
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:sumValueString style:annotationTextStyle];
    self.annotation.contentLayer = textLayer;
    CGFloat x = index;
    NSNumber *anchorX = [NSNumber numberWithFloat:x];
    CGFloat y = [sumValueNumber floatValue] + 1/self.maxValue;
    NSNumber *anchorY = [NSNumber numberWithFloat:y];
    self.annotation.anchorPlotPoint = [NSArray arrayWithObjects:anchorX, anchorY, nil];
    [plot.graph.plotAreaFrame.plotArea addAnnotation:self.annotation];
}
@end
