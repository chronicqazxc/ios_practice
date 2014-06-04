//  活存收支概要
//  IncomExpensesChartViewController.m
//  ChartDemo
//
//  Created by Wayne on 5/16/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "IncomExpensesChartViewController.h"
#import "IncomeExpensesChart.h"

@interface IncomExpensesChartViewController ()

@property (strong, nonatomic) IncomeExpensesChart *stackedBarChart;
@property (strong, nonatomic) NSLayoutConstraint *constraintTop;
@property (strong, nonatomic) NSLayoutConstraint *constraintBottom;
@property (strong, nonatomic) NSLayoutConstraint *constraintTrailling;
@property (strong, nonatomic) NSLayoutConstraint *constraintLeading;

- (void)configurePortraitConstraint;
@end

@implementation IncomExpensesChartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.stackedBarChart = [[IncomeExpensesChart alloc] init];
    
    NSMutableDictionary *dataTemp = [[NSMutableDictionary alloc] init];
    NSArray *months = @[@"102/12",
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
                        @"103/12"];
    [self.stackedBarChart generateXAxisContents:months];
    NSDictionary *plotsWithColors = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIColor grayColor], @"Income",
                                     [UIColor orangeColor],   @"Expend", nil];
    NSArray *sortedKeys = @[@"Income",
                            @"Expend"];
    [self.stackedBarChart generatePlotsAndColors:plotsWithColors sortedKeys:sortedKeys];
    for (NSString *month in months) {
        NSMutableDictionary *plotsWithValue = [NSMutableDictionary dictionary];
        for (NSString *keyForValue in [plotsWithColors allKeys]) {
            NSNumber *num = [NSNumber numberWithInteger:arc4random_uniform(100000)+1];
            [plotsWithValue setObject:num forKey:keyForValue];
        }
        [dataTemp setObject:plotsWithValue forKey:month];
    }
    self.stackedBarChart.isPlotColorWithGradient = NO;
    [self.stackedBarChart generateData:dataTemp];
    [self.stackedBarChart generateLayout];
    [self.stackedBarChart setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.stackedBarChart];
    
    [self configurePortraitConstraint];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
