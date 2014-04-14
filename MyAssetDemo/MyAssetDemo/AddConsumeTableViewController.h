//
//  AddConsumeTableViewController.h
//  MyAssetDemo
//
//  Created by Wayne on 4/13/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemViewController.h"
#import "PickDateViewController.h"
#import "CostViewController.h"
#import "Account.h"

@protocol AddConsumeTableViewControllerDelegated;

@interface AddConsumeTableViewController : UITableViewController <ItemViewControllerDelegate, PickDateViewControllerDelegate, CostViewControllerDelegate>

@property (strong, nonatomic) id <AddConsumeTableViewControllerDelegated> delegate;
@property (strong, nonatomic) Account *account;

- (IBAction)clickCancel:(UIBarButtonItem *)sender;
- (IBAction)clickSave:(UIBarButtonItem *)sender;

@end

@protocol AddConsumeTableViewControllerDelegated <NSObject>

- (void)reload;

@end
