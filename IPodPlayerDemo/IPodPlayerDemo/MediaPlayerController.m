//
//  MediaPlayerController.m
//  PlayIPodDemo
//
//  Created by Wayne on 2/2/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "MediaPlayerController.h"

@interface MediaPlayerController (){
    MPMusicPlayerController *musicPlayer;
    NSTimer *timer;
    double timeDuration;
    
}
-(void) nowPlayingItemChanged:(NSNotification *)notification;
-(void) initAlbumInfo;
-(void) ticker;
-(void) setButtonImage:(NSString *)imageName;
@end

@implementation MediaPlayerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    [musicPlayer setQueueWithItemCollection:_mediaItemColleciton];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(nowPlayingItemChanged:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:musicPlayer];
    
    // Ask send message when playing
    [musicPlayer beginGeneratingPlaybackNotifications];
    
    [self initAlbumInfo];
    [musicPlayer setNowPlayingItem:_nowPlayingItem];
    [musicPlayer play];
    [self setButtonImage:@"bfzn_003.png"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) nowPlayingItemChanged:(NSNotification *)notification{
    [self initAlbumInfo];
}

-(void) initAlbumInfo{
    // Do any additional setup after loading the view from its nib.
    
    
    // Initialize
    MPMediaItem *item = [musicPlayer nowPlayingItem];
    
    // Album cover picture
    MPMediaItemArtwork *artwork = [item valueForKey:MPMediaItemPropertyArtwork];
    if(artwork)
        _artwork.image = [artwork imageWithSize:CGSizeMake(130,130)];
    
    // Song
    _songLabel.text = [item valueForProperty:MPMediaItemPropertyTitle];
    
    // Album title
    _titleLabel.text = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
    
    // Artist
    _artistLabel.text = [item valueForProperty:MPMediaItemPropertyArtist];
    
    // Time duration
    timeDuration = [[item valueForProperty:MPMediaItemPropertyPlaybackDuration]doubleValue];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(ticker) userInfo:nil repeats:1];
}

-(void) setButtonImage:(NSString *)imageName{
    UIGraphicsBeginImageContext(_playButton.frame.size);
    [[UIImage imageNamed:imageName] drawInRect:_playButton.bounds];
    UIImage *buttonImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [_playButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
}

-(void)ticker{
    _progressLabel.progress = musicPlayer.currentPlaybackTime / timeDuration;
}

- (IBAction)clickNext:(UIButton *)sender {
    [musicPlayer skipToNextItem];
    [musicPlayer play];
}

- (IBAction)clickPreview:(UIButton *)sender {
    [musicPlayer skipToPreviousItem];
    [musicPlayer play];
}

- (IBAction)clickBack:(UIButton *)sender {
    [self dismissViewControllerAnimated:1 completion:nil];
}

- (IBAction)handleSlider:(UISlider *)sender {
    musicPlayer.volume = sender.value;
}

- (IBAction)clickPlayback:(UIButton *)sender {
    switch(musicPlayer.playbackState){
        case MPMusicPlaybackStatePlaying:
            [self setButtonImage:@"bfzn_004.png"];
            _progressLabel.tintColor = [UIColor blueColor];
            [musicPlayer pause];
            break;
        case MPMusicPlaybackStatePaused:
            [self setButtonImage:@"bfzn_003.png"];
            _progressLabel.tintColor = [UIColor blueColor];
            [musicPlayer play];
            break;
        case MPMusicPlaybackStateInterrupted:
            [self setButtonImage:@"bfzn_003.png"];
            _progressLabel.tintColor = [UIColor blueColor];
            [musicPlayer play];
            break;
        case MPMusicPlaybackStateStopped:
            [self initAlbumInfo];
            [self setButtonImage:@"bfzn_003.png"];
            _progressLabel.tintColor = [UIColor blueColor];
            [musicPlayer play];
            break;
        case MPMusicPlaybackStateSeekingForward:
            [musicPlayer endSeeking];
            _progressLabel.tintColor = [UIColor blueColor];
            break;
        case MPMusicPlaybackStateSeekingBackward:
            [musicPlayer endSeeking];
            _progressLabel.tintColor = [UIColor blueColor];
            break;
            
    }
}

- (IBAction)clickStop:(UIButton *)sender {
    [self setButtonImage:@"bfzn_004.png"];
    _progressLabel.tintColor = [UIColor blueColor];
    [musicPlayer stop];
}
- (IBAction)touchDownForward:(UIButton *)sender {
    [musicPlayer beginSeekingForward];
    _progressLabel.tintColor = [UIColor redColor];
}

- (IBAction)touchDownBackward:(UIButton *)sender {
    [musicPlayer beginSeekingBackward];
    _progressLabel.tintColor = [UIColor redColor];
}
@end
