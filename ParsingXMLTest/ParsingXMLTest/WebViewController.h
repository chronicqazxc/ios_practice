//
//  WebViewController.h
//  ParsingXMLTest
//
//  Created by Wayne on 4/7/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (strong, nonatomic) NSString *link;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
