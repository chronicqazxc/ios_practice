//
//  RootViewController.m
//  MyAssetDemo
//
//  Created by Wayne on 4/12/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "RootViewController.h"
#import "Search.h"
#import "Account.h"
#import "Authentication.h"
#import "MyAssetTableViewController.h"

NSString *const SuccessIdentifier = @"ToMyAsset";

@interface RootViewController (){
    
    Account *account;
}

@end

@implementation RootViewController

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
    [self prepare];
}

- (void)prepare{
    [self prepareBackgroundImage:@"background-img.jpg"];
    self.userIdField.delegate = self;
    self.passwordField.delegate = self;
    
}

- (void)prepareBackgroundImage:(NSString *)imageName{
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:imageName] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage: image];
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

#pragma mark -
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.userIdField){
        [self.userIdField resignFirstResponder];
        [self.passwordField becomeFirstResponder];
    }else if( textField == self.passwordField){
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (IBAction)clickLogin:(UIButton *)sender {
    account = [Search queryAccountWithUserID:self.userIdField.text];
    
    if (account.user_id != nil){
        if([Authentication authenticateAccount:account withPassword:self.passwordField.text])
            [self processSuccess];
        else
            [[[UIAlertView alloc] initWithTitle:@"Login Result" message:@"password error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Login Result" message:@"User ID error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}

- (IBAction)clickCancel:(UIButton *)sender {
    self.userIdField.text = @"";
    self.passwordField.text = @"";
    
    [self.userIdField becomeFirstResponder];
}

- (IBAction)clickRegister:(UIButton *)sender {
    [self performSegueWithIdentifier:@"ToRegister" sender:nil];
}

- (void)processSuccess{
    [[[UIAlertView alloc] initWithTitle:@"Welcome Back" message:account.user_name delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    
    [self textFieldShouldReturn:self.passwordField];
    
    [self performSegueWithIdentifier:SuccessIdentifier sender:nil];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:SuccessIdentifier]){
        
        self.userIdField.text = @"";
        self.passwordField.text = @"";
        
        MyAssetTableViewController *myAsset = (MyAssetTableViewController *)[[[segue.destinationViewController viewControllers] objectAtIndex:0] topViewController];
        
        myAsset.account = account;
    }
}
@end
