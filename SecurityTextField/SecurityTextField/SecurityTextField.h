//
//  SecurityTextField.h
//  SecurityTextField
//
//  Created by Wayne on 1/6/15.
//  Copyright (c) 2015 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecurityTextField : UITextField
@property (nonatomic) BOOL shouldMaskLastCharactor;
@property (strong, nonatomic) NSString *maskString;
@property (nonatomic) NSUInteger textFieldLength;
- (void)setRangeLocation:(NSUInteger)location length:(NSUInteger)length;
- (NSString *)getContent;
@end
