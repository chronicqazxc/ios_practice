//
//  CollectionViewLayout.m
//  EndlessScrollDemo
//
//  Created by Wayne on 12/26/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "CollectionViewLayout.h"

@implementation CollectionViewLayout
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
//        self.itemSize = CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
        self.itemSize = CGSizeMake(375, 200);
        NSLog(@"width: %.2f",self.collectionView.superview.bounds.size.width);
//        self.minimumLineSpacing = -50.0f;
//        self.sectionInset = UIEdgeInsetsMake(0, 10, 0, 0);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *returnArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * layoutAttributes, NSUInteger idx, BOOL *stop) {
        layoutAttributes.size = CGSizeMake(self.collectionView.superview.bounds.size.width, 200);
        [returnArray addObject:layoutAttributes];
    }];
    return returnArray;
}
@end
