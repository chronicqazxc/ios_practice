//
//  WebViewController.m
//  AccessImageWithDBTest
//
//  Created by Wayne on 2/8/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _webView.delegate = self;
    NSURL *url = [NSURL URLWithString:@"http://m.bing.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)prePage:(UIButton *)sender {
    [_webView goBack];
}

- (IBAction)nextPage:(UIButton *)sender {
    [_webView goForward];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    _urlField.text = webView.request.URL.absoluteString;
//    NSLog(@"aa:%@",webView.request.URL.absoluteString);
}
@end
