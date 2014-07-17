//
//  ActionSheet.h
//  FBLoginTest
//
//  Created by Wayne on 4/20/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AcitonSheetDelegate;

@interface ActionSheet : NSObject <UIActionSheetDelegate>

@property (strong, nonatomic) id <AcitonSheetDelegate> delegate;

@end

@protocol AcitonSheetDelegate <NSObject>

- (void)openImagePickerWithImagePickerSourceType:(UIImagePickerControllerSourceType)sourceType;

@end
