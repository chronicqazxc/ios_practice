//
//  ViewController.m
//  AccelerationTest
//
//  Created by Wayne on 2/6/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    CMMotionManager *motionManager;
    NSTimer *timer;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    motionManager = [[CMMotionManager alloc]init];
    motionManager.deviceMotionUpdateInterval = 1.0f/60.0f;
    NSOperationQueue *acceleremeterQueue = [[NSOperationQueue alloc]init];
    NSOperationQueue *gyroQueue = [[NSOperationQueue alloc]init];
    NSOperationQueue *deviceMotionQueue = [[NSOperationQueue alloc]init];

    [motionManager startAccelerometerUpdatesToQueue:acceleremeterQueue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _accelerometerX.progress = (accelerometerData.acceleration.x+1)/2;
            _accelerometerY.progress = (accelerometerData.acceleration.y+1)/2;
            _accelerometerZ.progress = (accelerometerData.acceleration.z+1)/2;
        });
    }];
    
    [motionManager startGyroUpdatesToQueue:gyroQueue withHandler:^(CMGyroData *gyroData, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _gyroX.progress = (gyroData.rotationRate.x+1)/2;
            _gyroY.progress = (gyroData.rotationRate.y+1)/2;
            _gyroZ.progress = (gyroData.rotationRate.z+1)/2;
        });
    }];
    
    [motionManager startDeviceMotionUpdatesToQueue:deviceMotionQueue withHandler:^(CMDeviceMotion *motion, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _motionPitch.text = [NSString stringWithFormat:@"%2.0f",motion.attitude.pitch*180/M_PI];
            _motionRoll.text = [NSString stringWithFormat:@"%2.0f",motion.attitude.roll*180/M_PI];
            _motionYaw.text = [NSString stringWithFormat:@"%2.0f",motion.attitude.yaw*180/M_PI];
        });
    }];
}

- (void)viewDidDisappear:(BOOL)animated{
    [motionManager stopAccelerometerUpdates];
    [motionManager stopGyroUpdates];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
