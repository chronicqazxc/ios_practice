//
//  GetImageViewController.m
//  AccessImageWithDBTest
//
//  Created by Wayne on 2/7/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "GetImageViewController.h"
#import "ImageViewController.h"

@interface GetImageViewController ()

@end

@implementation GetImageViewController

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
    _inputField.delegate = self;
    _imageURL.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickAdd:(UIButton *)sender {
    [self performSegueWithIdentifier:@"add" sender:nil];
}

- (IBAction)clickSearch:(UIButton *)sender {
    [self performSegueWithIdentifier:@"search" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"add"]){
        ImageViewController *imageViewController = (ImageViewController *)segue.destinationViewController;
        imageViewController.number = [_inputField.text intValue];
        imageViewController.imageURL = _imageURL.text;
        imageViewController.determind = 1;
    }else if([segue.identifier isEqualToString:@"search"]){
        ImageViewController *imageViewController = (ImageViewController *)segue.destinationViewController;
        imageViewController.number = [_inputField.text intValue];
        imageViewController.determind = 2;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == _imageURL)
        [_inputField becomeFirstResponder];
    else if(textField == _inputField)
        [_inputField resignFirstResponder];
    return 1;
}
@end
