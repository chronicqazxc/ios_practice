//
//  ItemViewController.h
//  MyAssetDemo
//
//  Created by Wayne on 4/13/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ItemViewControllerDelegate;

@interface ItemViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) id <ItemViewControllerDelegate> delegate;
- (IBAction)clickOK:(UIButton *)sender;
- (IBAction)clickCancel:(UIButton *)sender;

@end

@protocol ItemViewControllerDelegate <NSObject>

- (void) reloadWithItem:(NSString *)item;

@end