//
//  ViewController.m
//  ScanQRCodeDemo
//
//  Created by Wayne on 12/7/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ViewController.h"
#import <ZXingObjC/ZXingObjC.h>

@interface ViewController () <ZXCaptureDelegate>
@property (strong, nonatomic) ZXCapture *capture;
@property (weak, nonatomic) IBOutlet UIView *scanRectView;
@property (weak, nonatomic) IBOutlet UILabel *decodedLabel;
@property (nonatomic) int count;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.capture = [[ZXCapture alloc] init];
    self.capture.camera = self.capture.back;
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    self.capture.rotation = 90.0f;
    self.capture.layer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.capture.layer];
    
    [self.view bringSubviewToFront:self.scanRectView];
    [self.view bringSubviewToFront:self.decodedLabel];
    
    self.count = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.capture.delegate = self;
    self.capture.layer.frame = self.view.bounds;
    
    CGAffineTransform captureSizeTransform = CGAffineTransformMakeScale(320 / self.view.frame.size.width, 480 / self.view.frame.size.height);
    self.capture.scanRect = CGRectApplyAffineTransform(self.scanRectView.frame, captureSizeTransform);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (NSString *)barcodeFormatToString:(ZXBarcodeFormat)format {
    switch (format) {
        case kBarcodeFormatAztec:
            return @"Aztec";
            
        case kBarcodeFormatCodabar:
            return @"CODABAR";
            
        case kBarcodeFormatCode39:
            return @"Code 39";
            
        case kBarcodeFormatCode93:
            return @"Code 93";
            
        case kBarcodeFormatCode128:
            return @"Code 128";
            
        case kBarcodeFormatDataMatrix:
            return @"Data Matrix";
            
        case kBarcodeFormatEan8:
            return @"EAN-8";
            
        case kBarcodeFormatEan13:
            return @"EAN-13";
            
        case kBarcodeFormatITF:
            return @"ITF";
            
        case kBarcodeFormatPDF417:
            return @"PDF417";
            
        case kBarcodeFormatQRCode:
            return @"QR Code";
            
        case kBarcodeFormatRSS14:
            return @"RSS 14";
            
        case kBarcodeFormatRSSExpanded:
            return @"RSS Expanded";
            
        case kBarcodeFormatUPCA:
            return @"UPCA";
            
        case kBarcodeFormatUPCE:
            return @"UPCE";
            
        case kBarcodeFormatUPCEANExtension:
            return @"UPC/EAN extension";
            
        default:
            return @"Unknown";
    }
}

//- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
//!@#
- (void)captureResult:(ZXCapture *)capture result:(NSArray *)result {
    if ([result count] == 0) return;
    self.count++;
    // We got a result. Display information about the result onscreen.
    if ([result count] > 1) {
        if ([[[result firstObject] text] isEqualToString:[[result lastObject] text]]) {
            return;
        } else {
            NSString *formatString = [self barcodeFormatToString:[[result firstObject] barcodeFormat]];
            NSString *formatString2 = [self barcodeFormatToString:[[result lastObject] barcodeFormat]];
            NSString *display = [NSString stringWithFormat:@"\n\n\nScanned!\n\nFormat: %@\n\nContents:\n%@ \n\nFormat: %@\n\nContents:\n%@", formatString, [[result firstObject] text] , formatString2, [[result lastObject] text]];
            [self.decodedLabel performSelectorOnMainThread:@selector(setText:) withObject:display waitUntilDone:YES];
        }
    } else {
        NSLog(@"count < 2");
    }
}
- (IBAction)clickClear:(UIButton *)sender {
    self.decodedLabel.text = @"";
}
- (IBAction)turnLightsOn:(UISwitch *)sender {
    if (sender.on) {
        [self.capture setLuminance:YES];
        self.capture.torch = YES;
    } else {
        [self.capture setLuminance:NO];
        self.capture.torch = NO;
    }
}
@end
