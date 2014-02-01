//
//  ViewController.h
//  MP3PlayerDemo
//
//  Created by Wayne on 1/21/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *playStatus;
@property (strong, nonatomic) IBOutlet UIPickerView *songList;
- (IBAction)changeValue:(UISlider *)sender;
- (IBAction)playMP3:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *buttonPlay;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;

@end
