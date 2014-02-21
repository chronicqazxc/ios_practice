//
//  main.m
//  TCPSocketServerBonjour
//
//  Created by Wayne on 2/21/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Server.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        Server *server = [[Server alloc] init];
        CFRunLoopRun();
        
    }
    return 0;
}

