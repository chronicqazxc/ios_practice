//
//  AnalysisTrendTableView.m
//  IncomeExpendAnalyze
//
//  Created by Wayne on 5/29/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "AnalysisTrendTableView.h"
#import "AnalysisTrendSettingTableViewCell.h"
#import "AnalysisTrendChartTableViewCell.h"
#import "AnalysisTrendListTableViewCell.h"
#import "FilterAndChartSection.h"
#import "XibGetter.h"

@interface AnalysisTrendTableView()
@property (retain, nonatomic) NSMutableArray *filterData;
@property (retain, nonatomic) NSMutableArray *chartData;
@property (retain, nonatomic) NSMutableArray *typeData;
@property (retain, nonatomic) FilterAndChartSection *settingSection;
@property (retain, nonatomic) FilterAndChartSection *chartSection;
@property (retain, nonatomic) FilterAndChartSection *listSection;
@property (retain, nonatomic) AnalysisTrendSettingTableViewCell *settingCell;
@property (retain, nonatomic) AnalysisTrendChartTableViewCell *chartCell;
@property (retain, nonatomic) AnalysisTrendListTableViewCell *listCell;
@property (retain, nonatomic) ExpandContractProcessor *expandContractProcessor;
@end

@implementation AnalysisTrendTableView

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
        self.dataSource = self;
        self.delegate = self;
        self.filterData = [NSMutableArray arrayWithCapacity:1];
        self.chartData = [NSMutableArray arrayWithCapacity:1];
        self.typeData = [NSMutableArray arrayWithObjects:[NSDecimalNumber numberWithInt:1], [NSDecimalNumber numberWithInt:2], [NSDecimalNumber numberWithInt:3], nil];
        self.expandContractProcessor = [[ExpandContractProcessor alloc] initWithListSection:2 AndTypeCount:[self.typeData count]];
        self.expandContractProcessor.delegate = self;
        self.expandContractProcessor.data = @[self.filterData, self.chartData, self.typeData];
    }
    return self;
}

- (void)getData{
    
}

- (void)showAcctPicker{
    
}

- (void)showStackedBarChart{
    
}

- (void)showInfo{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.expandContractProcessor.data[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *settingCellIdentifier = @"AnalysisTrendSettingTableViewCell";
    static NSString *chartCellIdentifier = @"AnalysisTrendChartTableViewCell";
    static NSString *listCellIdentifier = @"AnalysisTrendListTableViewCell";
    id cell = nil;
    switch (indexPath.section) {
        case 0:
            self.settingCell = [tableView dequeueReusableCellWithIdentifier:settingCellIdentifier];
            if (!self.settingCell) {
                self.settingCell = [XibGetter getCustomViewByName:@"AnalysisTrendSettingTableViewCell"];
            }
            cell = self.settingCell;
            break;
        case 1:
            self.chartCell = [tableView dequeueReusableCellWithIdentifier:chartCellIdentifier];
            if (!self.chartCell) {
                self.chartCell = [XibGetter getCustomViewByName:@"AnalysisTrendChartTableViewCell"];
            }
            cell = self.chartCell;
            break;
        case 2:
            self.listCell = [tableView dequeueReusableCellWithIdentifier:listCellIdentifier];
            if (!self.listCell) {
                self.listCell = [XibGetter getCustomViewByName:@"AnalysisTrendListTableViewCell"];
            }
            cell = self.listCell;
            break;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    id sectionView = nil;
    switch (section) {
        case 0:
            if (!self.settingSection) {
                self.settingSection = [FilterAndChartSection generateSectionWithTitle:@"篩選條件" InSection:section];
                self.settingSection.delegate = self;
            }
            sectionView = self.settingSection;
            break;
        case 1:
            if (!self.chartSection) {
                self.chartSection = [FilterAndChartSection generateSectionWithTitle:@"支出類型分析" InSection:section];
                self.chartSection.delegate = self;
            }
            sectionView = self.chartSection;
            break;
        case 2:
            if (!self.listSection) {
                self.listSection = [FilterAndChartSection generateSectionWithTitle:@"年/月                              支出總額" InSection:section];
                CGRect listRect = self.listSection.frame;
                listRect.size.height = 44.0;
                CGRect labelRect = self.listSection.titleLabel.frame;
                labelRect.origin.y -= 15;
                self.listSection.titleLabel.frame = labelRect;
                self.listSection.frame = listRect;
                self.listSection.button.hidden = YES;
            }
            sectionView = self.listSection;
            break;
        default:
            break;
    }
    return sectionView;
}

#pragma mark - FilterAndChartSectionDelegate method
- (void)insertOrDeleteRow:(UIView *)sectionHeader InSection:(NSUInteger)section{
    if ([((FilterAndChartSection *)sectionHeader) isExpand]) {
        [self.expandContractProcessor deleteDatas:1 From:0 InSection:section];
    } else {
        [self.expandContractProcessor insertDatas:1 From:0 InSection:section];
    }
}
#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2)
        return 44.0;
    else
        return 81.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 44.0;
    switch (indexPath.section) {
        case 0:
            height = 162.0;
            break;
        case 1:
            height = 261.0;
            break;
        case 2:
            height = 44.0;
            break;
    }
    return height;
}

- (void)dealloc{
    [_arrayRevExpAnalysis release];
    [_settingSection release];
    [_chartSection release];
    [_listSection release];
    [super dealloc];
}
@end
