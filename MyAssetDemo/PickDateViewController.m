//
//  PickDateViewController.m
//  MyAssetDemo
//
//  Created by Wayne on 4/13/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "PickDateViewController.h"

@interface PickDateViewController (){
    NSString *date;
    NSDateFormatter *format;
}

@end

@implementation PickDateViewController

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
    [self dateFormate];
    date = [format stringFromDate:self.datePicker.date];
}

- (void)dateFormate{
    format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
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

- (IBAction)pickDateValueChange:(UIDatePicker *)sender {

    date = [format stringFromDate:sender.date];
    
}

- (IBAction)clickCancel:(UIButton *)sender {
}

- (IBAction)clickOK:(UIButton *)sender {
    
    [self.delegate reloadDataWithDate:date];
    
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
}
@end
