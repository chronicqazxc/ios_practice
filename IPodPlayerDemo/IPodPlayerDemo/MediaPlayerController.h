//
//  MediaPlayerController.h
//  PlayIPodDemo
//
//  Created by Wayne on 2/2/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

//@interface MediaPlayerController : MPMediaPickerController
@interface MediaPlayerController : UIViewController
@property (strong, nonatomic) MPMediaItemCollection *mediaItemColleciton;
@property (strong, nonatomic) MPMediaItem *nowPlayingItem;
@property (strong, nonatomic) IBOutlet UILabel *songLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *artistLabel;
@property (strong, nonatomic) IBOutlet UIImageView *artwork;
- (IBAction)clickNext:(UIButton *)sender;
- (IBAction)clickPreview:(UIButton *)sender;
- (IBAction)clickBack:(UIButton *)sender;
- (IBAction)handleSlider:(UISlider *)sender;
- (IBAction)clickPlayback:(UIButton *)sender;
- (IBAction)clickStop:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIProgressView *progressLabel;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
- (IBAction)touchDownForward:(UIButton *)sender;
- (IBAction)touchDownBackward:(UIButton *)sender;

@end
