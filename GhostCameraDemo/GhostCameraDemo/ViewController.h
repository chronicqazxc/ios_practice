//
//  ViewController.h
//  GhostCameraDemo
//
//  Created by Wayne on 1/20/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CasperView.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController : UIImagePickerController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

-(void) receivedTakePicture:(NSNotification *) notification;

@end
