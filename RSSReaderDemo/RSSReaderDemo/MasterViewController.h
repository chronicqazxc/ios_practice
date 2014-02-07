//
//  MasterViewController.h
//  RSSReaderDemo2
//
//  Created by Wayne on 1/10/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSReader.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
