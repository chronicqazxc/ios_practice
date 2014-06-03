//
//  CostViewController.h
//  MyAssetDemo
//
//  Created by Wayne on 4/13/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CostViewControllerDelegate;

@interface CostViewController : UIViewController

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *numberButtons;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (strong, nonatomic) id <CostViewControllerDelegate> delegate;

- (IBAction)clickDigit:(UIButton *)sender;
- (IBAction)clickCancel:(UIButton *)sender;
- (IBAction)clickOK:(UIButton *)sender;


@end

@protocol CostViewControllerDelegate <NSObject>

- (void)reloadWithCost:(NSString *)cost;

@end
