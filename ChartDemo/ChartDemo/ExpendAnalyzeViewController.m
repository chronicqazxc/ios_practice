//
//  ExpendAnalyzeViewController.m
//  ChartDemo
//
//  Created by Wayne on 5/14/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ExpendAnalyzeViewController.h"
#import "PieChart.h"

@interface ExpendAnalyzeViewController ()
@property (strong, nonatomic) PieChart *pieChart;
@property (strong, nonatomic) NSLayoutConstraint *constraintTop;
@property (strong, nonatomic) NSLayoutConstraint *constraintBottom;
@property (strong, nonatomic) NSLayoutConstraint *constraintTrailling;
@property (strong, nonatomic) NSLayoutConstraint *constraintLeading;
@end

@implementation ExpendAnalyzeViewController

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
    CGRect rect = [[UIScreen mainScreen] bounds];
    self.pieChart = [[PieChart alloc] initWithFrame:CGRectMake(0,0,rect.size.height*0.3,rect.size.height*0.3)];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        int randomValue = arc4random() % 10000;
        [tempArray addObject:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", randomValue]]];
    }
    [self.pieChart setPieChartData:tempArray andColors:@[[UIColor blueColor],
                                                         [UIColor redColor],
                                                         [UIColor orangeColor]]];
    [self.pieChart initPlot];
    [self.view addSubview:self.pieChart];
    [self.pieChart setTranslatesAutoresizingMaskIntoConstraints:NO];
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
    CGRect rect = [[UIScreen mainScreen] bounds];
    self.constraintTop = [NSLayoutConstraint constraintWithItem:self.pieChart
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.topLayoutGuide
                                                      attribute:NSLayoutAttributeBottom
                                                     multiplier:1
                                                       constant:rect.size.height * 0.2];
    self.constraintTrailling = [NSLayoutConstraint constraintWithItem:self.view
                                                            attribute:NSLayoutAttributeTrailing
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.pieChart
                                                            attribute:NSLayoutAttributeTrailing
                                                           multiplier:1
                                                             constant:20];
    self.constraintLeading = [NSLayoutConstraint constraintWithItem:self.pieChart
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1
                                                           constant:20];
    self.constraintBottom = [NSLayoutConstraint constraintWithItem:self.bottomLayoutGuide
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.pieChart
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1
                                                  constant:rect.size.height * 0.12];
    [self.view addConstraint:self.constraintTop];
    [self.view addConstraint:self.constraintTrailling];
    [self.view addConstraint:self.constraintLeading];
    [self.view addConstraint:self.constraintBottom];
}

- (void)configureLandscapeConstraint{
    self.constraintTop = [NSLayoutConstraint constraintWithItem:self.pieChart
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.topLayoutGuide
                                                      attribute:NSLayoutAttributeBottom
                                                     multiplier:1
                                                       constant:10];
    self.constraintTrailling = [NSLayoutConstraint constraintWithItem:self.view
                                                            attribute:NSLayoutAttributeTrailing
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.pieChart
                                                            attribute:NSLayoutAttributeTrailing
                                                           multiplier:1
                                                             constant:10];
    self.constraintLeading = [NSLayoutConstraint constraintWithItem:self.pieChart
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1
                                                           constant:10];
    self.constraintBottom = [NSLayoutConstraint constraintWithItem:self.bottomLayoutGuide
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.pieChart
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1
                                                          constant:10];
    [self.view addConstraint:self.constraintTop];
    [self.view addConstraint:self.constraintTrailling];
    [self.view addConstraint:self.constraintLeading];
    [self.view addConstraint:self.constraintBottom];
}
@end
