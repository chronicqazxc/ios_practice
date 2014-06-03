//
//  AnalysisTypeTableView.m
//  IncomeExpendAnalyze
//
//  Created by Wayne on 5/29/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "AnalysisTypeTableView.h"
#import "AnalysisTypeSettingTableViewCell.h"
#import "AnalysisTypeChartTableViewCell.h"
#import "AnalysisTypeListTableViewCell.h"
#import "AnalysisTypeListTableViewSubCell.h"
#import "XibGetter.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

int valueForTest = 125;

@interface AnalysisTypeTableView()
@property (retain, nonatomic) NSMutableArray *filterData;
@property (retain, nonatomic) NSMutableArray *chartData;
@property (retain, nonatomic) NSMutableArray *typeData;
@property (retain, nonatomic) FilterAndChartSection *settingSection;
@property (retain, nonatomic) FilterAndChartSection *chartSection;
@property (retain, nonatomic) FilterAndChartSection *listSection;
@property (retain, nonatomic) AnalysisTypeSettingTableViewCell *settingCell;
@property (retain, nonatomic) AnalysisTypeChartTableViewCell *chartCell;
@property (retain, nonatomic) AnalysisTypeListTableViewCell *typeCell;
@property (retain, nonatomic) AnalysisTypeListTableViewSubCell *listSubCell;
@property (retain, nonatomic) ExpandContractProcessor *expandContractProcessor;
@end
@implementation AnalysisTypeTableView

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

- (void)sendRexExpImportMod{
    
}

- (void)showDateSettingView{
    
}

- (void)showAccountPicker{
    
}

- (void)drawPieChart{
    
}

- (void)gotoDetail{
    
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
    static NSString *settingCellIdentifier = @"AnalysisTypeSetting";
    static NSString *chartCellIdentifier = @"AnalysisTypeChart";
    id cell = nil;
    NSString *key;
    switch (indexPath.section) {
        case 0:
            self.settingCell = [tableView dequeueReusableCellWithIdentifier:settingCellIdentifier];
            if (!self.settingCell) {
                self.settingCell = [XibGetter getCustomViewByName:@"AnalysisTypeSettingTableViewCell"];
            }
            cell = self.settingCell;
            break;
        case 1:
            self.chartCell = [tableView dequeueReusableCellWithIdentifier:chartCellIdentifier];
            if (!self.chartCell) {
                self.chartCell = [XibGetter getCustomViewByName:@"AnalysisTypeChartTableViewCell"];
            }
            cell = self.chartCell;
            break;
        case 2:
            key = [self.expandContractProcessor.listAndSublistDic objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
            if ([key isEqualToString:@"list"]) {
                self.typeCell = [XibGetter getCustomViewByName:@"AnalysisTypeListTableViewCell"];
                self.typeCell.isExpand = NO;
                self.typeCell.title.text = [NSString stringWithFormat:@"%d",[self.expandContractProcessor.data[indexPath.section][indexPath.row] intValue]];
                if ([self.expandContractProcessor.data[indexPath.section][indexPath.row] intValue]%2 == 0)
                    self.typeCell.backgroundColor = [UIColor grayColor];
                else
                    self.typeCell.backgroundColor = [UIColor darkGrayColor];
                cell = self.typeCell;
            } else if ([key isEqualToString:@"sublist"]) {
                self.listSubCell = [XibGetter getCustomViewByName:@"AnalysisTypeListTableViewSubCell"];
                self.listSubCell.title.text = [NSString stringWithFormat:@"%d",indexPath.row];
                cell = self.listSubCell;
            }
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
                self.listSection = [FilterAndChartSection generateSectionWithTitle:@"支出類型" InSection:section];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[AnalysisTypeListTableViewCell class]]) {
        if ([self.expandContractProcessor.expandContractArray[indexPath.row] boolValue] == YES) {
            [self.expandContractProcessor deleteDatas:valueForTest From:indexPath.row+1 InSection:indexPath.section];
        }
        else {
            [self.expandContractProcessor insertDatas:valueForTest From:indexPath.row+1 InSection:indexPath.section];
        }
    }
}

- (void)dealloc{
    [_arrayRevExpAnalysis release];
    [_arraySelectedMonth release];
    [_settingSection release];
    [_chartSection release];
    [_listSection release];
    [super dealloc];
}
@end
