//
//  ViewController.m
//  InteractTouchID
//
//  Created by Wayne on 4/2/15.
//  Copyright (c) 2015 Wayne. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIVisualEffectView *blurView;
- (IBAction)clickRecap:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *images = [NSMutableArray arrayWithObjects:
                   [UIImage imageNamed:@"pic.jpg"],
                   [UIImage imageNamed:@"pic2.jpg"],
                   [UIImage imageNamed:@"pic3.jpg"],
                   [UIImage imageNamed:@"pic4.jpg"],
                   [UIImage imageNamed:@"pic5.jpg"],nil];
    self.imageView.image = [UIImage animatedImageWithImages:images duration:10.0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showAuthentication];
}

- (void)showAuthentication {
    LAContext *context = [[LAContext alloc] init];
    NSError *error = [[NSError alloc] init];
    NSString *reasonString = @"解開TouchID看圖片";
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:reasonString reply:^(BOOL success, NSError *error) {
            if (success) {
                [self performSelectorOnMainThread:@selector(dismissBlurView) withObject:nil waitUntilDone:NO];
            } else {
                NSLog(@"%@",[error localizedDescription]);
                switch (error.code) {
                    case LAErrorSystemCancel:
                        [self performSelectorOnMainThread:@selector(errorAlert:) withObject:@"Authentication was cancelled by the system" waitUntilDone:NO];
                        break;
                    case LAErrorUserCancel:
                        [self performSelectorOnMainThread:@selector(errorAlert:) withObject:@"Authentication was cancelled by the user" waitUntilDone:NO];
                        break;
                    case LAErrorUserFallback:
                        [self performSelectorOnMainThread:@selector(errorAlert:) withObject:@"User selected to enter custom password" waitUntilDone:NO];
                        break;
                    case LAErrorAuthenticationFailed:
                    default:
                        [self performSelectorOnMainThread:@selector(errorAlert:) withObject:@"Authentication failed" waitUntilDone:NO];
                        break;
                }
            }
        }];
    } else {
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
                [self performSelectorOnMainThread:@selector(errorAlert:) withObject:@"TouchID is not enrolled" waitUntilDone:NO];
                break;
            case LAErrorPasscodeNotSet:
                [self performSelectorOnMainThread:@selector(errorAlert:) withObject:@"A passcode has not been set" waitUntilDone:NO];
                break;
            case LAErrorTouchIDNotAvailable:
            default:
                [self performSelectorOnMainThread:@selector(errorAlert:) withObject:@"TouchID not available" waitUntilDone:NO];
                break;
        }
    }
}

- (void)dismissBlurView {
    [UIView animateWithDuration:1.0 animations:^{
        self.blurView.alpha = 0.0;
    }];
}

- (void)errorAlert:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self performSelectorOnMainThread:@selector(clickRecap:) withObject:nil waitUntilDone:NO];
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)authenticateUser {
    
}

- (IBAction)clickRecap:(UIButton *)sender {
    [UIView animateWithDuration:1.0 animations:^{
        self.blurView.alpha = 1.0;
    }];
    [self showAuthentication];
}
@end
