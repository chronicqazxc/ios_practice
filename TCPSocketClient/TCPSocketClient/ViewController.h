//
//  ViewController.h
//  TCPSocketClient
//
//  Created by Wayne on 2/19/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define PORT 9000

@interface ViewController : UIViewController <NSStreamDelegate>
- (IBAction)clickSend:(UIButton *)sender;
- (IBAction)clickReceive:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *label;

@property (nonatomic, retain) NSInputStream *inputStream;
@property (nonatomic, retain) NSOutputStream *outputStream;


@end
