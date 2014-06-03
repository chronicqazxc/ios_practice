//
//  StackedBarChart.m
//  ChartDemo
//
//  Created by Wayne on 5/13/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "StackedBarChart.h"

#define kXAxis 0
#define kYAxisStartPoint 2
#define kYAxisEndPoint 1

CGFloat const CPDBarWidth = 0.25f;
CGFloat const CPDBarInitialX = 0.25f;

@interface StackedBarChart()
@property (strong, nonatomic) CPTXYGraph *graph;
@property (strong, nonatomic) NSDictionary *datas;
@property (strong, nonatomic) NSDictionary *plotsWithColors;
@property (strong, nonatomic) NSArray *sortedKeys;
@property (strong, nonatomic) NSArray *xAxisContents;
@property (strong, nonatomic) CPTMutableLineStyle *majorGridLineStyle;
@property (strong, nonatomic) CPTMutableLineStyle *minorGridLineStyle;
@property (strong, nonatomic) CPTPlotSpaceAnnotation *valueAnnotation;
@property (strong, nonatomic) NSMutableArray *sumValue;
@end

@implementation StackedBarChart

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

- (void)generatePlotsAndColors:(NSDictionary *)dictionary sortedKeys:(NSArray *)sortedKeys{
    self.sortedKeys = sortedKeys;
    self.plotsWithColors = dictionary;
}

- (void)generateData:(NSDictionary *)theDatas{
    self.datas = theDatas;
}

- (void)generateLayout{
    self.sumValue = [NSMutableArray array];
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
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:xAxisContent textStyle:graphXAxis.labelTextStyle];
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
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt(100000 * (int)[self.plotsWithColors count])];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(-1) length:CPTDecimalFromInt([self.xAxisContents count] + 1)];
    
    CPTMutableLineStyle *barLineStyle = [[CPTMutableLineStyle alloc] init];
    barLineStyle.lineWidth = 0.0f;
    barLineStyle.lineColor = [CPTColor clearColor];
    
    BOOL firstPlot = YES;
    for (NSString *keyForDetermindColor in self.sortedKeys) {
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
            for (NSString *keyForValue in self.sortedKeys) {
                if ([plot.identifier isEqual:keyForValue]) {
                    break;
                }
                NSString *date = [self.xAxisContents objectAtIndex:index];
                NSDictionary *data = [self.datas objectForKey:date];
                NSNumber *value = [data objectForKey:keyForValue];
                offset += [value doubleValue];
            }
        }
        if (fieldEnum == kYAxisEndPoint) {
            NSString *date = [self.xAxisContents objectAtIndex:index];
            NSDictionary *data = [self.datas objectForKey:date];
            NSNumber *value = [data objectForKey:plot.identifier];
            num = [value doubleValue] + offset;
        } else if (fieldEnum == kYAxisStartPoint) {
            num = offset;
        }
        
        if ([((NSString *)plot.identifier) isEqualToString:(NSString *)[self.sortedKeys lastObject]] && fieldEnum == kYAxisEndPoint) {
            NSNumber *number = [NSNumber numberWithDouble:num];
            [self.sumValue addObject:number];
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
    if (!self.valueAnnotation) {
        NSNumber *x = [NSNumber numberWithInt:0];
        NSNumber *y = [NSNumber numberWithInt:0];
        NSArray *anchorPoint = [NSArray arrayWithObjects:x, y, nil];
        self.valueAnnotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:plot.plotSpace anchorPlotPoint:anchorPoint];
    }
    static NSNumberFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    static CPTMutableTextStyle *style = nil;
    if (!style) {
        style = [CPTMutableTextStyle textStyle];
        style.color = [CPTColor blackColor];
        style.fontSize = 10.0f;
    }
    NSNumber *num = self.sumValue[index];
    NSString *priceValue = [formatter stringFromNumber:num];
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:priceValue style:style];
    self.valueAnnotation.contentLayer = textLayer;
    CGFloat x = index;
    NSNumber *anchorX = [NSNumber numberWithFloat:x];
    CGFloat y = [num floatValue] + 20000.0f;
    NSNumber *anchorY = [NSNumber numberWithFloat:y];
    self.valueAnnotation.anchorPlotPoint = [NSArray arrayWithObjects:anchorX, anchorY, nil];
    [plot.graph.plotAreaFrame.plotArea addAnnotation:self.valueAnnotation];
}
@end
