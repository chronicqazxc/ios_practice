//
//  ExpandContractProcessor.m
//  IncomeExpendAnalyze
//
//  Created by Wayne on 6/3/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ExpandContractProcessor.h"

@interface ExpandContractProcessor()
- (int)getDigitPlaceOfDecimalNumber:(NSDecimalNumber *)decimalNumber;
@end

@implementation ExpandContractProcessor

- (id)initWithListSection:(int)section AndTypeCount:(int)count{
    self = [super init];
    if (self)
        _listSection = section;
    self.typeMaintainArray = [NSMutableArray array];
    self.expandContractArray = [NSMutableArray array];
    self.listAndSublistDic = [NSMutableDictionary dictionary];
    for (int i=1; i<=count; i++) {
        [self.typeMaintainArray addObject:[NSDecimalNumber numberWithInt:i*10]];
        [self.expandContractArray addObject:[NSDecimalNumber numberWithBool:NO]];
    }
    [self generateDictionaryForTypeAndSublist];

    return self;
}

- (void)generateDictionaryForTypeAndSublist {
    int index = -1;
    if (self.listAndSublistDic)
        [self.listAndSublistDic removeAllObjects];
    for (int i = 0; i < [self.typeMaintainArray count]; i++) {
        index++;
        [self.listAndSublistDic setValue:@"list" forKey:[NSString stringWithFormat:@"%d",index]];
        int contentCondition = [self getDigitPlaceOfDecimalNumber:self.typeMaintainArray[i]];
        for (int j = 0; j < [self.typeMaintainArray[i] intValue]%contentCondition; j++) {
            index++;
            [self.listAndSublistDic setValue:@"sublist" forKey:[NSString stringWithFormat:@"%d",index]];
        }
    }
}

- (int)getDigitPlaceOfDecimalNumber:(NSDecimalNumber *)decimalNumber{
    NSString *valueString = [NSString stringWithFormat:@"%d",[decimalNumber intValue]];
    NSMutableString *contentString = [NSMutableString string];
    for (int i = 1; i <= valueString.length; i++) {
        if (i == 1)
            [contentString appendString:@"1"];
        else
            [contentString appendString:@"0"];
    }
    NSDecimalNumber *number = [[NSDecimalNumber alloc]initWithString:contentString];
    return [number intValue];
}

- (void)deleteDatas:(int)dataCount From:(int)startPoint InSection:(NSInteger)section{
    if (section == self.listSection)
        [self processDeleteContentOfTypeMaintainAndGenerateDictionaryWithDataCount:dataCount From:startPoint InSection:section];
    [(UITableView *)self.delegate beginUpdates];
    NSMutableArray *indexes = [NSMutableArray array];
    for (int i = startPoint; i < startPoint+dataCount; i++) {
        [indexes addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    NSRange range;
    range.location = startPoint;
    range.length = dataCount;
    [self.data[section] removeObjectsInRange:range];
    [(UITableView *)self.delegate deleteRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationMiddle];
    [(UITableView *)self.delegate endUpdates];
    if (section == self.listSection)
        [self refleshExpandContractArrayInIndex:startPoint-1 CountOfData:dataCount WillExpand:NO];
}

- (void)processDeleteContentOfTypeMaintainAndGenerateDictionaryWithDataCount:(int)dataCount From:(int)startPoint InSection:(NSUInteger)section{
    int index = [self.data[section][startPoint-1] intValue];
    int startValue = [self.data[section][startPoint-1] intValue];
    self.typeMaintainArray[index-1] = [NSDecimalNumber numberWithInt:startValue*10];
    [self generateDictionaryForTypeAndSublist];
}

- (void)insertDatas:(int)dataCount From:(int)startPoint InSection:(NSInteger)section{
    if (section == self.listSection) {
        [self processInsertTypeMaintainArrayGenerateDictionaryForTypeAndSublistWithDataCount:dataCount From:startPoint InSeciton:section];
    }
    [(UITableView *)self.delegate beginUpdates];
    NSMutableArray *leadArray = [NSMutableArray array];
    for (int i = 0; i < startPoint; i++) {
        [leadArray addObject:self.data[section][i]];
    }
    NSMutableArray *tailArray = [NSMutableArray array];
    for (int i = startPoint; i < [self.data[section] count]; i++) {
        [tailArray addObject:self.data[section][i]];
    }
    NSMutableArray *indexes = [NSMutableArray array];
    for (NSInteger i = startPoint; i < startPoint+dataCount; i++) {
        [indexes addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        [leadArray addObject:[NSString stringWithFormat:@"sublist:%d",i+1]];
    }
    [self.data[section] removeAllObjects];
    [leadArray addObjectsFromArray:tailArray];
    [self.data[section] addObjectsFromArray:leadArray];
    [(UITableView *)self.delegate insertRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationMiddle];
    [(UITableView *)self.delegate endUpdates];
    if (section == self.listSection)
        [self refleshExpandContractArrayInIndex:startPoint-1 CountOfData:dataCount WillExpand:YES];
}

- (void)processInsertTypeMaintainArrayGenerateDictionaryForTypeAndSublistWithDataCount:(int)dataCount From:(int)startPoint InSeciton:(NSUInteger)section{
    int index = [self.data[section][startPoint-1] intValue];
    int digitPlace = [self getDigitPlaceOfDecimalNumber:(NSDecimalNumber *)[NSDecimalNumber numberWithInt:dataCount]];
    int startValue = [self.data[section][startPoint-1] intValue];
    self.typeMaintainArray[index-1] = [NSDecimalNumber numberWithInt:startValue*digitPlace*10 + dataCount];
    [self generateDictionaryForTypeAndSublist];
}

- (void)refleshExpandContractArrayInIndex:(NSInteger)index CountOfData:(int)count WillExpand:(BOOL)boolValue{
    NSMutableArray *leadArray = [NSMutableArray array];
    NSMutableArray *tailArray = [NSMutableArray array];
    for (int i = 0; i < index; i++) {
        [leadArray addObject:self.expandContractArray[i]];
    }
    NSRange range;
    range.location = index;
    range.length = count;
    if (boolValue == YES) {
        for (int i = 0; i < count; i++) {
            [leadArray addObject:[NSDecimalNumber numberWithBool:NO]];
        }
    } else {
        [self.expandContractArray removeObjectsInRange:range];
    }
    for (int i = index; i < [self.expandContractArray count]; i++) {
        [tailArray addObject:self.expandContractArray[i]];
    }
    [leadArray addObjectsFromArray:tailArray];
    leadArray[index] = [NSNumber numberWithBool:boolValue];
    [self.expandContractArray removeAllObjects];
    [self.expandContractArray addObjectsFromArray:leadArray];
}
@end
