//
//  OpenGraphStoriesViewController.h
//  FBLoginTest
//
//  Created by Wayne on 4/18/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionSheet.h"

@interface OpenGraphStoriesViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, AcitonSheetDelegate>

- (IBAction)clickAPICall:(UIButton *)sender;
- (IBAction)clickShareDialog:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *waitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end
