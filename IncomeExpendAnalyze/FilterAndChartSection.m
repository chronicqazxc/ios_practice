//
//  FilterAndChartSection.m
//  ExtendTableView
//
//  Created by Wayne on 5/21/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "FilterAndChartSection.h"
#import "XibGetter.h"

@interface FilterAndChartSection()
@property (nonatomic) BOOL isexpand;
@property (nonatomic) NSInteger section;
@end

@implementation FilterAndChartSection

+ (FilterAndChartSection *)generateSectionWithTitle:(NSString *)title InSection:(NSInteger)section{
    FilterAndChartSection *sectionView = [XibGetter getCustomViewByName:@"FilterAndChartSection"];
    sectionView.titleLabel.text = title;
    sectionView.section = section;
    return sectionView;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    self.layer.borderColor = [UIColor greenColor].CGColor;
    self.layer.borderWidth = 2;
    if (self.buttonText == nil)
        [self.button setTitle:@"展開" forState:UIControlStateNormal];
    else
        [self.button setTitle:self.buttonText forState:UIControlStateNormal];
    self.self.isexpand = NO;
    self.button.tag = self.section;
    [self.button addTarget:self action:@selector(doExpandOrContract) forControlEvents:UIControlEventTouchUpInside];
}
- (void)awakeFromNib
{
    // Initialization code
}


- (BOOL)isExpand{
    return self.isexpand;
}

- (void)doExpandOrContract{
    [self.delegate insertOrDeleteRow:self InSection:self.button.tag];
    if (!self.isexpand) {
        if (self.buttonText == nil)
            [self.button setTitle:@"收合" forState:UIControlStateNormal];
        self.isexpand = YES;
    }
    else {
        if (self.buttonText == nil)
            [self.button setTitle:@"展開" forState:UIControlStateNormal];
        self.isexpand = NO;
    }
}

- (void)dealloc {
    [_button release];
    [_titleLabel release];
    [super dealloc];
}
@end
