//
//  ViewController.m
//  TimeVibrateDemo
//
//  Created by Wayne on 1/27/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ViewController.h"
typedef enum{
    buttonStart,
    buttonStop
}ButtonState;

static int hour,
minute,
second,
currentCount;
@interface ViewController (){
    NSMutableArray *timerArray;
    NSTimer *timer;
    ButtonState buttonState;
    NSDate *time;
    NSDateComponents *timeComponent;
    NSCalendar *gregorian;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _pickerList.delegate = self;
    buttonState = buttonStop;
    _buttonStart.layer.cornerRadius = 10;
    _buttonStart.backgroundColor = [UIColor blueColor];
    
    timeComponent = [[NSDateComponents alloc] init];
    [timeComponent setHour:0];
    [timeComponent setMinute:0];
    [timeComponent setSecond:0];
    time = [[NSDate alloc] init];
    
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    time = [gregorian dateFromComponents:timeComponent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component{
    return 18000;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component){
        case 0:
            return [NSString stringWithFormat:@"%d",row%24];
            break;
        case 1:
            return [NSString stringWithFormat:@"%d",row%60];
            break;
        case 2:
            return [NSString stringWithFormat:@"%d",row%60];
            break;
        default:
            return [NSString stringWithFormat:@"0"];
            break;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(buttonState == buttonStop){
        switch(component){
            case 0:
                hour = (row%24) * 60 * 60;
                break;
            case 1:
                minute = (row%60) * 60;
                break;
            case 2:
                second = row%60;
                break;
            default:
                break;
        }
        currentCount = hour + minute + second;
        NSLog(@"\nhour:%d\nminute:%d\nsecond:%d\n",hour,minute,second);
        _labelTimer.text = [NSString stringWithFormat:@"%d sec",currentCount];
    }
}

- (IBAction)clickStart:(UIButton *)sender {
    if (currentCount == 0) return;
    if(buttonState == buttonStop){
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                 target:self
                                               selector:@selector(subtractTime)
                                               userInfo:nil
                                                repeats:1];
        buttonState = buttonStart;
        sender.backgroundColor = [UIColor redColor];
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
    }else if (buttonState == buttonStart){
        [timer invalidate];
        buttonState = buttonStop;
        sender.backgroundColor = [UIColor lightGrayColor];
        [sender setTitle:@"Continue" forState:UIControlStateNormal];
    }
}

-(void)subtractTime{
    currentCount--;
    _labelTimer.text = [NSString stringWithFormat:@"%d sec",currentCount];
    
    //    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    //    [format setDateFormat:@"hh:MM:ss"];
    //    _labelTimer.text = [format stringFromDate:[time dateByAddingTimeInterval:currentCount]];
    
    if(currentCount == 0){
        buttonState = buttonStop;
        _buttonStart.backgroundColor = [UIColor blueColor];
        [_buttonStart setTitle:@"Start" forState:UIControlStateNormal];
        [timer invalidate];
        for(int i=1; i<10; i++)
            [self performSelector:@selector(vibrateForALongTime:) withObject:self afterDelay:i*.3f];
    }
}

-(void)vibrateForALongTime:(id)sender{
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

@end
