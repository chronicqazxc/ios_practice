//
//  RegisterViewController.h
//  MyAssetDemo
//
//  Created by Wayne on 4/14/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userID;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *conformPassword;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

- (IBAction)clickCancel:(UIButton *)sender;
- (IBAction)clickOK:(UIButton *)sender;

@end
