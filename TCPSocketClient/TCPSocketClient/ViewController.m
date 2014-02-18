//
//  ViewController.m
//  TCPSocketClient
//
//  Created by Wayne on 2/19/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    int flag; // Indicate operation (0:send, 1:receive)
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

- (IBAction)clickSend:(UIButton *)sender {
    flag = 0;
    [self initNetworkCommunication];
}

- (IBAction)clickReceive:(UIButton *)sender {
    flag = 1;
    [self initNetworkCommunication];
}

- (void)initNetworkCommunication{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"127.0.0.1",PORT, &readStream, &writeStream);
    
    _inputStream = (__bridge_transfer NSInputStream *)readStream;
    _outputStream = (__bridge_transfer NSOutputStream *)writeStream;
    
    _inputStream.delegate = self;
    _outputStream.delegate = self;
    
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [_inputStream open];
    [_outputStream open];
}

#pragma mark - NSStreamDelegate
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
                NSMutableData *input = [[NSMutableData alloc]init];
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
                _label.text = resultString;
            }
            break;
        case NSStreamEventHasSpaceAvailable:
            event = @"NSStreamEventHasSpaceAvailable";
            if (flag == 0 && aStream == _outputStream){
                UInt8 buff[] = "Hello Server";
                [_outputStream write:buff maxLength:strlen((const char*) buff)+1];
                [_outputStream close];
            }
            break;
        case NSStreamEventErrorOccurred:
            event = @"NSStreamEventErrorOccurred";
            [self close];
            break;
        case NSStreamEventEndEncountered:
            event = @"NSStreamEventEndEncountered";
            NSLog(@"Error:%d:%@",[[aStream streamError] code], [[aStream streamError] localizedDescription]);
            break;
            default:
            [self close];
            event = @"Unknown";
            break;
            
    }
    NSLog(@"event-----------%@",event);
}

- (void)close{
    [_outputStream close];
    [_outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream setDelegate:nil];
    [_inputStream close];
    [_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream setDelegate:nil];
}
@end
