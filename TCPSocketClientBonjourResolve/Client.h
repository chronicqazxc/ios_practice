//
//  Client.h
//  TCPSocketClientBonjourResolve
//
//  Created by Wayne on 2/21/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <netinet/in.h>
#import <sys/socket.h>

@interface Client : NSObject <NSNetServiceDelegate>

@property (nonatomic,strong) NSMutableArray *services;
@property (nonatomic,strong) NSNetService   *service;

@end
