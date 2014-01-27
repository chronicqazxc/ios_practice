//
//  ViewController.h
//  AudioRecorderDemo
//
//  Created by Wayne on 1/27/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *labelTime;
- (IBAction)clickSegment:(UISegmentedControl *)sender;
- (IBAction)holdButton:(UIButton *)sender;
- (IBAction)releaseButton:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *button;
- (IBAction)changeVolume:(UISlider *)sender;

@end
