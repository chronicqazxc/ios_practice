//  活存收支概要
//  IncomeExpensesChart.m
//  ChartDemo
//
//  Created by Wayne on 5/16/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "IncomeExpensesChart.h"

#define kXAxis 0
#define kYAxisStartPoint 2
#define kYAxisEndPoint 1

@interface IncomeExpensesChart()
@property (strong, nonatomic) CPTXYGraph *graph;
@property (strong, nonatomic) CPTXYGraph *legendGraph;
@property (weak, nonatomic) CPTLegend *legend;
@property (weak, nonatomic) NSMutableDictionary *originalData;
@property (strong, nonatomic) NSMutableDictionary *sortedData;
@property (weak, nonatomic) NSMutableDictionary *plotsWithColors;
@property (weak, nonatomic) NSArray *sortedKeys;
@property (weak, nonatomic) NSArray *orderKeys;
@property (strong, nonatomic) NSArray *xAxisContents;
@property (weak, nonatomic) CPTMutableLineStyle *majorGridLineStyle;
@property (weak, nonatomic) CPTMutableLineStyle *minorGridLineStyle;
@property (strong, nonatomic) CPTPlotSpaceAnnotation *NTDallorAnnotation;
@property (strong, nonatomic) CPTPlotSpaceAnnotation *balanceLabelAnnotation;
@property (weak, nonatomic) CPTBarPlot *incomePlot;
@property (weak, nonatomic) CPTBarPlot *expendPlot;
@property (nonatomic) int maxValue;
@property (strong, nonatomic) NSArray *sortedPlots;

- (int)getMaxValue;
- (NSMutableArray *)getAllContent;
- (void)sortData;
- (void)configureHostView;
- (void)configurePlotAreaFrame;
- (void)generateGridLineStyle;
- (void)configureXYAxis;
- (void)configurePlot;
- (void)configureLegend;
- (void)generateLegendGaph;
- (void)configureLegendAttribute;
- (void)generateNTDollarLabelWithPlot:(CPTBarPlot *)plot inIndex:(NSUInteger)index;
- (void)generateBalanceLabelAnnotationwithPlot:(CPTBarPlot *)plot inIndex:(NSUInteger)index;
@end

@implementation IncomeExpensesChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)generateXAxisContents:(NSArray *)array{
    self.xAxisContents = array;
}

- (void)generatePlotsAndColors:(NSMutableDictionary *)dictionary sortedKeys:(NSArray *)sortedKeys{
    self.sortedKeys = sortedKeys;
    self.plotsWithColors = dictionary;
}

- (void)generateData:(NSMutableDictionary *)data{
    self.originalData = data;
    self.maxValue = [self getMaxValue];
}

- (int)getMaxValue{
    int temp = 0;
    int current = 0;
    int maxValue = 0;
    BOOL isFirstEntry = YES;
    
    NSMutableArray *allContent;
    allContent = [self getAllContent];
    
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

- (NSMutableArray *)getAllContent{
    NSMutableArray *allContent = [NSMutableArray array];
    for (NSString *monthKey in [self.originalData allKeys]) {
        for (NSString *colorKey in [[self.originalData objectForKey:monthKey] allKeys]) {
            NSNumber *number = [[self.originalData objectForKey:monthKey] valueForKey:colorKey];
            [allContent addObject:number];
        }
    }
    return allContent;
}

- (void)generateLayout{
    [self sortData];
    [self configureHostView];
    [self configurePlotAreaFrame];
    [self generateGridLineStyle];
    [self configureXYAxis];
    [self configurePlot];
    [self configureLegend];
}

- (void)sortData{
    self.sortedData = [NSMutableDictionary dictionary];
    NSString *firstElementName = [self.sortedKeys firstObject];
    NSString *lastElementName = [self.sortedKeys lastObject];
    for (NSString *xAxisContent in self.xAxisContents) {
        NSDictionary *plotsData = [self.originalData objectForKey:xAxisContent];
        int tempValue = 0;
        int currentValue = 0;
        int biggerValue = 0;
        BOOL isFirstEntry = YES;
        NSNumber *biggerNumber;
        NSNumber *smallerNumber;
        NSMutableDictionary *sortedData = [NSMutableDictionary dictionary];
        for (NSString *keyForPlots in self.sortedKeys) {
            currentValue = [[plotsData objectForKey:keyForPlots] intValue];
            if (isFirstEntry) {
                isFirstEntry = NO;
                tempValue = currentValue;
                biggerValue = currentValue;
            } else if (tempValue < currentValue) {
                biggerValue = currentValue;
                currentValue -= tempValue;
                biggerNumber = [NSNumber numberWithInt:currentValue];
                smallerNumber = [NSNumber numberWithInt:tempValue];
                [sortedData setObject:biggerNumber forKey:[NSString stringWithFormat:@"%@Bigger",lastElementName]];
                [sortedData setObject:smallerNumber forKey:[NSString stringWithFormat:@"%@Smaller",firstElementName]];
            } else {
                biggerValue -= currentValue;
                biggerNumber = [NSNumber numberWithInt:biggerValue];
                smallerNumber = [NSNumber numberWithInt:currentValue];
                [sortedData setObject:biggerNumber forKey:[NSString stringWithFormat:@"%@Bigger",firstElementName]];
                [sortedData setObject:smallerNumber forKey:[NSString stringWithFormat:@"%@Smaller",lastElementName]];
            }
        }
        [self.sortedData setObject:sortedData forKey:xAxisContent];
    }
}

- (void)configureHostView{
    self.graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    self.hostedGraph = self.graph;
    self.hostedGraph.plotAreaFrame.masksToBorder = NO;
    self.hostedGraph.paddingLeft = 0.0f;
    self.hostedGraph.paddingTop = 0.0f;
    self.hostedGraph.paddingRight = 0.0f;
    self.hostedGraph.paddingBottom = 0.0f;
    [self.hostedGraph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
}

- (void)configurePlotAreaFrame{
    CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
    borderLineStyle.lineColor = [CPTColor blackColor];
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
    graphYAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    graphYAxis.majorGridLineStyle = self.majorGridLineStyle;
    graphYAxis.minorGridLineStyle = self.minorGridLineStyle;
    graphYAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:-100.0];
}

- (void)configurePlot{
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    plotSpace.delegate = self;
    CGFloat xMin = -1.0f;
    CGFloat xMax = [self.xAxisContents count] + 1;
    CGFloat yMin = 0.0f;
    CGFloat yMax = self.maxValue * 1.2;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(yMin) length:CPTDecimalFromCGFloat(yMax)];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(xMin) length:CPTDecimalFromCGFloat(xMax)];
    
    CPTMutableLineStyle *barLineStyle = [[CPTMutableLineStyle alloc] init];
    barLineStyle.lineWidth = 0.0f;
    barLineStyle.lineColor = [CPTColor clearColor];
    
    self.sortedPlots = @[@"IncomeSmaller",
                         @"ExpendSmaller",
                         @"IncomeBigger",
                         @"ExpendBigger"];
    for (NSString *plotsName in self.sortedPlots) {
        NSString *keyForDetermindPlotsColor = [plotsName substringToIndex:6];
        NSString *keyForDetermindBiggerOrSmaller = [plotsName substringFromIndex:6];
        CPTBarPlot *plot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor] horizontalBars:NO];
        plot.lineStyle = barLineStyle;
        CGColorRef plotColor = ((UIColor *)[self.plotsWithColors objectForKey:keyForDetermindPlotsColor]).CGColor;
        CPTGradient *plotGradient = [CPTGradient gradientWithBeginningColor:[CPTColor colorWithCGColor:plotColor] endingColor:[[CPTColor blackColor] colorWithAlphaComponent:0.9] beginningPosition:0.0 endingPosition:0.995];
        plotGradient.angle = CPTFloat(plot.barsAreHorizontal ? -90.0 : 0.0);
        if (self.isPlotColorWithGradient)
            plot.fill = [CPTFill fillWithGradient:plotGradient];
        else
            plot.fill = [CPTFill fillWithColor:[CPTColor colorWithCGColor:plotColor]];
        if ([keyForDetermindBiggerOrSmaller isEqualToString:@"Smaller"]) {
            plot.barBasesVary = NO;
        } else {
            plot.barBasesVary = YES;
        }
        plot.barCornerRadius = 0.99;
        plot.barWidth = CPTDecimalFromDouble(0.85f);
        plot.barsAreHorizontal = NO;
        plot.dataSource = self;
        plot.delegate = self;
        plot.identifier = plotsName;
        [self.hostedGraph addPlot:plot toPlotSpace:plotSpace];
    }
}

- (void)configureLegend{
    [self generateLegendGaph];
    [self configureLegendAttribute];
    self.hostedGraph.legend = self.legend;
    self.hostedGraph.legendAnchor = CPTRectAnchorBottom;
    self.hostedGraph.legendDisplacement = CGPointMake(0.0, 5.0);
}

- (void)generateLegendGaph{
    self.legendGraph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTMutableLineStyle *barLineStyle = [[CPTMutableLineStyle alloc] init];
    barLineStyle.lineWidth = 0.0f;
    barLineStyle.lineColor = [CPTColor clearColor];
    for (NSString *plotsName in self.sortedKeys) {
        NSString *keyForDetermindColor = [plotsName substringToIndex:6];
        CPTBarPlot *plot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor] horizontalBars:NO];
        plot.lineStyle = barLineStyle;
        CGColorRef plotColor = ((UIColor *)[self.plotsWithColors objectForKey:keyForDetermindColor]).CGColor;
        CPTGradient *plotGradient = [CPTGradient gradientWithBeginningColor:[CPTColor colorWithCGColor:plotColor] endingColor:[[CPTColor blackColor] colorWithAlphaComponent:0.9] beginningPosition:0.0 endingPosition:0.995];
        plotGradient.angle = CPTFloat(plot.barsAreHorizontal ? -90.0 : 0.0);
        if (self.isPlotColorWithGradient)
            plot.fill = [CPTFill fillWithGradient:plotGradient];
        else
            plot.fill = [CPTFill fillWithColor:[CPTColor colorWithCGColor:plotColor]];
        if ([keyForDetermindColor isEqualToString:@"Income"])
            plot.identifier = @"收入";
        else if ([keyForDetermindColor isEqualToString:@"Expend"])
            plot.identifier = @"支出";
        [self.legendGraph addPlot:plot];
    }
}

- (void)configureLegendAttribute{
    CPTMutableTextStyle *blackTextStyle = [CPTMutableTextStyle textStyle];
    blackTextStyle.color = [CPTColor blackColor];
    self.legend = [CPTLegend legendWithGraph:self.legendGraph];
    self.legend.numberOfRows = 1;
    self.legend.fill = [CPTFill fillWithColor:[CPTColor colorWithGenericGray:1.0f]];
    self.legend.borderLineStyle = nil;
    self.legend.cornerRadius = 0.0;
    self.legend.swatchSize = CGSizeMake(10.0, 10.0);
    blackTextStyle.fontSize = 10.0;
    self.legend.textStyle = blackTextStyle;
    self.legend.paddingLeft = 10.0;
    self.legend.paddingTop = 0.0;
    self.legend.paddingRight = 10.0;
    self.legend.paddingBottom = 0.0;
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
        double offset = 0.0;
        NSString *date = [self.xAxisContents objectAtIndex:index];
        NSDictionary *data = [self.sortedData objectForKey:date];
        if (((CPTBarPlot *)plot).barBasesVary) {
            for (NSString *plotsName in self.sortedPlots) {
                if ([plot.identifier isEqual:plotsName] || [[plotsName substringFromIndex:6] isEqualToString:@"Bigger"]) {
                    break;
                }
                NSNumber *value = [data objectForKey:plotsName];
                offset += [value doubleValue];
            }
        }
        if (fieldEnum == kYAxisEndPoint) {
            NSNumber *value = [data objectForKey:plot.identifier];
            num = [value doubleValue] + offset;
        } else if (fieldEnum == kYAxisStartPoint) {
            num = offset;
        }
    }
    return num;
}

#pragma mark - CPTBarPlotDelegate methods
- (void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index{
    [self generateNTDollarLabelWithPlot:plot inIndex:index];
    [self generateBalanceLabelAnnotationwithPlot:plot inIndex:index];
}

#pragma mark -
- (void)generateNTDollarLabelWithPlot:(CPTBarPlot *)plot inIndex:(NSUInteger)index{
    if (!self.NTDallorAnnotation) {
        NSNumber *x = [NSNumber numberWithInt:0];
        NSNumber *y = [NSNumber numberWithInt:0];
        NSArray *anchorPoint = [NSArray arrayWithObjects:x, y, nil];
        self.NTDallorAnnotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:plot.plotSpace anchorPlotPoint:anchorPoint];
    }
    static NSNumberFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    NSMutableString *balance = [NSMutableString stringWithString:@""];
    static CPTMutableTextStyle *style = nil;
    style = [CPTMutableTextStyle textStyle];
    if ([(NSString *)plot.identifier isEqualToString:@"IncomeSmaller"] || [(NSString *)plot.identifier isEqualToString:@"ExpendBigger"]) {
        style.color = [CPTColor redColor];
        [balance appendString:@"-"];
    } else if ([(NSString *)plot.identifier isEqualToString:@"IncomeBigger"] || [(NSString *)plot.identifier isEqualToString:@"ExpendSmaller"])
        style.color = [CPTColor blackColor];
    style.fontSize = 8.0f;
    NSString *date = [self.xAxisContents objectAtIndex:index];
    NSDictionary *data = [self.sortedData objectForKey:date];
    NSNumber *num = [data objectForKey:(NSString *)plot.identifier];
    for (NSString *key in [data allKeys]) {
        if ([[key substringFromIndex:6] isEqualToString:@"Bigger"]) {
            num = [data objectForKey:key];
        }
    }
    [balance appendString:[formatter stringFromNumber:num]];
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:balance style:style];
    self.NTDallorAnnotation.contentLayer = textLayer;
    CGFloat x = index;
    NSNumber *anchorX = [NSNumber numberWithFloat:x];
    CGFloat y = -(self.maxValue * 0.12);
    NSNumber *anchorY = [NSNumber numberWithFloat:y];
    self.NTDallorAnnotation.anchorPlotPoint = [NSArray arrayWithObjects:anchorX, anchorY, nil];
    [plot.graph.plotAreaFrame.plotArea addAnnotation:self.NTDallorAnnotation];
}

- (void)generateBalanceLabelAnnotationwithPlot:(CPTBarPlot *)plot inIndex:(NSUInteger)index{
    if (!self.balanceLabelAnnotation) {
        NSNumber *x = [NSNumber numberWithInt:0];
        NSNumber *y = [NSNumber numberWithInt:0];
        NSArray *anchorPoint = [NSArray arrayWithObjects:x, y, nil];
        self.balanceLabelAnnotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:plot.plotSpace anchorPlotPoint:anchorPoint];
    }
    static NSNumberFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    static CPTMutableTextStyle *style = nil;
    style = [CPTMutableTextStyle textStyle];
    style.color = [CPTColor blackColor];
    style.fontSize = 8.0f;
    NSString *balance = @"結餘";
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:balance style:style];
    self.balanceLabelAnnotation.contentLayer = textLayer;
    CGFloat x = index;
    NSNumber *anchorX = [NSNumber numberWithFloat:x];
    CGFloat y = -(self.maxValue * 0.07);
    NSNumber *anchorY = [NSNumber numberWithFloat:y];
    self.balanceLabelAnnotation.anchorPlotPoint = [NSArray arrayWithObjects:anchorX, anchorY, nil];
    [plot.graph.plotAreaFrame.plotArea addAnnotation:self.balanceLabelAnnotation];
}

@end
