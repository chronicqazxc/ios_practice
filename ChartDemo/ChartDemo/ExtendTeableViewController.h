//
//  ExtendTeableViewController.h
//  ChartDemo
//
//  Created by Wayne on 5/21/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RATreeView.h"

@interface ExtendTeableViewController : UIViewController <RATreeViewDelegate, RATreeViewDataSource>

@property (weak, nonatomic) IBOutlet RATreeView *treeView;

@end
