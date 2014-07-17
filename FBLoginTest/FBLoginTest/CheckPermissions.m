//
//  CheckPermissions.m
//  FBLoginTest
//
//  Created by Wayne on 4/17/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "CheckPermissions.h"
#import <FacebookSDK/FacebookSDK.h>

@interface CheckPermissions(){
    
    NSMutableArray *postPermissions, *readPermissions;
}

@end

@implementation CheckPermissions

+ (void)checkForPermissions:(NSArray *)permissions{
    
    CheckPermissions *checkPermissions = [[CheckPermissions alloc] init];
    
    [checkPermissions checkForPermissions:permissions];
    
}

- (void)checkForPermissions:(NSArray *)permissions{
    
    [FBRequestConnection startWithGraphPath:@"/me/permissions" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        NSMutableArray *missingPermissions;
        
        if(!error){
            missingPermissions = [self checkPermissions:permissions withResult:result];
            
            if ([missingPermissions count] > 0){
                [self requestPermissions:missingPermissions];
            }
        }
        
        
    }];
}

- (NSMutableArray *)checkPermissions:(NSArray *)permissions withResult:(id)result{
    
    NSDictionary *permissionDic = [(NSArray *)[result data] objectAtIndex:0];
    
    NSString *permissionName;
    
    NSMutableArray *permissionsPrepareToRequest;
    
    permissionsPrepareToRequest = [NSMutableArray array];
    
    for(permissionName in permissions){
        
        if (![permissionDic objectForKey:permissionName]){
            
            [permissionsPrepareToRequest addObject:permissionName];
            
        }
    }
    
    return permissionsPrepareToRequest;
}

- (void)requestPermissions:(NSMutableArray *)permissions{
    
    postPermissions = [NSMutableArray array];
    
    readPermissions = [NSMutableArray array];
    
    [self dertermindPostOrReadPermission:permissions];
    
    if ([readPermissions count] != 0){
        
        [[FBSession activeSession] requestNewReadPermissions:permissions completionHandler:^(FBSession *session, NSError *error) {
            
            if(!error){
                NSLog(@"Request new read permisson success");
            }
        }];
    }else if([postPermissions count] != 0){
        
        [[FBSession activeSession] requestNewPublishPermissions:postPermissions defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error) {
            if(!error){
                NSLog(@"Request new publish permisson success");
            }
        }];
    }
    
}

- (void)dertermindPostOrReadPermission:(NSMutableArray *)permissions{
    
    for (NSString *dertermindPostOrReadPermission in permissions){
        
        if ([[dertermindPostOrReadPermission substringToIndex:7] isEqualToString:@"publish"])
            [postPermissions addObject:dertermindPostOrReadPermission];
        else
            [readPermissions addObject:dertermindPostOrReadPermission];

    }
}
@end
