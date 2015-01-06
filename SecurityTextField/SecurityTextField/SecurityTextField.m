//
//  SecurityTextField.m
//  SecurityTextField
//
//  Created by Wayne on 1/6/15.
//  Copyright (c) 2015 Wayne. All rights reserved.
//

#import "SecurityTextField.h"

@interface SecurityTextField()<UITextFieldDelegate>
@property (strong, nonatomic) NSMutableString *displayString;
@property (strong, nonatomic) NSMutableString *contentString;
@property (nonatomic) NSUInteger location;
@property (nonatomic) NSUInteger length;
@property (nonatomic) NSRange showRange;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) NSUInteger maskTime;
@property (nonatomic) NSUInteger countTime;
@end

@implementation SecurityTextField

- (id)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.delegate = self;
    self.contentString = [NSMutableString stringWithString:@""];
    self.displayString = [NSMutableString stringWithString:@""];
    self.maskTime = 3;
    self.countTime = 0;
    self.shouldMaskLastCharactor = YES;
    self.maskString = @"*";
    self.textFieldLength = 0;
    [self setRangeLocation:0 length:0];
}

- (void)setRangeLocation:(NSUInteger)location length:(NSUInteger)length {
    self.showRange = NSMakeRange(location, length);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)isRange:(NSRange)range containAnotherRange:(NSRange)anotherRange {
    BOOL result = NO;
    if (anotherRange.location >= range.location && anotherRange.location < (range.location+range.length)) {
        result = YES;
    }
    return result;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL isNumeric = YES;
    NSCharacterSet *noDigitalSet = [NSCharacterSet decimalDigitCharacterSet].invertedSet;
    if ([string rangeOfCharacterFromSet:noDigitalSet].location != NSNotFound) {
        isNumeric = NO;
    }
    
    if (isNumeric) {
        if ([string isEqualToString:@""]) {
            if ([self.displayString length] > 0 && [self.contentString length] > 0) {
                [self.displayString deleteCharactersInRange:range];
                [self.contentString deleteCharactersInRange:range];
            }
        } else if ([self isRange:self.showRange containAnotherRange:range] && range.location < self.textFieldLength) {
            [self.displayString appendString:string];
            [self.contentString appendString:string];
        } else if (range.location < self.textFieldLength){
            if ([self.displayString length] > 0) {
                [self.displayString deleteCharactersInRange:NSMakeRange(range.location-1, 1)];
                [self.displayString appendString:[NSString stringWithString:self.maskString]];
            }
            [self.displayString appendString:string];
            [self.contentString appendString:string];
        }
        textField.text = self.displayString;
    }
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    [self startCount];
}

//- (void)startCount {
//    self.countTime = 0;
//    
//    if (!self.timer) {
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countSeconds:) userInfo:nil repeats:YES];
//    } else {
//        [self.timer fire];
//    }
//}
//
//- (void)countSeconds:(NSTimer *)timer {
//    if (self.countTime >= self.maskTime) {
//        self.countTime = 0;
//        [timer invalidate];
//    } else {
//        self.countTime++;
//    }
//}

- (void)textFieldDidEndEditing:(UITextField *)textField {
//    [self.timer invalidate];
    if ([textField.text length] > 0) {
        if (self.shouldMaskLastCharactor) {
            [self.displayString replaceCharactersInRange:NSMakeRange([self.displayString length]-1, 1) withString:self.maskString];
            textField.text = self.displayString;
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (NSString *)getContent {
    NSString *string = [NSString stringWithString:self.contentString];
    return string;
}

@end
