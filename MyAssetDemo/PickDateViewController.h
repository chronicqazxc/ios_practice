//
//  PickDateViewController.h
//  MyAssetDemo
//
//  Created by Wayne on 4/13/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickDateViewControllerDelegate;

@interface PickDateViewController : UIViewController

@property (strong, nonatomic) id <PickDateViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)pickDateValueChange:(UIDatePicker *)sender;
- (IBAction)clickCancel:(UIButton *)sender;
- (IBAction)clickOK:(UIButton *)sender;

@end

@protocol PickDateViewControllerDelegate <NSObject>

- (void)reloadDataWithDate:(NSString *)date;

@end