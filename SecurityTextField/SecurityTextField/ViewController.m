//
//  ViewController.m
//  SecurityTextField
//
//  Created by Wayne on 1/6/15.
//  Copyright (c) 2015 Wayne. All rights reserved.
//

#import "ViewController.h"
#import "SecurityTextField.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet SecurityTextField *securityTextField;
@property (weak, nonatomic) IBOutlet SecurityTextField *securityTextField2;
@property (weak, nonatomic) IBOutlet SecurityTextField *securityTextField3;
@property (weak, nonatomic) IBOutlet SecurityTextField *securityTextField4;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.securityTextField.maskString = @"•";
    self.securityTextField2.maskString = @"•";
    self.securityTextField3.maskString = @"•";
    self.securityTextField4.maskString = @"•";
    
    self.securityTextField.textFieldLength = 4;
    self.securityTextField2.textFieldLength = 4;
    self.securityTextField3.textFieldLength = 4;
    self.securityTextField4.textFieldLength = 4;
    
    [self.securityTextField setRangeLocation:0 length:4];
    self.securityTextField.shouldMaskLastCharactor = NO;
    [self.securityTextField4 setRangeLocation:3 length:2];
    self.securityTextField4.shouldMaskLastCharactor = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
- (IBAction)clickShow:(UIButton *)sender {
    self.showLabel.text = [NSString stringWithFormat:@"%@-%@-%@-%@",[self.securityTextField getContent],[self.securityTextField2 getContent],[self.securityTextField3 getContent],[self.securityTextField4 getContent]];
}

@end
