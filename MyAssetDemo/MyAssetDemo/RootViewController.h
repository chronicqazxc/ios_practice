//
//  RootViewController.h
//  MyAssetDemo
//
//  Created by Wayne on 4/12/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAssetTableViewController.h"
#import "Account.h"

@interface RootViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userIdField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)clickLogin:(UIButton *)sender;
- (IBAction)clickCancel:(UIButton *)sender;
- (IBAction)clickRegister:(UIButton *)sender;

@end
