//
//  DetailViewController.h
//  RSSReaderDemo2
//
//  Created by Wayne on 1/10/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *selectedURL;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

-(void) loadURLString: (NSString *) urlString;
@end
