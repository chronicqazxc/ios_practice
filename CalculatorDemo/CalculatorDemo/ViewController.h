//
//  ViewController.h
//  CalculatorDemo
//
//  Created by Wayne on 1/27/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *display;

-(void) processDigit: (int) digit;
-(void) processOp: (char) theOp;
-(void) storeFracPart;

//Numeric keys
-(IBAction) clickDigit: (UIButton *) sender;
@property (strong, nonatomic) IBOutlet UIButton *button0;
@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;
@property (strong, nonatomic) IBOutlet UIButton *button3;
@property (strong, nonatomic) IBOutlet UIButton *button4;
@property (strong, nonatomic) IBOutlet UIButton *button5;
@property (strong, nonatomic) IBOutlet UIButton *button6;
@property (strong, nonatomic) IBOutlet UIButton *button7;
@property (strong, nonatomic) IBOutlet UIButton *button8;
@property (strong, nonatomic) IBOutlet UIButton *button9;
@property (strong, nonatomic) IBOutlet UIButton *button10;
@property (strong, nonatomic) IBOutlet UIButton *button11;
@property (strong, nonatomic) IBOutlet UIButton *button12;
@property (strong, nonatomic) IBOutlet UIButton *button13;
@property (strong, nonatomic) IBOutlet UIButton *button14;
@property (strong, nonatomic) IBOutlet UIButton *button15;
@property (strong, nonatomic) IBOutlet UIButton *button16;

//Arithmetic Operation keys
-(IBAction) clickPlus;
-(IBAction) clickMinus;
-(IBAction) clickMultiply;
-(IBAction) clickDivide;

//Misc. keys
-(IBAction) clickOver;
-(IBAction) clickEquals;
-(IBAction) clickClear;

// Add these AVAudioPlayer objects
-(AVAudioPlayer *)setupAudioPlayerWithFile: (NSString *) file ofType: (NSString *) type;
-(void) beepPlay;
@end
