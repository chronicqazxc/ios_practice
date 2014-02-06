//
//  ViewController.h
//  AccelerationTest
//
//  Created by Wayne on 2/6/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIProgressView *accelerometerX;
@property (strong, nonatomic) IBOutlet UIProgressView *accelerometerY;
@property (strong, nonatomic) IBOutlet UIProgressView *accelerometerZ;
@property (strong, nonatomic) IBOutlet UIProgressView *gyroX;
@property (strong, nonatomic) IBOutlet UIProgressView *gyroY;
@property (strong, nonatomic) IBOutlet UIProgressView *gyroZ;
@property (strong, nonatomic) IBOutlet UILabel *motionPitch;
@property (strong, nonatomic) IBOutlet UILabel *motionRoll;
@property (strong, nonatomic) IBOutlet UILabel *motionYaw;


@end
