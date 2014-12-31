//
//  OpenGraphStoriesViewController.m
//  FBLoginTest
//
//  Created by Wayne on 4/18/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "OpenGraphStoriesViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "ActionSheet.h"
#import "CheckPermissions.h"
#import "FBLoginTestAppDelegate.h"

enum determindApiOrShareDialog{
    API = 0,
    ShareDialog = 1
};

@interface OpenGraphStoriesViewController (){
    
    UIImagePickerController *imagePicker;
    
    ActionSheet *actionSheet;
    
    id <FBOpenGraphObject> openGraphObject;
    
    id <FBOpenGraphAction> openGraphAction;
    
    NSString *stagedImageURL;
    
    UIImage *stagedImage;
    
    FBOpenGraphActionParams *dialogParams;
    
    int ISAPIorShareDialog;

}

@end

@implementation OpenGraphStoriesViewController

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
     actionSheet = [[ActionSheet alloc] init];
    
    actionSheet.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickAPICall:(UIButton *)sender {
    
    ISAPIorShareDialog = sender.tag;
    
    [CheckPermissions checkForPermissions:@[@"publish_actions"]];
    
    [self showActionSheet];
    
}

- (void)processAPICall{
    
    [self createOpenGraphObject];
        
    [self startPostOpenGraphObject];
    
}

- (IBAction)clickShareDialog:(UIButton *)sender {
    
    ISAPIorShareDialog = sender.tag;
    
    [self showActionSheet];
    
}

- (void)processShareDialog{
    
    [self createOpenGraphObjectForShareDialog];
        
    [self createOpenGraphActionForShareDialog];
        
    [self setDialogParams];
    
    if ([FBDialogs canPresentShareDialogWithOpenGraphActionParams:dialogParams])
        [self presentShareDialog];
    else
        [self useFeedDialog];
    
}

- (void)showActionSheet{
    
    UIActionSheet *showActionSheet = [[UIActionSheet alloc] initWithTitle:@"Chose" delegate: actionSheet cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Camera" otherButtonTitles:@"PhotoLibrary",@"Phto Album", nil];
    
    [showActionSheet showInView:self.view];
    
}
#pragma mark -
#pragma mark ActionSheetDelegate

- (void)openImagePickerWithImagePickerSourceType:(UIImagePickerControllerSourceType)sourceType{
    
    imagePicker = [[UIImagePickerController alloc] init];
    
    [imagePicker setSourceType:sourceType];
    
    [imagePicker setDelegate:self];
    
    [self presentViewController:imagePicker animated:YES completion:^{
        nil;
    }];
    
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate (staging an image to staging image service)

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.imageView.image = img;
    
    stagedImage = img;
    
    [self stagingImage:stagedImage];
    
    self.waitLabel.text = @"請稍後...";
    
    [gAppDelegate startLoading];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
    
}

- (void)stagingImage:(UIImage *)image{
    
    [FBRequestConnection startForUploadStagingResourceWithImage:image completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (!error){
            
            NSLog(@"Successfuly staged image with staged URI: %@", [result objectForKey:@"uri"]);
            
            stagedImageURL = [result objectForKey:@"uri"];
            
            if (ISAPIorShareDialog == API){
                
                [self processAPICall];
                
            }else if (ISAPIorShareDialog == ShareDialog){
                
                [self processShareDialog];
                
            }
        } else {
            
            NSLog(@"Error staging an image: %@", error);
        }
    }];
    
}

- (void)createOpenGraphObjectForShareDialog{
    
    openGraphObject = [FBGraphObject openGraphObjectForPostWithType:@"waynelogindemo:dish" title:@"Eat a dish" image:stagedImageURL url:@"http://www.apple.com" description:@"Eat a dish"];
}

- (void)createOpenGraphActionForShareDialog{
    
    openGraphAction = (id <FBOpenGraphAction>)[FBGraphObject graphObject];
    
    [openGraphAction setObject:openGraphObject forKey:@"dish"];
    
}

- (void)createOpenGraphObject{
    
    openGraphObject = [FBGraphObject openGraphObjectForPost];
    
    openGraphObject.provisionedForPost = YES;
    
    openGraphObject[@"title"] = @"Eat a dish";
    
    openGraphObject[@"type"] = @"waynelogindemo:dish";
    
    openGraphObject[@"url"] = @"http://www.apple.com";
    
    openGraphObject[@"description"] = @"Eat a dish";
    
    openGraphObject[@"image"] = @[@{@"url":stagedImageURL, @"user_generated" : @"false"}];
}

- (void)startPostOpenGraphObject{
    
    [FBRequestConnection startForPostOpenGraphObject:openGraphObject completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (!error){
            
            NSString *objectId = [result objectForKey:@"id"];
            
            NSLog(@"object id: %@", objectId);
            
            [self createOpenGraphActionWithObjectID:objectId];
            
            [self startPostGraphPath];
            
        } else{
            
            NSLog(@"Error posting the Open Graph Object to the Object API: %@", error);
        }
    }];
}

- (void)createOpenGraphActionWithObjectID:(NSString *)objectID{
    
    openGraphAction = (id <FBOpenGraphAction>)[FBGraphObject graphObject];
    
    [openGraphAction setObject:objectID forKey:@"dish"];
    
}

- (void)startPostGraphPath{
    
    self.waitLabel.text = @"";
    
    [gAppDelegate stopLoading];
    
    [FBRequestConnection startForPostWithGraphPath:@"/me/waynelogindemo:eat" graphObject:openGraphAction completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (!error){
            
            NSLog(@"OG story posted, story id: %@", [result objectForKey:@"id"]);
            [[[UIAlertView alloc] initWithTitle:@"OG story posted"
                                        message:@"Check your Facebook profile or activity log to see the story."
                                       delegate:self
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil] show];
        } else {
            
            NSLog(@"Encountered an error posting to Open Graph: %@", error);
        }
    }];
}

- (void)setDialogParams{
    
    dialogParams = [[FBOpenGraphActionParams alloc] init];
    
    dialogParams.action = openGraphAction;
    
    dialogParams.actionType = @"waynelogindemo:eat";
    
}

- (void)presentShareDialog{
    
    self.waitLabel.text = @"";
    
    [gAppDelegate stopLoading];
    
    [FBDialogs presentShareDialogWithOpenGraphAction:openGraphAction
                                          actionType:dialogParams.actionType
                                 previewPropertyName:@"dish"
                                             handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                 if(error) {
                                                     // There was an error
                                                     NSLog(@"Error publishing story: %@", [error description]);
                                                 } else {
                                                     // Success
                                                     NSLog(@"result %@", results);
                                                 }
                                             }];
}

- (void)useFeedDialog{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Work at home", @"name", @"Hard work", @"caption", @"Hard work", @"description", @"http://www.apple.com", @"link", @"https://promo.tw.campaign.yahoo.net/english/upload/s11373006438.jpg", @"picture", nil];
    
    [gAppDelegate stopLoading];
    
    [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:params handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
        
        self.waitLabel.text = @"";
        
        if (error){
            
            NSLog(@"%@", [error description]);
        }else {
            
            if (result == FBWebDialogResultDialogNotCompleted){
                
                NSLog(@"User cancelled.");
            }else {
                
                NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                
                if (![urlParams valueForKey:@"post_id"]) {
                    // User canceled.
                    NSLog(@"User cancelled.");
                }else {
                    
                    NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                    NSLog(@"result %@", result);
                }
        }
    }
    }];
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1]
                         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}
@end
