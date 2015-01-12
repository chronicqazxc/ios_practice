//
//  ViewController.m
//  OpenExternalAppDemo
//
//  Created by Wayne on 1/12/15.
//  Copyright (c) 2015 Wayne. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIDocumentInteractionControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *sPathPDF = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"test.pdf"]]; //path example for a local stored pdf
    NSURL *urlPDF = [NSURL fileURLWithPath:sPathPDF];
    UIDocumentInteractionController *dicPDF = [UIDocumentInteractionController interactionControllerWithURL: urlPDF];
    [dicPDF setDelegate:self];
//    [dicPDF presentPreviewAnimated: YES];
//    dicPDF.UTI = @"com.adobe.pdf";
//    [dicPDF presentOpenInMenuFromRect:CGRectMake(0,0,100,100) inView:self.view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




#pragma mark - UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    
    return self;
}

@end
