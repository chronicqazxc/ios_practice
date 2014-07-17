//
//  WayneFBShareDialog.m
//  FBLoginTest
//
//  Created by Wayne on 4/18/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "WayneFBShareDialog.h"

@implementation WayneFBShareDialog

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (void)publishContentWithParams:(FBShareDialogParams *)params{
    
    WayneFBShareDialog *fbDialog = [[WayneFBShareDialog alloc] init];
    
    [fbDialog publishContentWithParams:params];
    
}

- (void)publishContentWithParams:(FBShareDialogParams *)params{
    
//    [self prepareFBShareDialogParams:params];
    
    if ([FBDialogs canPresentShareDialogWithParams:params]){
        
        [self presentShareDialogWithParams:params];
        
    }else{
        
        [self presentFeedDialogWithParams:[self prepareForFeedDialogParams:params]];
        
    }
}

- (void)prepareFBShareDialogParams:(FBShareDialogParams *) params{
    
    params.link = [NSURL URLWithString:@"https://developers.facebook.com/docs/ios/share/"];
    
    params.name = @"Share Demo";
    
    params.caption = @"yes";
    
    params.picture = [NSURL URLWithString:@"http://i.imgur.com/g3Qc1HN.png"];
    
    params.description = @"Allow your users to share stories on Facebook from your app using the iOS SDK.";
    
    params.ref = @"testtesttest";
    
}

- (void)presentShareDialogWithParams:(FBShareDialogParams *)params{
    [FBDialogs presentShareDialogWithLink:params.link name:params.name caption:params.caption description:params.description picture:params.picture clientState:nil handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
        
        if(error){
            
            NSLog(@"%@",[NSString stringWithFormat:@"Error publish story: %@", [error description]]);
        }else{
            
            NSLog(@"result %@", results);
            
        }
    }];
}

- (NSDictionary *)prepareForFeedDialogParams:(FBShareDialogParams *)params{
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   params.name, @"name",
                                   params.caption, @"caption",
                                   params.description, @"description",
                                   params.link.absoluteString , @"link",
                                   params.picture.absoluteString,@"picture",
                                   params.ref, @"ref",
                                   nil];
    
    return dicParams;
}

- (void)presentFeedDialogWithParams:(NSDictionary *) params{
    
    [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:params handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {

        if (error){
            
            NSLog( @"Error publishing story: %@", [error description]);
            
        } else {
            
            if (result == FBWebDialogResultDialogNotCompleted){
                NSLog(@"User cancelled");
            } else {
                
                NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                
                if (![urlParams valueForKey:@"post_id"]){
                    
                    NSLog(@"User cancelled");
                } else {
                    
                    NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                    
                    NSLog(@"%@",result);
                }
            }
        }
        
    }];
}

- (NSDictionary *)parseURLParams:(NSString *)query{
    
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    for (NSString *pair in pairs){
        
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        
        NSString *val = [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        params[kv[0]] = val;
        
    }
    
    return params;
}

+ (void)updatingaStatus{
    
    WayneFBShareDialog *fbDialog = [[WayneFBShareDialog alloc] init];
    
    
    if ([FBDialogs canPresentShareDialogWithParams:nil]){
        
        [fbDialog presentShareDialogWithParams:nil];
        
    }else{
        
        [fbDialog presentFeedDialogWithParams:nil];
        
    }
    
}

- (void)sharingPhotots{
    
    if ([FBDialogs canPresentShareDialogWithPhotos]){
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        [imagePicker setDelegate:self.delegate];
        
        [self.delegate showImagePicker:imagePicker];
        
    }else{
        
        NSLog(@"You can't present dialog with photos");
    }
}

- (void)presentShareDialogForPhotoWithParams:(FBShareDialogPhotoParams *)params{
    
    [FBDialogs presentShareDialogWithPhotoParams:params clientState:nil handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
        
        if (error){
            
            NSLog(@"Error: %@", [error description]);
            
        } else {
            
            NSLog(@"Success");
        }
    }];
}

@end
