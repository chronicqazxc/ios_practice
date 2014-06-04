//
//  FilterConditionCell.h
//  ExtendTableView
//
//  Created by Wayne on 5/21/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterConditionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *buttonLabel;
@property (weak, nonatomic) IBOutlet UILabel *buttonText;
@end
