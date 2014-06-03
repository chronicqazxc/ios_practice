//
//  TallyBookDetailView.m
//  IncomeExpendAnalyze
//
//  Created by Wayne on 5/29/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "TallyBookDetailView.h"
#import "DetailSettingTableViewCell.h"
#import "DetailListTableViewCell.h"
#import "DetailListTableViewSubCell.h"
#import "XibGetter.h"

@interface TallyBookDetailView()
@property (retain, nonatomic) NSArray *data;
@property (retain, nonatomic) NSMutableArray *filterData;
@property (retain, nonatomic) NSMutableArray *listData;
@property (retain, nonatomic) FilterAndChartSection *settingSection;
@property (retain, nonatomic) FilterAndChartSection *listSection;
@property (retain, nonatomic) DetailSettingTableViewCell *settingCell;
@property (retain, nonatomic) DetailListTableViewCell *listCell;
@property (retain, nonatomic) DetailListTableViewSubCell *subListCell;
@property (retain, nonatomic) ExpandContractProcessor *expandContractProcessor;
@end

@implementation TallyBookDetailView

int valueForTest2 = 1;

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
        self.listData = [NSMutableArray arrayWithObjects:[NSDecimalNumber numberWithInt:1], [NSDecimalNumber numberWithInt:2], [NSDecimalNumber numberWithInt:3], nil];
        self.expandContractProcessor = [[ExpandContractProcessor alloc] initWithListSection:1 AndTypeCount:[self.listData count]];
        self.expandContractProcessor.delegate = self;
        self.expandContractProcessor.data = @[self.filterData, self.listData];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
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
            if (!self.listSection) {
                self.listSection = [FilterAndChartSection generateSectionWithTitle:@"支出類型" InSection:section];
                self.listSection.buttonText = @"新增";
            }
            sectionView = self.listSection;
            break;
        default:
            break;
    }
    return sectionView;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.expandContractProcessor.data[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *settingCellIdentifier = @"DetailSettingTableViewCell";
    id cell = nil;
    NSString *key;
    switch (indexPath.section) {
        case 0:
            self.settingCell = [tableView dequeueReusableCellWithIdentifier:settingCellIdentifier];
            if (!self.settingCell) {
                self.settingCell = [XibGetter getCustomViewByName:@"DetailSettingTableViewCell"];
            }
            cell = self.settingCell;
            break;
        case 1:
            key = [self.expandContractProcessor.listAndSublistDic objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
            if ([key isEqualToString:@"list"]) {
                self.listCell = [XibGetter getCustomViewByName:@"DetailListTableViewCell"];
                self.listCell.backgroundColor = [UIColor redColor];
                cell = self.listCell;
            } else if ([key isEqualToString:@"sublist"]) {
                self.subListCell = [XibGetter getCustomViewByName:@"DetailListTableViewSubCell"];
                self.subListCell.backgroundColor = [UIColor blueColor];
                cell = self.subListCell;
            }
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 81.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 44.0;
    switch (indexPath.section) {
        case 0:
            height = 269.0;
            break;
        case 1:
            height = 44.0;
            break;
    }
    return height;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[DetailListTableViewCell class]]) {
        if ([self.expandContractProcessor.expandContractArray[indexPath.row] boolValue] == YES) {
            [self.expandContractProcessor deleteDatas:1 From:indexPath.row+1 InSection:indexPath.section];
        }
        else {
            [self.expandContractProcessor insertDatas:1 From:indexPath.row+1 InSection:indexPath.section];
        }
    }
}

- (void)dealloc {
    [_data release];
    [_filterData release];
    [_listData release];
    [super dealloc];
}
@end
