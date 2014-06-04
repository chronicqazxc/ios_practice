//  賬戶總覽趨勢分析
//  AccountOverviewChartViewController.m
//  ChartDemo
//
//  Created by Wayne on 5/13/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "AccountOverviewChartViewController.h"
#import "AccountOverviewChart.h"

@interface AccountOverviewChartViewController ()
@property (strong, nonatomic) AccountOverviewChart *stackedBarChart;
@property (strong, nonatomic) NSLayoutConstraint *constraintTop;
@property (strong, nonatomic) NSLayoutConstraint *constraintBottom;
@property (strong, nonatomic) NSLayoutConstraint *constraintTrailling;
@property (strong, nonatomic) NSLayoutConstraint *constraintLeading;
@end

@implementation AccountOverviewChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.stackedBarChart = [[AccountOverviewChart alloc] init];
    NSMutableDictionary *dataTemp = [[NSMutableDictionary alloc] init];
    NSArray *xAxisContents = @[@"102/12",
                        @"103/1",
                        @"103/2",
                        @"103/3",
                        @"103/4",
                        @"103/5",
                        @"103/6",
                        @"103/7",
                        @"103/8",
                        @"103/9",
                        @"103/10",
                        @"103/11",
                        @"103/12",
                        @"103/goal"];
    [self.stackedBarChart generateXAxisContents:xAxisContents];
    NSDictionary *plotsWithColors = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIColor darkGrayColor], @"保險",
                                     [UIColor orangeColor],   @"結構型商品",
                                     [UIColor redColor],      @"黃金存摺",
                                     [UIColor blueColor],     @"信託投資",
                                     [UIColor grayColor],     @"外幣存款",
                                     [UIColor greenColor],    @"台幣存款", nil];
    NSArray *sortedAccountItems = @[@"保險",
                           @"結構型商品",
                           @"黃金存摺",
                           @"信託投資",
                           @"外幣存款",
                                    @"台幣存款"];
    [self.stackedBarChart generatePlotsWithColors:plotsWithColors andSort:sortedAccountItems];
    for (NSString *xAxisContent in xAxisContents) {
        NSMutableDictionary *plotsWithValue = [NSMutableDictionary dictionary];
        for (NSString *keyForValue in [plotsWithColors allKeys]) {
            NSNumber *num = [NSNumber numberWithInteger:arc4random_uniform(100)+1];
            if ([xAxisContent isEqualToString:@"103/9"] ||
                [xAxisContent isEqualToString:@"103/10"] ||
                [xAxisContent isEqualToString:@"103/11"] ||
                [xAxisContent isEqualToString:@"103/12"]) {
                num = [NSNumber numberWithInt:0];
            } else if ([xAxisContent isEqualToString:@"103/goal"]){
                num = [NSNumber numberWithInt:83];
            }
            [plotsWithValue setObject:num forKey:keyForValue];
        }
        [dataTemp setObject:plotsWithValue forKey:xAxisContent];
    }
    
    self.stackedBarChart.isPlotColorWithGradient = NO;
    [self.stackedBarChart generateData:dataTemp];
    [self.stackedBarChart generateLayout];
    
    //    [self turnToPortrait];
    
    [self.stackedBarChart setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.stackedBarChart];
    
    [self configurePortraitConstraint];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    switch (fromInterfaceOrientation) {
        case UIInterfaceOrientationLandscapeRight:
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationPortraitUpsideDown:
            [self turnToPortrait];
            break;
        case UIInterfaceOrientationPortrait:
        default:
            [self turnToLandscape];
            break;
    }
}

- (void)turnToPortrait{
    [self.view removeConstraints:@[self.constraintTop,
                                   self.constraintTrailling,
                                   self.constraintLeading,
                                   self.constraintBottom]];
    [self configurePortraitConstraint];
}

- (void)turnToLandscape{
    [self.view removeConstraints:@[self.constraintTop,
                                   self.constraintTrailling,
                                   self.constraintLeading,
                                   self.constraintBottom]];
    [self configureLandscapeConstraint];
}

- (void)configurePortraitConstraint{
    self.constraintTop = [NSLayoutConstraint constraintWithItem:self.stackedBarChart
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.topLayoutGuide
                                                      attribute:NSLayoutAttributeBottom
                                                     multiplier:1
                                                       constant:200];
    self.constraintTrailling = [NSLayoutConstraint constraintWithItem:self.view
                                                      attribute:NSLayoutAttributeTrailing
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.stackedBarChart
                                                      attribute:NSLayoutAttributeTrailing
                                                     multiplier:1
                                                       constant:15];
    self.constraintLeading = [NSLayoutConstraint constraintWithItem:self.stackedBarChart
                                                      attribute:NSLayoutAttributeLeading
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.view
                                                      attribute:NSLayoutAttributeLeading
                                                     multiplier:1
                                                       constant:15];
    self.constraintBottom = [NSLayoutConstraint constraintWithItem:self.bottomLayoutGuide
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.stackedBarChart
                                                      attribute:NSLayoutAttributeBottom
                                                     multiplier:1
                                                       constant:68];
    [self.view addConstraint:self.constraintTop];
    [self.view addConstraint:self.constraintTrailling];
    [self.view addConstraint:self.constraintLeading];
    [self.view addConstraint:self.constraintBottom];
}

- (void)configureLandscapeConstraint{
    self.constraintTop = [NSLayoutConstraint constraintWithItem:self.stackedBarChart
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.topLayoutGuide
                                                      attribute:NSLayoutAttributeBottom
                                                     multiplier:1
                                                       constant:10];
    self.constraintTrailling = [NSLayoutConstraint constraintWithItem:self.view
                                                            attribute:NSLayoutAttributeTrailing
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.stackedBarChart
                                                            attribute:NSLayoutAttributeTrailing
                                                           multiplier:1
                                                             constant:10];
    self.constraintLeading = [NSLayoutConstraint constraintWithItem:self.stackedBarChart
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1
                                                           constant:10];
    self.constraintBottom = [NSLayoutConstraint constraintWithItem:self.bottomLayoutGuide
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.stackedBarChart
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1
                                                          constant:10];
    [self.view addConstraint:self.constraintTop];
    [self.view addConstraint:self.constraintTrailling];
    [self.view addConstraint:self.constraintLeading];
    [self.view addConstraint:self.constraintBottom];
}
@end
