//
//  ViewController.m
//  PopUpCalculator
//
//  Created by Wayne on 12/22/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ViewController.h"
#import "PopUpCalculator.h"

@interface ViewController () <PopUpCalculatorDelegate>
@property (retain, nonatomic) PopUpCalculator *calculator;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.calculator = [[[NSBundle mainBundle] loadNibNamed:@"PopUpCalculator" owner:self options:nil] lastObject];
    CGRect calculatorFrame = CGRectMake(self.calculator.calculatorView.frame.origin.x,
                                        self.view.frame.size.height/2-self.calculator.calculatorView.frame.size.height/2,
                                        self.calculator.calculatorView.frame.size.width,
                                        self.calculator.calculatorView.frame.size.height);
    self.calculator.delegate = self;
    self.calculator.calculatorView.frame = calculatorFrame;
    [self.calculator popUpCalculatorWithCost:@"0"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PopUpCalculatorDelegate
- (void)getCalculatResult:(NSString *)result {
    NSLog(@"%@",result);
}
@end
