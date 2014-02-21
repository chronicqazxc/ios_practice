//
//  Server.h
//  TCPSocketServerBonjour
//
//  Created by Wayne on 2/21/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <netinet/in.h>
#import <sys/socket.h>

@interface Server : NSObject <NSNetServiceDelegate, NSStreamDelegate>

@property(nonatomic,strong) NSNetService *service;
@property(nonatomic,strong) NSSocketPort *socket;

@property(nonatomic,strong) NSInputStream *inputStream;
@property(nonatomic,strong) NSOutputStream *outputStream;

@property(nonatomic,assign) int port;

@end
