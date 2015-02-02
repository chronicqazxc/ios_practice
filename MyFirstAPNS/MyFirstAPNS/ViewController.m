//
//  ViewController.m
//  MyFirstAPNS
//
//  Created by Wayne on 1/27/15.
//  Copyright (c) 2015 Wayne. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

#define kURL @"https://agile-sierra-1740.herokuapp.com/manage/test"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.viewController = self;
    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kURL]];

    NSURL *url = [NSURL URLWithString:kURL];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"POST"];
    
    NSDictionary *params = [NSDictionary                        dictionaryWithObjectsAndKeys:@"23tnq5W4r8SGGrukqMXnFsTW5SOmobzMrOoBgwJcmvg",@"authenticity_token",
                             @"manage",@"class",
                             @"manage",@"controller",
                             @"test",@"action",
                             nil];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    [req setHTTPBody:jsonData];
//    NSHTTPURLResponse *response;

//    [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
//    if (error == nil && response.statusCode == 200) {
//        NSLog(@"%@",response);
//    } else {
//        NSLog(@"%@",[error description]);
//    }
    [NSURLConnection sendAsynchronousRequest:req queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (error == nil) {
            NSError *localError = nil;
            NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
            NSLog(@"%@",parsedObject);
        } else {
            NSLog(@"%@",[error description]);
        }
        
    }];
    
    [self.webView loadRequest:req];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showNotify {
    NSLog(@"%@",self.notifyString);
    [[[UIAlertView alloc] initWithTitle:@"" message:self.notifyString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}
@end
