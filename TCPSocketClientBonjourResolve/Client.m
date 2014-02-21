//
//  Client.m
//  TCPSocketClientBonjourResolve
//
//  Created by Wayne on 2/21/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "Client.h"

@interface Client(){
    int port;
}

@end

@implementation Client
- (id)init{
    _service = [[NSNetService alloc] initWithDomain:@"local." type:@"_tonyipp._tcp." name:@"tony"];
    [_service setDelegate:self];
    
    [_service resolveWithTimeout:1.0];
    _services = [[NSMutableArray alloc] init];
    return self;
}

#pragma mark - NSNetServiceDelegate Methods

- (void)netServiceDidResolveAddress:(NSNetService *)sender{
    NSLog(@"netServiceDidResolveAddress");
    [_services addObject:sender];
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict{
    NSLog(@"didNotResolve: %@",errorDict);
}

@end
