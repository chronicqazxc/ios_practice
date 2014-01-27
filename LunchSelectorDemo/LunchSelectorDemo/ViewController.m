//
//  ViewController.m
//  LunchSelectorDemo
//
//  Created by Wayne on 1/27/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    NSMutableDictionary *areaDic;
    NSArray *areaTitleIndex;
    NSMutableDictionary *foodDic;
    NSArray *foodTitleIndex;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //    _slotView = [[UIPickerView alloc] init];
    _slotView.delegate = self;
    
    //    _slotView.layer.cornerRadius = 65;
    //    UIGraphicsBeginImageContext(_slotView.frame.size);
    //    [[UIImage imageNamed:@"grey-rectangular-button-md.png"]drawInRect:CGRectMake(0.0f,0.0f,_slotView.bounds.size.width,_slotView.bounds.size.height)];
    //    NSLog(@"_slotView.bounds.size.height:%.1f,_slotView.bounds.size.width:%.1f",_slotView.bounds.size.height,_slotView.bounds.size.width);
    //    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    UIImage *image = [UIImage imageNamed:@"2.png"];
    _slotView.backgroundColor = [UIColor colorWithPatternImage:image];
    areaDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"東區",@"0",
               @"西門",@"1",
               @"中山",@"2",
               @"士林",@"3",
               @"天母",@"4",nil];
    areaTitleIndex = [[NSArray alloc] initWithArray:[areaDic allKeys]];
    
    foodDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@[@"我家那",@"拉麵",@"燒烤",@"鍋物"],@"0",
               @[@"小吃",@"義麵",@"燒烤",@"鍋物"],@"1",
               @[@"百貨",@"義麵",@"文青店",@"當仔"],@"2",
               @[@"夜市",@"當仔",@"通河",@"自煮"],@"3",
               @[@"百貨",@"小吃",@"飯",@"麵"],@"4",nil];
    foodTitleIndex = [[NSArray alloc] initWithArray:[foodDic allKeys]];
    
    
    _label.text = [NSString stringWithFormat:@"今天要去哪吃"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}


-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 18000;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *area;
    NSString *food;
    if(component == 0){
        switch(row%[areaTitleIndex count]){
            case 0:
                area = [areaDic objectForKey:[areaTitleIndex objectAtIndex:0]];
                break;
            case 1:
                area = [areaDic objectForKey:[areaTitleIndex objectAtIndex:1]];
                break;
            case 2:
                area = [areaDic objectForKey:[areaTitleIndex objectAtIndex:2]];
                break;
            case 3:
                area = [areaDic objectForKey:[areaTitleIndex objectAtIndex:3]];
                break;
            case 4:
                area = [areaDic objectForKey:[areaTitleIndex objectAtIndex:4]];
                break;
        }
        return area;
    }else{
        switch(row%4){
            case 0:
                food = [[foodDic objectForKey:[foodTitleIndex objectAtIndex:[pickerView selectedRowInComponent:0]%[foodTitleIndex count]]] objectAtIndex:0];
                break;
            case 1:
                food = [[foodDic objectForKey:[foodTitleIndex objectAtIndex:[pickerView selectedRowInComponent:0]%[foodTitleIndex count]]] objectAtIndex:1];
                break;
            case 2:
                food = [[foodDic objectForKey:[foodTitleIndex objectAtIndex:[pickerView selectedRowInComponent:0]%[foodTitleIndex count]]] objectAtIndex:2];
                break;
            case 3:
                food = [[foodDic objectForKey:[foodTitleIndex objectAtIndex:[pickerView selectedRowInComponent:0]%[foodTitleIndex count]]] objectAtIndex:3];
                break;
        }
        return food;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(component == 0){
        [pickerView reloadComponent: 1];
        [pickerView selectRow:0 inComponent:1 animated: 1];
        _label.text = [NSString stringWithFormat:@"今天要去%@吃啥",
                       [areaDic objectForKey:[areaTitleIndex objectAtIndex:row%[areaTitleIndex count]]]];
    }else{
        NSString *string = [NSString stringWithFormat:@"就決定是%@了!",[[foodDic objectForKey:[foodTitleIndex objectAtIndex:[pickerView selectedRowInComponent:0]%[foodTitleIndex count]]] objectAtIndex:[pickerView selectedRowInComponent:1]%4]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self initialize];
}

-(void) initialize{
    [_slotView reloadComponent: 0];
    [_slotView selectRow:0 inComponent:0 animated: 1];
    [_slotView reloadComponent: 1];
    [_slotView selectRow:0 inComponent:1 animated: 1];
    _label.text = @"今天要去哪吃";
}
@end
