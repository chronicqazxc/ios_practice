//
//  WebViewController.h
//  AccessImageWithDBTest
//
//  Created by Wayne on 2/8/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)prePage:(UIButton *)sender;
- (IBAction)nextPage:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITextField *urlField;

@end
