//
//  GetImageViewController.h
//  AccessImageWithDBTest
//
//  Created by Wayne on 2/7/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetImageViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *inputField;
@property (strong, nonatomic) IBOutlet UITextField *imageURL;
- (IBAction)clickAdd:(UIButton *)sender;
- (IBAction)clickSearch:(UIButton *)sender;

@end
