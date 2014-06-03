//
//  ViewController.h
//  ShortyURL
//
//  Created by Wayne on 4/25/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIWebViewDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate>
- (IBAction)clipboardURL:(UIBarButtonItem *)sender;

- (IBAction)loadLocation:(UIBarButtonItem *)sender;
- (IBAction)shortenURL:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *clipboardURL;
@property (weak, nonatomic) IBOutlet UITextField *urlField;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shortenButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shortLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *clipboardButton;
@end
