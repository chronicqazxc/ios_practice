//
//  MyAssetTableViewController.h
//  MyAssetDemo
//
//  Created by Wayne on 4/13/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"
#import "AddConsumeTableViewController.h"


@interface MyAssetTableViewController : UITableViewController <AddConsumeTableViewControllerDelegated>

@property (strong, nonatomic) Account *account;

- (IBAction)clickLogout:(UIBarButtonItem *)sender;

@end