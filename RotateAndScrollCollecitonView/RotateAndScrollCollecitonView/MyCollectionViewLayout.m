//
//  MyCollectionViewLayout.m
//  UICelloctionTableViewDemo
//
//  Created by Wayne on 12/24/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "MyCollectionViewLayout.h"

@interface MyCollectionViewLayout()
@property (nonatomic) __block float angle;
@property (nonatomic) __block float xPanOffset;
@property (nonatomic, weak) UIView * superView;
@end

@implementation MyCollectionViewLayout

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.itemSize = CGSizeMake(130.0f, 200.0f);
//        self.minimumLineSpacing = -50.0f;
        self.sectionInset = UIEdgeInsetsMake(0, 10, 0, 0);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.angle = 0.0f;
        self.xPanOffset = 0.0f;
    }
    return self;
}

- (void)prepareLayout {
    self.superView = self.collectionView.superview;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    /* rotate      translate
         x              y
         |              |
     ____y____z     ____z____x
         |              |
         |              |
     */
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *attributedArr = [NSMutableArray array];
    
    __block float degForPlane = 0;
    __block float deg = 0;
    if ([array count])
        degForPlane = 360 / [array count];
    degForPlane = 45;
    self.xPanOffset = 0;
//    CGFloat horizontalCenter = (CGRectGetWidth(self.collectionView.bounds) / 2.0f);
    
    [array enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * layoutAttributes, NSUInteger idx, BOOL *stop) {
        
        CGPoint pointInCollectionView = layoutAttributes.frame.origin;
        CGPoint pointInMainView = [self.collectionView.superview convertPoint:pointInCollectionView fromView:self.collectionView];
        
        CGPoint centerInCollectionView = layoutAttributes.center;
        CGPoint centerInMainView = [self.collectionView.superview convertPoint:centerInCollectionView fromView:self.collectionView];
        
        float rotateBy = 0.0f;
        if (pointInMainView.x < self.collectionView.frame.size.width+80.0f){
            rotateBy = [self calRotateDegree:pointInMainView.x];

            
            CGPoint rotationPoint = CGPointMake(self.collectionView.frame.size.width/2, self.collectionView.frame.size.height);
            
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = 1.0f / -1000.0f;
            transform = CATransform3DTranslate(transform, rotationPoint.x - centerInMainView.x, 0.0,  0.0);
            transform = CATransform3DRotate(transform, degToRad(rotateBy), 0.0, 0.0, 1.0);
            deg += degForPlane;
            transform = CATransform3DTranslate(transform, centerInMainView.x - rotationPoint.x, -5.0, 0.0);
            layoutAttributes.transform3D = transform;
            
            // right card is always on top
            layoutAttributes.zIndex = layoutAttributes.indexPath.item;
            [attributedArr addObject:layoutAttributes];
        }
    }];
    return attributedArr;
}

-(float)calRotateDegree:(float)x{
    float rotateByDegrees = [self changeScaleFromInputLow:-122 inputHigh:360 outputLow:-35 outputHigh:35 inputNumber:x];
    return rotateByDegrees;
}

/*
 How to convert a number from one min\max set to another min\max set?
 http://gamedev.stackexchange.com/questions/33441/how-to-convert-a-number-from-one-min-max-set-to-another-min-max-set
Result := ((Input - InputLow) / (InputHigh - InputLow)) * (OutputHigh - OutputLow) + OutputLow
 */
- (float)changeScaleFromInputLow:(float)inputLow inputHigh:(float)inputHight outputLow:(float)outputLow outputHigh:(float)outputHigh inputNumber:(float)inputNumber {
    //fromMin: -122, fromMax: 258, toMin: -35, toMax: 35
    
    return (inputNumber - inputLow) / (inputHight - inputLow) * (outputHigh - outputLow) + outputLow;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}
@end
