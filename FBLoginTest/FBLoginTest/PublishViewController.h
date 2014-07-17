//
//  PublishViewController.h
//  FBLoginTest
//
//  Created by Wayne on 4/18/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WayneFBShareDialog.h"

@interface PublishViewController : UIViewController <WayneFBShareDialogDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (IBAction)clickAPICall:(UIButton *)sender;
- (IBAction)clickUpdateByAPI:(UIButton *)sender;


- (IBAction)clickShare:(UIButton *)sender;


- (IBAction)clickUpdate:(UIButton *)sender;
- (IBAction)clickSharingPhoto:(UIButton *)sender;

@end
