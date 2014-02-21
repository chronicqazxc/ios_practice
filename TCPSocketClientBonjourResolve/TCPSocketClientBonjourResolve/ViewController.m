//
//  ViewController.m
//  TCPSocketClientBonjourResolve
//
//  Created by Wayne on 2/21/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    int flag; // 0 -> send, 1 -> receive
}
- (void)closeStreams;
- (void)openStreams;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _client = [[Client alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendData:(UIButton *)sender {
    flag = 0;
    [self openStreams];
}

- (IBAction)receiveData:(UIButton *)sender {
    flag = 1;
    [self openStreams];
}

- (void)closeStreams{
    [_outputStream close];
    [_outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream setDelegate:nil];
    
    [_inputStream close];
    [_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream setDelegate:nil];
}

- (void)openStreams{
    for(NSNetService *service in _client.services){
        if ([@"tony" isEqualToString:service.name]){
            if(![service getInputStream:&_inputStream outputStream:&_outputStream]){
                NSLog(@"Connect to server faild");
                return;
            }
            break;
        }
    }
    
    _outputStream.delegate = self;
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream open];
    
    _inputStream.delegate = self;
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream open];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    NSString *event;
    switch(eventCode){
        case NSStreamEventNone:
            event = @"NSStreamEventNone";
            break;
        case NSStreamEventOpenCompleted:
            event = @"NSStreamEventOpenCompleted";
            break;
        case NSStreamEventHasBytesAvailable:
            event = @"NSStreamEventHasBytesAvailable";
            if (flag == 1 && aStream == _inputStream){
                NSMutableData *input = [[NSMutableData alloc] init];
                uint8_t buffer[1024];
                int len;
                while([_inputStream hasBytesAvailable]){
                    len = [_inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0){
                        [input appendBytes:buffer length:len];
                    }
                }
                NSString *resultString = [[NSString alloc] initWithData:input encoding:NSUTF8StringEncoding];
                NSLog(@"Receive:%@",resultString);
                _message.text = resultString;
            }
            break;
        case NSStreamEventHasSpaceAvailable:
            event = @"NSStreamEventHasSpaceAvailable";
            if(flag == 0 && aStream == _outputStream){
                UInt8 buff[] = "Hello Server";
                [_outputStream write:buff maxLength:strlen((const char*) buff)+1];
                [_outputStream close];
            }
            break;
        case NSStreamEventErrorOccurred:
            event = @"NSStreamEventErrorOccurred";
            [self closeStreams];
            break;
        case NSStreamEventEndEncountered:
            event = @"NSStreamEventErrorOccurred";
            break;
        default:
            [self closeStreams];
            event = @"Unknow";
            break;
    }
    NSLog(@"event------------------%@",event);
}
@end
