//
//  ViewController.h
//  LazyLoadingTest
//
//  Created by Wayne on 4/7/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloader.h"

@interface ViewController : UITableViewController <IconDownloderDelegate>

@property (strong, nonatomic) NSMutableArray *datas;

@end
