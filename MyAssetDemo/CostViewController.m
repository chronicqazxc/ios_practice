//
//  CostViewController.m
//  MyAssetDemo
//
//  Created by Wayne on 4/13/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "CostViewController.h"

@interface CostViewController (){
    int currentNumber;
    NSMutableString *displayString;
}

@end

@implementation CostViewController

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
    // Do any additional setup after loading the view.
    for (UIButton *i in self.numberButtons){
        i.layer.masksToBounds = 1;
        i.layer.cornerRadius = 8;
    }
    
    displayString = [[NSMutableString alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickDigit:(UIButton *)sender {
    int digit = sender.tag;
    
    [self processDigit:digit];
}

- (IBAction)clickCancel:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
    
}

- (IBAction)clickOK:(UIButton *)sender {
    
    [self.delegate reloadWithCost:displayString];
    
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
    
}

- (void)processDigit:(int)digit{
    
    currentNumber = currentNumber * 10 + digit;
    
    [displayString appendString:[NSString stringWithFormat:@"%d",digit]];
    
    self.number.text = displayString;
}
@end
