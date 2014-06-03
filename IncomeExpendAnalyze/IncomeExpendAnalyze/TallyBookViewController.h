//
//  TallyBookViewController.h
//  IncomeExpendAnalyze
//
//  Created by Wayne on 5/29/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TallyBookViewController : UIViewController

@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *buttonCollection;
@property (retain, nonatomic) NSArray *arrayRevExpItem;
@property (retain, nonatomic) NSArray *arrayRevExpAcct;
@property (retain, nonatomic) NSTimer *statusTimer;
@property (retain, nonatomic) IBOutlet UIView *myView;

- (void)getData;
- (void)ebRevExpStatusInqNext;
- (void)ebRevExpItemInqNext;
- (void)ebRevExpAcctInq;
- (void)showLoading;
- (void)getRevExpStatus;
- (void)switchView;
- (void)updateChildren;
- (IBAction)clickButton:(UIButton *)sender;



@end
