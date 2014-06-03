//
//  FilterAndChartSection.h
//  ExtendTableView
//
//  Created by Wayne on 5/21/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterAndChartSectionDelegate;

@interface FilterAndChartSection : UIView
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIButton *button;
@property (retain, nonatomic) NSString *buttonText;
@property (retain, nonatomic) id <FilterAndChartSectionDelegate> delegate;
+ (FilterAndChartSection *)generateSectionWithTitle:(NSString *)title InSection:(NSInteger)section;
- (BOOL)isExpand;
- (void)doExpandOrContract;
@end

@protocol FilterAndChartSectionDelegate <NSObject>
- (void)insertOrDeleteRow:(UIView *)sectionHeader InSection:(NSUInteger)section;
@end

