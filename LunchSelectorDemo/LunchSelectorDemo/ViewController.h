//
//  ViewController.h
//  LunchSelectorDemo
//
//  Created by Wayne on 1/27/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIPickerView *slotView;
@property (strong, nonatomic) IBOutlet UILabel *label;

@end
