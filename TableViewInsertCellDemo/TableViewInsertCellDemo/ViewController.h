//
//  ViewController.h
//  TableViewInsertCellDemo
//
//  Created by Wayne on 5/27/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeAnalysisChart.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end
