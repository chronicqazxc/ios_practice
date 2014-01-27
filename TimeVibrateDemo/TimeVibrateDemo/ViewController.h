//
//  ViewController.h
//  TimeVibrateDemo
//
//  Created by Wayne on 1/27/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *labelTimer;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerList;
- (IBAction)clickStart:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *buttonStart;

@end
