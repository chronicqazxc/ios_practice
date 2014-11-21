//
//  ExpandContractController.m
//  ExpandContractTable
//
//  Created by Wayne on 11/21/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ExpandContractController.h"

#define ParentIndexKey @"ParentIndex"
#define SelfIndexkey @"SelfIndex"
#define TitleKey @"Title"
#define ExpandableKey @"Expandable"
#define IsExpandKey @"IsExpand"
#define CountOfChildrenKey @"CountOfChildren"
#define SelfHeightKey @"SelfHeight"
#define LevelTwoKey @"Level2"

@interface ExpandContractController()
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) NSMutableArray *controlArr;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSDictionary *dataStructureDic;
@end

@implementation ExpandContractController
- (id)initWithDelegate:(id)delegate tableView:(UITableView *)tableView {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.tableView = tableView;
        self.dataArr = [NSMutableArray array];
        self.controlArr = [NSMutableArray array];
    }
    return self;
}

- (NSMutableArray *)setNumberOfSection:(int)number dataArray:(NSMutableArray *)dataArr{
    for (int i=0; i<number; i++) {
        [dataArr addObject:[NSMutableArray array]];
        [self.dataArr addObject:[NSMutableArray array]];
    }
    self.controlArr = [dataArr mutableCopy];
    NSMutableArray *returnArr = [dataArr mutableCopy];
    return returnArr;
}

- (NSMutableArray *)setNumberOfParent:(int)number andHeigh:(NSString *)heigh section:(int)section dataArray:(NSMutableArray *)dataArr {
    for (int i=0; i<number; i++) {
        [dataArr[section] addObject:[NSMutableDictionary dictionary]];
        dataArr = [self generateDataInSection:section row:i heigh:heigh dataArray:dataArr];
        
        [self.dataArr[section] addObject:[NSMutableDictionary dictionary]];
        self.dataArr = [self generateDataInSection:section row:i heigh:heigh dataArray:self.dataArr];
    }
    self.controlArr = [dataArr mutableCopy];
    NSMutableArray *returnArr = [dataArr mutableCopy];
    return returnArr;
}

- (NSMutableArray *)setNumberOfChild:(NSString *)number andHeigh:(NSString *)heigh section:(int)section withParentIndex:(int)parentIndex dataArray:(NSMutableArray *)dataArr{
    
    NSMutableDictionary *contentDic = dataArr[section][parentIndex];
    NSMutableDictionary *contentDic2 = self.dataArr[section][parentIndex];
    
    [contentDic setObject:number forKey:CountOfChildrenKey];
    [contentDic2 setObject:number forKey:CountOfChildrenKey];
    
    NSMutableArray *levelTwoArray = [NSMutableArray array];
    NSMutableArray *levelTwoArray2 = [NSMutableArray array];
    
    for (int i=0; i<[number intValue]; i++) {
        NSMutableDictionary *childDic = [self addChildenDataInParent:parentIndex row:i heigh:heigh];
        NSMutableDictionary *childDic2 = [self addChildenDataInParent:parentIndex row:i heigh:heigh];
        
        [levelTwoArray addObject:childDic];
        [levelTwoArray2 addObject:childDic2];
    }
    [contentDic setObject:levelTwoArray forKey:LevelTwoKey];
    [contentDic2 setObject:levelTwoArray forKey:LevelTwoKey];
    
    self.controlArr = [dataArr mutableCopy];
    NSMutableArray *returnArr = [dataArr mutableCopy];
    return returnArr;
}

- (NSMutableArray *)generateDataInSection:(int)section row:(int)row heigh:(NSString *)heigh dataArray:(NSMutableArray *)controlArr{
    NSMutableDictionary *contentDic = controlArr[section][row];
    [contentDic setObject:@"-1" forKey:ParentIndexKey];
    [contentDic setObject:[NSString stringWithFormat:@"%d",row] forKey:SelfIndexkey];
    [contentDic setObject:@"LevelOne" forKey:TitleKey];
    [contentDic setObject:@"1" forKey:ExpandableKey];
    [contentDic setObject:@"0" forKey:IsExpandKey];
    [contentDic setObject:heigh forKey:SelfHeightKey];
    return controlArr;
}

- (NSMutableDictionary *)addChildenDataInParent:(int)parentIndex row:(int)row heigh:(NSString *)heigh{
    NSMutableDictionary *levelTwoDic = [NSMutableDictionary dictionary];
    [levelTwoDic setObject:[NSString stringWithFormat:@"%d",parentIndex] forKey:ParentIndexKey];
    [levelTwoDic setObject:[NSString stringWithFormat:@"%d",row] forKey:SelfIndexkey];
    [levelTwoDic setObject:@"LevelTwo" forKey:TitleKey];
    [levelTwoDic setObject:@"0" forKey:ExpandableKey];
    [levelTwoDic setObject:@"0" forKey:IsExpandKey];
    [levelTwoDic setObject:@"0" forKey:CountOfChildrenKey];
    [levelTwoDic setObject:heigh forKey:SelfHeightKey];
    return levelTwoDic;
}

//- (void)appendData {
//    int totalCount = [[self.dataArr objectAtIndex:1] count];
//    for (int i = 0; i < [self.dataArr count]; i++) {
//        [self.controlArr addObject:[NSMutableDictionary dictionary]];
//        [self.controlArr[i] setObject:@"-1" forKey:ParentIndexKey];
//        [self.controlArr[i] setObject:[NSString stringWithFormat:@"%d",i+totalCount] forKey:SelfIndexkey];
//        [self.controlArr[i] setObject:@"LevelOne" forKey:TitleKey];
//        [self.controlArr[i] setObject:@"1" forKey:ExpandableKey];
//        [self.controlArr[i] setObject:@"0" forKey:IsExpandKey];
//        NSString *numberOfChild = [[self.dataArr objectAtIndex:i] objectForKey:CountOfChildrenKey];
//        [self.controlArr[i] setObject:numberOfChild forKey:CountOfChildrenKey];
//        NSMutableArray *levelTwoArray = [NSMutableArray array];
//        for (int j = 0; j < [numberOfChild integerValue]; j++) {
//            NSMutableDictionary *levelTwoDic = [NSMutableDictionary dictionary];
//            [levelTwoDic setObject:[NSString stringWithFormat:@"%d",i+totalCount] forKey:ParentIndexKey];
//            [levelTwoDic setObject:[NSString stringWithFormat:@"%d",j] forKey:SelfIndexkey];
//            [levelTwoDic setObject:@"LevelTwo" forKey:TitleKey];
//            [levelTwoDic setObject:@"0" forKey:ExpandableKey];
//            [levelTwoDic setObject:@"0" forKey:IsExpandKey];
//            [levelTwoDic setObject:@"0" forKey:CountOfChildrenKey];
//            [levelTwoDic setObject:@"110.0" forKey:SelfHeightKey];
//            [levelTwoArray addObject:levelTwoDic];
//        }
//        [self.controlArr[i] setObject:@"88.0" forKey:SelfHeightKey];
//        [self.controlArr[i] setObject:levelTwoArray forKey:LevelTwoKey];
//    }
//}

- (int)getSelfIndexFrom:(NSArray *)controlArr indexPath:(NSIndexPath *)indexPath {
    int selfIndex = [[controlArr[indexPath.section][indexPath.row] objectForKey:SelfIndexkey] intValue];
    return selfIndex;
}

- (int)getParentIndexFrom:(NSArray *)controlArr indexPath:(NSIndexPath *)indexPath {
    int parentIndex = [[controlArr[indexPath.section][indexPath.row] objectForKey:ParentIndexKey] intValue];
    return parentIndex;
}

- (BOOL)isExpandFor:(NSArray *)controlArr indexPath:(NSIndexPath *)indexPath {
    return [[controlArr[indexPath.section][indexPath.row] objectForKey:IsExpandKey] intValue]?YES:NO;
}

- (void)expandOrContractCellByIndexPaht:(NSIndexPath *)indexPath dataArray:(NSMutableArray *)controlArr tableView:(UITableView *)tableView {
    int parentIndex = [self getParentIndexFrom:controlArr indexPath:indexPath];
    if ( parentIndex == -1) {
        BOOL isExpand = [self isExpandFor:controlArr indexPath:indexPath];
        if (isExpand) {
            [self contractCellWithIndexPath:indexPath dataArray:controlArr tableView:tableView];
        } else {
            [self expandCellWithIndexPath:indexPath dataArray:controlArr tableView:tableView];
        }
    }
}

- (void)expandCellWithIndexPath:(NSIndexPath *)indexPath dataArray:(NSMutableArray *)controlArr tableView:(UITableView *)tableView{
    [tableView beginUpdates];
    int selfIndex = [self getSelfIndexFrom:controlArr indexPath:indexPath];
    int numberForInsert = [[self.dataArr[indexPath.section][selfIndex] objectForKey:CountOfChildrenKey] intValue];
    NSMutableArray *indexPathArray = [NSMutableArray array];
    for (int i = 1; i <= numberForInsert; i++) {
        NSIndexPath *indexPathForInsert = [NSIndexPath indexPathForRow:indexPath.row+i inSection:indexPath.section];
        [indexPathArray addObject:indexPathForInsert];
    }
    
    NSArray *children = [self.dataArr[indexPath.section][selfIndex] objectForKey:LevelTwoKey];
    for (int i = 1; i <= [children count]; i++) {
        [controlArr[indexPath.section] insertObject:children[i-1] atIndex:indexPath.row+1];
    }
    
    [tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationMiddle];
    [controlArr[indexPath.section][indexPath.row] setObject:@"1" forKey:IsExpandKey];
    
    [tableView endUpdates];
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+numberForInsert inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

- (void)contractCellWithIndexPath:(NSIndexPath *)indexPath dataArray:(NSMutableArray *)controlArr tableView:(UITableView *)tableView {
    [tableView beginUpdates];
    int selfIndex = [self getSelfIndexFrom:controlArr indexPath:indexPath];
    int numberForRemove = [[self.dataArr[indexPath.section][selfIndex] objectForKey:CountOfChildrenKey] intValue];
    NSMutableArray *indexPathArray = [NSMutableArray array];
    for (int i = 1; i <= numberForRemove; i++) {
        NSIndexPath *indexPathForRemove = [NSIndexPath indexPathForRow:indexPath.row+i inSection:indexPath.section];
        [indexPathArray addObject:indexPathForRemove];
    }
    
    NSIndexSet *indexSetForRemove = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row+1, numberForRemove)];
    [controlArr[indexPath.section] removeObjectsAtIndexes:indexSetForRemove];

    [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationMiddle];
    [controlArr[indexPath.section][indexPath.row] setObject:@"0" forKey:IsExpandKey];
    [tableView endUpdates];
}
@end
