//
//  ViewController.m
//  OpenExternalAppDemo
//
//  Created by Wayne on 1/12/15.
//  Copyright (c) 2015 Wayne. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIDocumentInteractionControllerDelegate>

- (IBAction)openActivityView:(UIButton *)sender;
- (IBAction)openDocumentInteractionView:(UIButton *)sender;
@property (strong, nonatomic) UIDocumentInteractionController *documentInteractionController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
 
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


#pragma mark - UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    
    return self;
}

- (IBAction)openActivityView:(UIButton *)sender {

    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"pdf"];
    NSArray *activityItems = @[URL];
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
//    activityViewController.popoverPresentationController.barButtonItem = sender;
    [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}

- (IBAction)openDocumentInteractionView:(UIButton *)sender {
    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"pdf"];
    if (URL) {
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URL];
        self.documentInteractionController.delegate = self;
        self.documentInteractionController.UTI = @"com.adobe.pdf";
        [self.documentInteractionController presentOptionsMenuFromRect:sender.frame inView:self.view animated:YES];
        }
}
@end
