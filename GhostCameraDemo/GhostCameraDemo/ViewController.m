//
//  ViewController.m
//  GhostCameraDemo
//
//  Created by Wayne on 1/20/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    UIImageView *casper;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Add Observer
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(receivedTakePicture:) name:@"TakePictureNotofy" object:nil];
    
    // Set picture source
    self.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Show custom camera screen
    self.cameraOverlayView = [[CasperView alloc] initWithFrame:self.view.frame];
    self.delegate = self;
    
    // Don't show default camera screen
    self.showsCameraControls = 0;
//    self.wantsFullScreenLayout = 1;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Let propram can support shake motion
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

-(void) viewDidDisappear:(BOOL)animated{
    [self resignFirstResponder];
}

-(BOOL) canBecomeFirstResponder{
    return 1;
}

#pragma mark - motion shake
// Let ghost disappear by shake motion
-(void) motionBegan: (UIEventSubtype)motion withEvent:(UIEvent *)event{
    if(casper != nil && event.type == UIEventSubtypeMotionShake){
        [casper removeFromSuperview];
        casper = nil;
    }
}

#pragma mark - motion move
// If there is no ghost than create one
-(void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event{
    if(casper == nil){
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self.view];
        casper = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"ghost.png"]];
        casper.center = point;
        casper.alpha = 0.3f;
        [self.view addSubview:casper];
    }
}

// Move ghost
-(void) touchesMoved:(NSSet *) touches withEvent:(UIEvent *)event{
    if(casper != nil){
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self.view];
        casper.center = point;
    }
}

#pragma mark - UIImagePickerControllerDelegate
// Save picture ( This section will called after takePicture called
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
//    CGRect rect = self.view.frame;
    // Get picture by user shot
    UIImage *takenPicture = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"takenPicture:width:%.1f,height:%.1f",takenPicture.size.width,takenPicture.size.height);
    NSLog(@"frame:widht:%.1f,height:%.1f",self.view.frame.size.width,self.view.frame.size.height);
    
    
    // Write picture to context
//    UIGraphicsBeginImageContext(self.view.bounds.size); //old
    UIGraphicsBeginImageContext(takenPicture.size);       //new
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0,0,takenPicture.size.width,takenPicture.size.height);
    [takenPicture drawInRect:rect];
    CGContextSaveGState(context);
    CGContextRestoreGState(context);

    // Write ghost to context
//    [casper.image drawInRect:casper.frame blendMode:kCGBlendModeNormal alpha:0.9f];
//    float x = self.view.frame.origin.x / takenPicture.size.width
    [casper.image drawInRect:CGRectMake(casper.frame.origin.x * 7.65,casper.frame.origin.y * 6.8,casper.image.size.width * 7.65,casper.image.size.height * 6.8) blendMode:kCGBlendModeNormal alpha:0.3f];
    CGContextSaveGState(context);
    CGContextRestoreGState(context);

//    // Get sythesize effect
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    // Create spirit effect to indicate the capture was done
    CATransition *transition = [CATransition animation];
    UIImageWriteToSavedPhotosAlbum(viewImage,nil,nil,nil);
    transition.delegate = self;
    transition.duration = 0.5f;
    transition.type = @"suckEffect";
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [[self.view layer] addAnimation:transition forKey:@"suckAnim"];
}

// Receive takePicture's message
-(void) receivedTakePicture:(NSNotification *)notification{
    // shot
    [self takePicture];
}
@end
