//
//  MyCollectionViewLayout.h
//  UICelloctionTableViewDemo
//
//  Created by Wayne on 12/24/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

#define degToRad(x) (x * M_PI / 180.0f)

@interface MyCollectionViewLayout : UICollectionViewFlowLayout

-(float)calRotateDegree:(float)x;
@end
