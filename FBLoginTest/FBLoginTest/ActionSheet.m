//
//  ActionSheet.m
//  FBLoginTest
//
//  Created by Wayne on 4/20/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ActionSheet.h"

@implementation ActionSheet

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex){
        case 0:
            [self.delegate openImagePickerWithImagePickerSourceType:UIImagePickerControllerSourceTypeCamera];
        case 1:
            [self.delegate openImagePickerWithImagePickerSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        case 2:
            [self.delegate openImagePickerWithImagePickerSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }
    
}
@end
