//
//  AnalysisView.h
//  IncomeExpendAnalyze
//
//  Created by Wayne on 5/29/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnalysisView : UIView

@property (retain, nonatomic) IBOutlet UIButton *btnType;
@property (retain, nonatomic) IBOutlet UIButton *btnTrend;

- (void)switchView;
- (void)updateChildren;

@end
