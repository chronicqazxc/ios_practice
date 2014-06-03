//
//  RegisterViewController.m
//  MyAssetDemo
//
//  Created by Wayne on 4/14/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "RegisterViewController.h"
#import "Account.h"
#import "AddAccount.h"
#import "Search.h"
#import "Authentication.h"
#import "NSData+Encryption.h"
#import "MyAssetTableViewController.h"

NSString *const RegisteSuccessIdentifier = @"ToMyAsset";

@interface RegisterViewController (){
    Account *account;
}

@end

@implementation RegisterViewController

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
    
    self.userID.delegate = self;
    
    self.userName.delegate = self;
    
    self.password.delegate = self;
    
    self.conformPassword.delegate = self;
    
    self.okButton.enabled = NO;
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

- (IBAction)clickCancel:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
    
}

- (IBAction)clickOK:(UIButton *)sender {
    
    [self prepareAddAccount];
    
    if([AddAccount addAccountWithAccount:account]){
        
        [self processLogin];
        
    }else{
        
        [[[UIAlertView alloc] initWithTitle:@"Regist Result" message:@"Faild" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    
}

- (void)prepareAddAccount{
    
    account = [[Account alloc] init];
    
    account.user_id = self.userID.text;
    
    account.user_name = self.userName.text;
    
    account.user_password = [self.password.text dataUsingEncoding:NSUTF8StringEncoding];
    
}

- (void)processLogin{
    account = [Search queryAccountWithUserID:self.userID.text];
    
    if (account.user_id != nil){
        if([Authentication authenticateAccount:account withPassword:self.password.text])
            [self processSuccess];
        else
            [[[UIAlertView alloc] initWithTitle:@"Login Result" message:@"password error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Login Result" message:@"User ID error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}

- (void)processSuccess{
    
    [self textFieldShouldReturn:self.conformPassword];
    
    [self performSegueWithIdentifier:RegisteSuccessIdentifier sender:nil];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:RegisteSuccessIdentifier]){
        
        [[[UIAlertView alloc] initWithTitle:@"Registered Success" message:[NSString stringWithFormat:@"Hi, %@",account.user_name] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        
        self.userID.text = @"";
        self.userName.text = @"";
        self.password.text = @"";
        self.conformPassword.text = @"";
        
        MyAssetTableViewController *myAsset = (MyAssetTableViewController *)[[[segue.destinationViewController viewControllers] objectAtIndex:0] topViewController];
        
        myAsset.account = account;
        
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.userID){
        [textField resignFirstResponder];
        [self.userName becomeFirstResponder];
    }else if(textField == self.userName){
        [textField resignFirstResponder];
        [self.password becomeFirstResponder];
    }else if(textField == self.password){
        [textField resignFirstResponder];
        [self.conformPassword becomeFirstResponder];
    }else if(textField == self.conformPassword){
        
        if ([self authenticate]){
            [textField resignFirstResponder];
            self.okButton.enabled = YES;
        }
        else
            [[[UIAlertView alloc] initWithTitle:@"Conform Error" message:@"Please check password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            
    }
    
    return YES;
}

- (BOOL)authenticate{
   return (![self.userID.text isEqualToString:@""] && ![self.userName.text isEqualToString:@""] && ![self.password.text isEqualToString:@""] && [self.password.text isEqualToString: self.conformPassword.text]);
}

@end
