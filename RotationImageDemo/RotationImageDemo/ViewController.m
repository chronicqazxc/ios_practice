//
//  ViewController.m
//  AnimationTest3
//
//  Created by Wayne on 1/29/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    CALayer *imgLayer;
    CALayer *shadowLayer;
    UIImageView *imgView;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"A387.jpg"]];
    
    // Get ratio of image
    float ratio = imgView.image.size.width / imgView.image.size.height;
    
    // Initialize image layer and add image
    imgLayer = [CALayer layer];
    imgLayer.frame = CGRectMake(50,100,200,200 / ratio);
    imgLayer.contents = (id)imgView.image.CGImage;
    
    // Set corner of layer
    imgLayer.cornerRadius = 50.0;
    imgLayer.masksToBounds = 1;
    
    // Set shadow of layer and set shadow color to black
    shadowLayer = [CALayer layer];
    shadowLayer.shadowColor = [UIColor blackColor].CGColor;
    
    // Set shadow 10pixel offset to right down
    shadowLayer.shadowOffset = CGSizeMake(10,10);
    shadowLayer.shadowOpacity = 0.8;
    shadowLayer.shadowRadius = 5.0;
    
    [shadowLayer addSublayer:imgLayer];
//    [imgLayer release];
    [self.view.layer addSublayer:shadowLayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleSlider:(UISlider *)sender {
    float deg = sender.value;
    float rad = deg / 180.0 * M_PI;
    
    // Rotate image
    CGAffineTransform rotation = CGAffineTransformMakeRotation(rad);
    [imgLayer setAffineTransform:rotation];
    
}
@end
