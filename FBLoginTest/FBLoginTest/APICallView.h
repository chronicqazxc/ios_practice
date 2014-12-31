//
//  APICallView.h
//  FBLoginTest
//
//  Created by Wayne on 7/17/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APICallView : UITableView <UITextViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIView *dialogView;
@property (weak, nonatomic) UIViewController *viewController;
- (IBAction)clickCancel:(UIButton *)sender;
- (IBAction)clickPublish:(UIButton *)sender;
- (void)popupShareDialog;
@end
