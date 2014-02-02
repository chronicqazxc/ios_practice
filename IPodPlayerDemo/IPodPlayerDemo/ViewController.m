//
//  ViewController.m
//  PlayIPodDemo
//
//  Created by Wayne on 2/1/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ViewController.h"
#import "MediaPlayerController.h"

@interface ViewController (){
    MPMediaItemCollection *mediaItemCollections;
    MPMediaItem *nowPlayingItem;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickOpen:(UIButton *)sender {
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    mediaPicker.delegate = self;
    
    // Set can select multiple items
    mediaPicker.allowsPickingMultipleItems = 1;
    
    // Open music list window
    [self presentViewController:mediaPicker animated:1 completion:nil];
}


#pragma mark - MPMediaPickerControllerDelegate
-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    [musicPlayer setQueueWithItemCollection:mediaItemCollection];
//    [musicPlayer play];
    
    mediaItemCollections = mediaItemCollection;
    nowPlayingItem = musicPlayer.nowPlayingItem;
}

-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    [self dismissViewControllerAnimated:1 completion:nil];
}
- (IBAction)clickNowPlaying:(UIButton *)sender {
    // Go to xib
    MediaPlayerController *playerController = [[MediaPlayerController alloc] initWithNibName:@"MediaPlayerController" bundle:nil];
    playerController.mediaItemColleciton = mediaItemCollections;
    playerController.nowPlayingItem = nowPlayingItem;
    [self presentViewController:playerController animated:1 completion:nil];
}
@end
