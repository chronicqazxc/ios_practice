//
//  ViewController.m
//  MP3PlayerDemo
//
//  Created by Wayne on 1/21/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    NSMutableArray *songs;
    int currentSong;
    AVAudioPlayer *player;
    NSTimer *timer;
}
-(void) ticker:(NSTimer *)timer;
@end

@implementation ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Search mp3 file
    songs = [[NSMutableArray alloc] initWithCapacity:10];
    for (NSString *song in [[NSBundle mainBundle] pathsForResourcesOfType:@"mp3" inDirectory:nil])
        [songs addObject:song];
    
    // Set UIPickerView's delegate
    _songList.delegate = self;
    
    // Set ProgressView
    _progressView.progress = 0.0;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button event
#pragma mark change volume
- (IBAction)changeValue:(UISlider *)sender {
    if(player!= nil)
        player.volume = sender.value;
}

#pragma mark click play button
- (IBAction)playMP3:(UIButton *)sender {
    if (![player isPlaying]){
        NSURL *soundUrl = [NSURL fileURLWithPath:[songs objectAtIndex:currentSong]];
        player = nil;
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
        [player play];
        self.playStatus.text = [NSString stringWithFormat:@"Play %@",[[songs objectAtIndex:currentSong] lastPathComponent]];
        [sender setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(ticker:) userInfo:nil repeats:1];
    }else{
        [player pause];
        self.playStatus.text = @"Pause";
        [sender setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
}

-(void) ticker:(NSTimer *)timer{
    _progressView.progress = player.currentTime/player.duration;
}
#pragma mark - UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component{
    return [songs count];
}

-(NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    return [[songs objectAtIndex:row] lastPathComponent];
    NSDictionary *dic = [self getID3TagFromFile:[songs objectAtIndex:row]];
    NSString *title = (NSString *) [dic objectForKey:[NSString stringWithUTF8String:kAFInfoDictionary_Title]];
    NSString *artist = (NSString *) [dic objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_Artist]];
    if(title == nil)
        return [[songs objectAtIndex:row] lastPathComponent];
    else
        self.playStatus.text = artist;
        return title;
}

// Select song
-(void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    currentSong = row;
}

#pragma mark - Get ID3 tag
-(NSDictionary *)getID3TagFromFile:(NSString *)filename{
    NSURL *fileURL = [NSURL fileURLWithPath: filename];
    AudioFileID fileID = nil;
    OSStatus err = noErr;
    
    // Open file
    err = AudioFileOpenURL((__bridge CFURLRef) fileURL, kAudioFileReadPermission, 0, &fileID);
    
    if(err != noErr){
        NSLog(@"AudioFileOpenURL failed");
        return nil;
    }
    
    // Get properties info
    UInt32 id3DataSize = 0;
    err = AudioFileGetPropertyInfo( fileID, kAudioFilePropertyID3Tag, &id3DataSize, NULL);
    if (err != noErr){
        NSLog(@"AudioFileGetPropertyInfo failed for ID3 tag");
        return nil;
    }
    
    // Get properties
    NSDictionary *piDict = nil;
    UInt32 piDataSize = sizeof(piDict);
    
    err = AudioFileGetProperty(fileID, kAudioFilePropertyInfoDictionary, &piDataSize, &piDict);
    if(err != noErr){
        NSLog(@"AudioFileGetProperty failed for property info dictionary");
        return nil;
    }
    
    return piDict;
}
@end
