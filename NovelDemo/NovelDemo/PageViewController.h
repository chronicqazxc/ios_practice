//
//  PageViewController.h
//  NovelDemo2
//
//  Created by Wayne on 1/15/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"
#import "ModelController.h"

@interface PageViewController : UIPageViewController <UIPageViewControllerDelegate>

@property (nonatomic) int startPage;
@end
