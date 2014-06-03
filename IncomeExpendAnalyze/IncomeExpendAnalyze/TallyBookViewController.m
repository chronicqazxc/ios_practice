//
//  TallyBookViewController.m
//  IncomeExpendAnalyze
//
//  Created by Wayne on 5/29/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "TallyBookViewController.h"
#import "TallyBookRevenueView.h"
#import "TallyBookExpenditureView.h"
#import "TallyBookDetailView.h"
#import "XibGetter.h"

@interface TallyBookViewController ()

@property (retain, nonatomic) TallyBookRevenueView *tallyBookRevenueView;
@property (retain, nonatomic) TallyBookExpenditureView *tallyBookExpenditureView;
@property (retain, nonatomic) TallyBookDetailView *tallyBookDetailView;

@end

@implementation TallyBookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = self.view.frame;
    rect.origin.x = 0;
    rect.origin.y = ((UIButton *)self.buttonCollection[0]).frame.size.height;
    rect.size.height -= ((UIButton *)self.buttonCollection[0]).frame.size.height;
    self.tallyBookRevenueView = [XibGetter getCustomViewByName:@"AnalysisView"];
    self.tallyBookRevenueView.frame = rect;
    self.tallyBookExpenditureView = [XibGetter getCustomViewByName:@"AnalysisView"];
    self.tallyBookExpenditureView.frame = rect;
    self.tallyBookDetailView = [XibGetter getCustomViewByName:@"TallyBookDetailView"];
    self.tallyBookDetailView.frame = rect;
    [self.view addSubview:self.tallyBookDetailView];
    [self.view addSubview:self.tallyBookExpenditureView];
    [self.view addSubview:self.tallyBookRevenueView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void)getData{
    
}

- (void)ebRevExpStatusInqNext{
    
}

- (void)ebRevExpItemInqNext{
    
}

- (void)ebRevExpAcctInq{
    
}

- (void)showLoading{
    
}

- (void)getRevExpStatus{
    
}

- (void)switchView{
    
}

- (void)updateChildren{
    
}

- (IBAction)clickButton:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
//            [self.view bringSubviewToFront:self.tallyBookRevenueView];
            self.tallyBookRevenueView.hidden = NO;
            self.tallyBookExpenditureView.hidden = YES;
            self.tallyBookDetailView.hidden = YES;
            break;
        case 1:
//            [self.view bringSubviewToFront:self.tallyBookExpenditureView];
            self.tallyBookExpenditureView.hidden = NO;
            self.tallyBookRevenueView.hidden = YES;
            self.tallyBookDetailView.hidden = YES;
            break;
        case 2:
//            [self.view bringSubviewToFront:self.tallyBookDetailView];
            self.tallyBookDetailView.hidden = NO;
            self.tallyBookExpenditureView.hidden = YES;
            self.tallyBookRevenueView.hidden = YES;
            break;
    }
}
- (void)dealloc {
    [_buttonCollection release];
    [_tallyBookExpenditureView release];
    [_buttonCollection release];
    [_tallyBookDetailView release];
    [_myView release];
    [super dealloc];
}
@end
