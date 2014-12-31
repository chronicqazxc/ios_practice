//
//  WayneFBShareDialog.h
//  FBLoginTest
//
//  Created by Wayne on 4/18/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@protocol WayneFBShareDialogDelegate;

@interface WayneFBShareDialog : NSObject

@property (strong, nonatomic) id <WayneFBShareDialogDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> delegate;

+ (void)publishContentWithParams:(FBLinkShareParams *)params;
+ (void)updatingaStatus;
- (void)sharingPhotots;
- (void)presentShareDialogForPhotoWithParams:(FBPhotoParams *)params;

@end

@protocol WayneFBShareDialogDelegate <NSObject>

- (void)showImagePicker:(UIImagePickerController *)imagePicker;

@end
