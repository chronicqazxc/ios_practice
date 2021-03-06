//
//  ViewController.m
//  FacebookAppDemo
//
//  Created by Wayne on 4/2/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    FBShareDialogParams *params = [[FBShareDialogParams alloc]init];
    params.link = [NSURL URLWithString:@"https://developers.facebook.com/docs/ios/share/"];
    params.name = @"Sharing Tutorial";
    params.caption = @"Build great social apps and get more installs.";
    params.picture = [NSURL URLWithString:@"http://i.imgur.com/g3Qc1HN.png"];
    params.description = @"Allow your user to share stories on Facebook from your app using the iOS SDK";
//    params.ref = @"testtestfortest";
    
    if([FBDialogs canPresentShareDialogWithParams:params]){
        NSLog(@"success");
        
        [FBDialogs presentShareDialogWithParams:params clientState:nil handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
            if(error) {
                // An error occurred, we need to handle the error
                // See: https://developers.facebook.com/docs/ios/errors
                NSLog(@"error");
                self.result.text = @"error";
            } else {
                // Success
                NSLog(@"result %@", results);
                self.result.text = @"success";
            }
        }];
        
//        [FBDialogs presentShareDialogWithLink:params.link
//                                         name:params.name
//                                      caption:params.caption
//                                  description:params.description
//                                      picture:params.picture
//                                  clientState:nil
//                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
//                                          if(error) {
//                                              // An error occurred, we need to handle the error
//                                              // See: https://developers.facebook.com/docs/ios/errors
//                                              NSLog(@"error");
//                                              self.result.text = @"error";
//                                          } else {
//                                              // Success
//                                              NSLog(@"result %@", results);
//                                            self.result.text = @"success";
//                                          }
//                                      }];
    }else{
        NSLog(@"faild");
        self.result.text = @"faild";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickPublish:(UIButton *)sender {
    FBShareDialogParams *params = [[FBShareDialogParams alloc]init];
    params.link = [NSURL URLWithString:@"https://developers.facebook.com/docs/ios/share/"];
    params.name = @"Sharing Tutorial";
    params.caption = @"Build great social apps and get more installs.";
    params.picture = [NSURL URLWithString:@"http://i.imgur.com/g3Qc1HN.png"];
    params.description = @"Allow your user to share stories on Facebook from your app using the iOS SDK";
    //    params.ref = @"testtestfortest";
    
    if([FBDialogs canPresentShareDialogWithParams:params]){
        NSLog(@"success");
        
        [FBDialogs presentShareDialogWithParams:params clientState:nil handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
            if(error) {
                NSLog(@"error");
                self.result.text = @"error";
            } else {
                // Success
                NSLog(@"result %@", results);
                self.result.text = @"success";
            }
        }];
        
    }else{
        NSLog(@"faild");
        self.result.text = @"faild";
    }
}
@end
