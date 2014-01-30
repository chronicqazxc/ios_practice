//
//  ViewController.h
//  DynamicAnimationTest
//
//  Created by Wayne on 1/29/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface ViewController : UIViewController 
@property (strong, nonatomic) IBOutlet UIView *redAnchor;
@property (strong, nonatomic) IBOutlet UIView *blackHook;
// dynamic behavior item
@property (strong, nonatomic) IBOutlet UIView *attachmentItem;
@property (strong, nonatomic) IBOutlet UIView *gravityItem;
- (IBAction)handlePanGesture:(UIPanGestureRecognizer *)sender;
@property (strong, nonatomic) IBOutlet UIView *snapItem;
- (IBAction)handleTapGesture:(UITapGestureRecognizer *)sender;
@end
