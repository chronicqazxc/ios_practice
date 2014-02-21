//
//  Server.m
//  TCPSocketServerBonjour
//
//  Created by Wayne on 2/21/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "Server.h"

@interface Server()
void AcceptCallBack(CFSocketRef, CFSocketCallBackType, CFDataRef, const void *, void *);
void WriteStreamClientCallBack(CFWriteStreamRef stream, CFStreamEventType eventType, void *);
void ReadStreamClientCallBack (CFReadStreamRef stream, CFStreamEventType eventType, void *);
@end

@implementation Server
- (id)init{
    BOOL succeed = [self startServer];
    if(succeed){
        // Publish Server by Bonjour
        succeed = [self publishService];
    }else{
        NSLog(@"Server launch faild");
    }
    return self;
}

// Start Server
- (BOOL)startServer{
    CFSocketRef     serverReference;
    CFSocketContext serverContext = {0, (__bridge void *)(self), NULL, NULL, NULL};
    serverReference = CFSocketCreate(NULL, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, (CFSocketCallBack)AcceptCallBack, &serverContext);
    
    if(serverReference == NULL){
        return NO;
    }
    
    // Set whether need re-bundle tag
    int yes = 1;
    setsockopt(CFSocketGetNative(serverReference), SOL_SOCKET, SO_REUSEADDR, (void *)&yes, sizeof(yes));
    
    // Set port and address
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin_len = sizeof(addr);
    addr.sin_family = AF_INET;  //AF_INET is set IPv4
    addr.sin_port = 0;          //htons(PORT)
    addr.sin_addr.s_addr = htonl(INADDR_ANY);
    
    CFDataRef address = CFDataCreate(kCFAllocatorDefault, (UInt8*)&addr, sizeof(addr));
    
    // Set Socket
    if(CFSocketSetAddress(serverReference, (CFDataRef)address) != kCFSocketSuccess){
        fprintf(stderr, "Socket bundle faild\n");
        CFRelease(serverReference);
        return NO;
    }
    
    // Use when publish server by Bonjour
    NSData *socketAddressActualData = (__bridge NSData *)CFSocketCopyAddress(serverReference);
    
    // Transform sockaddr_in -> socketAddressActual
    struct sockaddr_in socketAddressActual;
    memcpy(&socketAddressActual, [socketAddressActualData bytes], [socketAddressActualData length]);
    self.port = ntohs(socketAddressActual.sin_port);
    
    printf("Socket listening on port %d\n", self.port);
    
    // Create a Run Loop source
    CFRunLoopSourceRef sourceRef = CFSocketCreateRunLoopSource(kCFAllocatorDefault, serverReference, 0);
    
    // Add Socket source to Run Loop
    CFRunLoopAddSource(CFRunLoopGetCurrent(), sourceRef, kCFRunLoopCommonModes);
    CFRelease(sourceRef);
    
    return YES;
}

// Create Server
- (BOOL)publishService{
    _service = [[NSNetService alloc] initWithDomain:@"local." type:@"_tonyipp._tcp." name:@"tony" port:self.port];
    
    // Add service to current Run Loop
    [_service scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [_service setDelegate:self];
    
    // Publish service
    [_service publish];
    
    return YES;
}

#pragma mark - NSNetServiceDelegate

- (void)netServiceDidPublish:(NSNetService *)sender{
    NSLog(@"netServiceDidPublish");
    if([@"tony" isEqualToString:sender.name]){
        if(![sender getInputStream:&_inputStream outputStream:&_outputStream]){
            NSLog(@"Connect to Server faild");
            return;
        }
    }
}

// Receive request by client, callback function
void AcceptCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info){
    CFReadStreamRef readStream = NULL;
    CFWriteStreamRef writeStream = NULL;
    
    CFSocketNativeHandle sock = *(CFSocketNativeHandle *)data;
    
    // Create Read Write Socket stream
    CFStreamCreatePairWithSocket(kCFAllocatorDefault, sock, &readStream, &writeStream);
    
    if(!readStream || !writeStream){
        close(sock);
        fprintf(stderr, "CFStreamCreatePairWithSocket() faild\n");
        return;
    }
    
    CFStreamClientContext streamContext = {0, NULL, NULL, NULL, NULL};
    
    CFReadStreamSetClient(readStream, kCFStreamEventHasBytesAvailable, ReadStreamClientCallBack, &streamContext);
    CFWriteStreamSetClient(writeStream, kCFStreamEventCanAcceptBytes, WriteStreamClientCallBack, &streamContext);
    
    CFReadStreamScheduleWithRunLoop(readStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
    CFWriteStreamScheduleWithRunLoop(writeStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
    
    CFReadStreamOpen(readStream);
    CFWriteStreamOpen(writeStream);
}

// Read stream, called when data comes by client
void ReadStreamClientCallBack(CFReadStreamRef stream, CFStreamEventType eventType, void* clientCallBackInfo){
    UInt8 buff[255];
    CFReadStreamRef inputStream = stream;
    
    if(NULL != inputStream){
        CFReadStreamRead(stream, buff, 255);
        printf("Receive data:%s\n",buff);
        CFReadStreamClose(inputStream);
        CFReadStreamUnscheduleFromRunLoop(inputStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
        inputStream = NULL;
    }
    
}

// Write stream, called when read data by client
void WriteStreamClientCallBack(CFWriteStreamRef stream, CFStreamEventType eventType, void* clientCallBackInfo){
    CFWriteStreamRef outputStream = stream;
    UInt8 buff[] = "Hello Client";
    if(NULL != outputStream){
        CFWriteStreamWrite(outputStream, buff, strlen((const char*)buff)+1);
        CFWriteStreamClose(outputStream);
        CFWriteStreamUnscheduleFromRunLoop(outputStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
        outputStream = NULL;
    }
}
@end
