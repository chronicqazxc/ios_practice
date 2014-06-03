//
//  ItemViewController.m
//  MyAssetDemo
//
//  Created by Wayne on 4/13/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ItemViewController.h"

@interface ItemViewController (){
    NSArray *drink;
    NSArray *food;
    NSString *itemName;
}

@end

@implementation ItemViewController

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
    self.pickerView.delegate = self;
    drink = @[@"可樂",@"雪碧",@"紅茶",@"綠茶"];
    food = @[@"飯",@"麵",@"麵包",@"餅乾",@"漢堡"];
    
    itemName = drink[0];
    
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


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    int num = 0;
    
    switch (component){
        case 0:
            num = 2;
            break;
        case 1:
            switch([pickerView selectedRowInComponent:0]){
                case 0:
                    num = [drink count];
                    break;
                case 1:
                    num = [food count];
                    break;
            }
    }
    
    return num;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *title;
    if (component == 0){
        switch(row){
            case 0:
                title = @"飲料";
                break;
            case 1:
                title = @"食物";
                break;
        }
    }else if (component == 1){
        switch ([pickerView selectedRowInComponent:0]){
            case 0:
                title = drink[row];
                break;
            case 1:
                title = food[row];
                break;
        }
    }
    
    return title;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    if(component == 0){
        [pickerView reloadComponent: 1];
        [pickerView selectRow:0 inComponent:1 animated: 1];
        switch([pickerView selectedRowInComponent:0]){
            case 0:
                itemName = drink[0];
                break;
            case 1:
                itemName = food[0];
                break;
        }
    }else{
        switch([pickerView selectedRowInComponent:0]){
            case 0:
                itemName = drink[[pickerView selectedRowInComponent:1]];
                break;
            case 1:
                itemName = food[[pickerView selectedRowInComponent:1]];
                break;
        }
        
    }
}
- (IBAction)clickOK:(UIButton *)sender {
    
    [self.delegate reloadWithItem:itemName];
    
    [self dismissSelf];
    
}
- (IBAction)clickCancel:(UIButton *)sender {
    
    [self dismissSelf];
    
}

- (void)dismissSelf{
    
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
    
}
@end
