//
//  ExpandContractProcessor.h
//  IncomeExpendAnalyze
//
//  Created by Wayne on 6/3/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ExpandContractProcessorDelegate;

@interface ExpandContractProcessor : NSObject
@property (retain, nonatomic) NSMutableArray *typeMaintainArray;
@property (retain, nonatomic) NSMutableDictionary *listAndSublistDic;
@property (retain, nonatomic) NSMutableArray *expandContractArray;
@property (nonatomic, readonly) int listSection;
@property (retain, nonatomic) id <ExpandContractProcessorDelegate> delegate;
@property (retain, nonatomic) NSArray *data;
- (id)initWithListSection:(int)section AndTypeCount:(int)count;
- (void)insertDatas:(int)dataCount From:(int)startPoint InSection:(NSInteger)section;
- (void)deleteDatas:(int)dataCount From:(int)startPoint InSection:(NSInteger)section;
@end

@protocol ExpandContractProcessorDelegate <NSObject>

@end
