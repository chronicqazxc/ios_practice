//
//  PublishViewController.m
//  FBLoginTest
//
//  Created by Wayne on 4/18/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "PublishViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CheckPermissions.h"
#import "APICallView.h"

@interface PublishViewController (){
    
    WayneFBShareDialog *fbSharingPhoto;
    
}

@end

@implementation PublishViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickAPICall:(UIButton *)sender {
    
    [CheckPermissions checkForPermissions:@[@"publish_actions"]];
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"APICallView" owner:nil options:nil];
    UIView *view = nil;
    for (view in views) {
        if ([view isKindOfClass:[APICallView class]]) {
            break;
        }
    }
    APICallView *apiCallView = (APICallView *)view;
    apiCallView.viewController = self;
    [self.view addSubview:apiCallView];
    [apiCallView popupShareDialog];
    
}

- (IBAction)clickUpdateByAPI:(UIButton *)sender {
    
    [FBRequestConnection startForPostStatusUpdate:@"User status update" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (!error){
            
            NSLog(@"result: %@", result);
            
        }else{
            
            NSLog(@"%@", [error description]);
            
        }
    }];
}

- (IBAction)clickShare:(UIButton *)sender {
    
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    
    [self prepareFBShareDialogParams:params];
    
    [WayneFBShareDialog publishContentWithParams:params];
    
}


- (void)prepareFBShareDialogParams:(FBShareDialogParams *) params{
    
    params.link = [NSURL URLWithString:@"https://developers.facebook.com/docs/ios/share/"];
    
    params.name = @"Share Demo";
    
    params.caption = @"good";
    
    params.picture = [NSURL URLWithString:@"http://i.imgur.com/g3Qc1HN.png"];
    
    params.description = @"Allow your users to share stories on Facebook from your app using the iOS SDK.";
    
}

- (IBAction)clickUpdate:(UIButton *)sender {
    
    [WayneFBShareDialog updatingaStatus];
}

- (IBAction)clickSharingPhoto:(UIButton *)sender {
    
    fbSharingPhoto = [[WayneFBShareDialog alloc] init];
    
    fbSharingPhoto.delegate = self;
    
    [fbSharingPhoto sharingPhotots];
    
}

#pragma mark -
#pragma mark WayneFBShareDialogDelegate

- (void)showImagePicker:(UIImagePickerController *)imagePicker{
    
    [self presentViewController:imagePicker animated:YES completion:^{
        nil;
    }];
    
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    FBShareDialogPhotoParams *params = [[FBShareDialogPhotoParams alloc] init];
    
    params.photos = @[img];
    
    [fbSharingPhoto presentShareDialogForPhotoWithParams:params];
}


@end
