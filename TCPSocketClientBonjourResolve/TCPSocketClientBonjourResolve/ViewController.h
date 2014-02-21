//
//  ViewController.h
//  TCPSocketClientBonjourResolve
//
//  Created by Wayne on 2/21/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Client.h"

@interface ViewController : UIViewController <NSStreamDelegate>

@property (nonatomic, strong) NSInputStream  *inputStream;
@property (nonatomic, strong) NSOutputStream *outputStream;
@property (nonatomic, strong) Client         *client;

- (IBAction)sendData:(UIButton *)sender;
- (IBAction)receiveData:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *message;

@end
