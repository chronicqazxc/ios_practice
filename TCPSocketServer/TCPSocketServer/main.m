//
//  main.m
//  TCPSocketServer
//
//  Created by Wayne on 2/18/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//
#include <sys/socket.h>
#include <netinet/in.h>

#define PORT 9000

#import <Foundation/Foundation.h>


void AcceptCallBack(CFSocketRef, CFSocketCallBackType, CFDataRef, const void *, void *);
void WriteStreamClientCallBack(CFWriteStreamRef stream, CFStreamEventType eventType, void *);
void ReadStreamClientCallBack (CFReadStreamRef stream, CFStreamEventType eventType, void *);

int main(int argc, const char * argv[])
{

        // Define a Server Socket reference
        CFSocketRef serverSocket;
        // Create socket context
        CFSocketContext socketContext = {0, NULL, NULL, NULL, NULL};
        // Create socket TCP IPv4 set callback funciton
        serverSocket = CFSocketCreate(NULL, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, (CFSocketCallBack)AcceptCallBack,&socketContext);
        if(serverSocket == NULL)
            return -1;
        
        // Set whether re-bundle tag
        int yes = 1;
        // Set attribute of socket, SOL_SOCKET is set tcp, SO_REUSEADDR is re-bundle, yse to indicate whether re-bundle
        setsockopt(CFSocketGetNative(serverSocket), SOL_SOCKET, SO_REUSEADDR, (void *)&yes, sizeof(yes));
        
        // Set port and address
        struct sockaddr_in socketAddr;
        memset(&socketAddr, 0, sizeof(socketAddr)); // User memset function to copy memory address
        socketAddr.sin_len = sizeof(socketAddr);
        socketAddr.sin_family = AF_INET;            // AF_INET is set IPv4
        socketAddr.sin_port = htons(PORT);          // htons function usigned short int -> "net byte"
        socketAddr.sin_addr.s_addr = htons(INADDR_ANY); // INADDR_ANY alloc core, htons unsigned int -> "net byte"
        
        CFDataRef address = CFDataCreate(kCFAllocatorDefault, (UInt8*)&socketAddr, sizeof(socketAddr));
        
        // Bundle Socket
        if (CFSocketSetAddress(serverSocket, (CFDataRef)address) != kCFSocketSuccess){
            fprintf(stderr, "Socket bundle faild\n");
            CFRelease(serverSocket);
            return -1;
        }
        
        // Create a Run Loop Socket source
        CFRunLoopSourceRef sourceRef = CFSocketCreateRunLoopSource(kCFAllocatorDefault, serverSocket, 0);
        // Add Socket source to Run Loop
        CFRunLoopAddSource(CFRunLoopGetCurrent(), sourceRef, kCFRunLoopCommonModes);
        CFRelease(sourceRef);
        
        printf("Socket listening on port %d\n", PORT);
        // Execute Loop
        CFRunLoopRun();
        
}

// Callback when receive request by client
void AcceptCallBack(CFSocketRef socket,
                    CFSocketCallBackType type,
                    CFDataRef address,
                    const void *data,
                    void *info){
    CFReadStreamRef readStream = NULL;
    CFWriteStreamRef writeStream = NULL;
    
    // paraments data is, if callback type is kCFSocketAcceptCallBack, data will be pointer type of CFSocketNaviHandle
    CFSocketNativeHandle sock = *(CFSocketNativeHandle *)data;
    
    // Create read and write Socket stream
    CFStreamCreatePairWithSocket(kCFAllocatorDefault, sock, &readStream, &writeStream);
    
    if(!readStream || !writeStream){
        close(sock);
        fprintf(stderr, "CFStreamCreatePairWithSocket() faild\n");
        return;
    }
    
    CFStreamClientContext streamCtxt = {0, NULL, NULL, NULL, NULL};
    // Register two kinds of callback function
    CFReadStreamSetClient(readStream, kCFStreamEventHasBytesAvailable, ReadStreamClientCallBack, &streamCtxt);
    CFWriteStreamSetClient(writeStream, kCFStreamEventCanAcceptBytes, WriteStreamClientCallBack, &streamCtxt);
    
    // Add to loop
    CFReadStreamScheduleWithRunLoop(readStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
    CFWriteStreamScheduleWithRunLoop(writeStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
    
    CFReadStreamOpen(readStream);
    CFWriteStreamOpen(writeStream);
    
}

// Read stream, callback when data comes by client
void ReadStreamClientCallBack(CFReadStreamRef stream, CFStreamEventType eventType, void * clientCallBackInfo){
    UInt8 buff[255];
    CFReadStreamRef inputStream = stream;
    
    if(NULL != inputStream){
        CFReadStreamRead(stream, buff, 255);
        printf("Receive data:%s\n",buff);
        CFReadStreamClose(inputStream);
        CFReadStreamUnscheduleFromRunLoop(inputStream, CFRunLoopGetCurrent(),kCFRunLoopCommonModes);
        inputStream = NULL;
    }
}

// Write stream, callback when load data by client
void WriteStreamClientCallBack(CFWriteStreamRef stream, CFStreamEventType eventType, void * clientCallBackInfo){
    CFWriteStreamRef outputStream = stream;
    // output
    UInt8 buff[] = "Hello Client";
    if(NULL != outputStream){
        CFWriteStreamWrite(outputStream, buff, strlen((const char*) buff)+1);
        CFWriteStreamClose(outputStream);
        CFWriteStreamUnscheduleFromRunLoop(outputStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
        outputStream = NULL;
    }
}