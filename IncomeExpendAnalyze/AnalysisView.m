//
//  AnalysisView.m
//  IncomeExpendAnalyze
//
//  Created by Wayne on 5/29/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "AnalysisView.h"
#import "AnalysisTypeTableView.h"
#import "AnalysisTrendTableView.h"
#import "XibGetter.h"

@interface AnalysisView()
@property (retain, nonatomic) AnalysisTypeTableView *analysisTypeTableView;
@property (retain, nonatomic) AnalysisTrendTableView *analysisTrendTableView;
@end

@implementation AnalysisView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rects{
    self.analysisTypeTableView = [XibGetter getCustomViewByName:@"AnalysisTypeTableView"];
    self.analysisTrendTableView = [XibGetter getCustomViewByName:@"AnalysisTrendTableView"];
    CGRect rect = self.frame;
    rect.origin.y = self.btnTrend.frame.size.height + self.btnTrend.frame.origin.y;
    rect.size.height -= self.btnTrend.frame.size.height + self.btnTrend.frame.origin.y;
    self.analysisTypeTableView.frame = rect;
    self.analysisTrendTableView.frame = rect;
    [self addSubview:self.analysisTrendTableView];
    [self addSubview:self.analysisTypeTableView];
    self.analysisTrendTableView.hidden = YES;
    
    self.analysisTypeTableView.layer.borderColor = [UIColor redColor].CGColor;
    self.analysisTrendTableView.layer.borderColor = [UIColor blueColor].CGColor;
    self.analysisTypeTableView.layer.borderWidth = 2;
    self.analysisTrendTableView.layer.borderWidth = 2;
    
    [self.btnType addTarget:self action:@selector(switchView) forControlEvents:UIControlEventTouchUpInside];
    [self.btnTrend addTarget:self action:@selector(switchView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)switchView{
    if (self.btnType.state == UIControlStateHighlighted) {
        self.analysisTypeTableView.hidden = NO;
        self.analysisTypeTableView.layer.hidden = NO;
        self.analysisTrendTableView.hidden = YES;
        self.analysisTrendTableView.hidden = YES;
    } else if (self.btnTrend.state == UIControlStateHighlighted) {
        self.analysisTypeTableView.hidden = YES;
        self.analysisTypeTableView.layer.hidden = YES;
        self.analysisTrendTableView.hidden = NO;
        self.analysisTrendTableView.layer.hidden = NO;
    }
}

- (void)updateChildren{
    
}

- (void)dealloc {
    [_btnType release];
    [_btnTrend release];
    [_analysisTrendTableView release];
    [_analysisTypeTableView release];
    [super dealloc];
}
@end
