//
//  ViewController.h
//  PlayIPodDemo
//
//  Created by Wayne on 2/1/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController : UIViewController <MPMediaPickerControllerDelegate>
- (IBAction)clickOpen:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *test;
- (IBAction)clickNowPlaying:(UIButton *)sender;

@end
