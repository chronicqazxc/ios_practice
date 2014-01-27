//
//  ViewController.m
//  AudioRecorderDemo
//
//  Created by Wayne on 1/27/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Launch session
    [[AVAudioSession sharedInstance] setActive:1 error:nil];
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Initialize AVAudioRecorder
    [self audioRecorder];
    
    _button.layer.cornerRadius = 65;
    _button.backgroundColor = [UIColor redColor];
    
    _labelTime.text = @"Stand by";
    
    player.delegate = self;
}

-(void) audioRecorder{
    NSString *filename = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
                          stringByAppendingPathComponent:@"record.caf"];
    NSURL *url = [NSURL URLWithString:filename];
    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat:4100.0],AVSampleRateKey,
                              [NSNumber numberWithInt:kAudioFormatAppleLossless],AVFormatIDKey,
                              [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,nil];
    
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:nil];
    recorder.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickSegment:(UISegmentedControl *)sender {
    if(sender.selectedSegmentIndex == 0){
        _labelTime.text = @"Stand by";
        _button.enabled = 1;
        [player pause];
    }else if(sender.selectedSegmentIndex == 1){
        _labelTime.text = @"Playing...";
        _button.enabled = 0;
        NSString *filename = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
                              stringByAppendingPathComponent:@"record.caf"];
        NSURL *url = [NSURL URLWithString:filename];
        player = nil;
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [player prepareToPlay];
        [player play];
    }
}

- (IBAction)holdButton:(UIButton *)sender {
    sender.backgroundColor = [UIColor darkGrayColor];
    _labelTime.text = @"Recoring...";
    [recorder prepareToRecord];
    [recorder record];
}

- (IBAction)releaseButton:(UIButton *)sender {
    _labelTime.text = @"Stand by";
    sender.backgroundColor = [UIColor redColor];
    [recorder stop];
}

#pragma mark - AVAudioRecorderDelegate
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    [[AVAudioSession sharedInstance] setActive:0 error:nil];
}
- (IBAction)changeVolume:(UISlider *)sender {
    if(player != nil)
        player.volume = sender.value;
}

-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if(flag == 0){
        _labelTime.text = @"Stand by";
    }
}
@end
