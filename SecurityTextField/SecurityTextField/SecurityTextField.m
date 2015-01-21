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
@property (strong, nonatomic) NSTimer *maskTimer;
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
    [self.maskTimer invalidate];
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
            if (range.location == self.showRange.location && [self.displayString length] > 0) {
                [self.displayString deleteCharactersInRange:NSMakeRange(range.location-1, 1)];
                [self.displayString appendString:[NSString stringWithString:self.maskString]];
            }
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
    self.maskTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timeToMask:) userInfo:nil repeats:NO];
    return NO;
}

- (void)timeToMask:(NSTimer *)timer {
    if ((!self.shouldMaskLastCharactor && [self.text length] < self.textFieldLength) || self.shouldMaskLastCharactor) {
        for (NSUInteger i=0; i<[self.displayString length]; i++) {
            NSRange maskRange = NSMakeRange(i,1);
            if (![self isRange:self.showRange containAnotherRange:maskRange]) {
                [self.displayString replaceCharactersInRange:maskRange withString:self.maskString];
            }
        }
        self.text = self.displayString;
    }
    [timer invalidate];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.maskTimer invalidate];
    if ([textField.text length] > 0) {
        if ((!self.shouldMaskLastCharactor && [textField.text length] < self.textFieldLength) || self.shouldMaskLastCharactor) {
            for (NSUInteger i=0; i<[self.displayString length]; i++) {
                NSRange maskRange = NSMakeRange(i,1);
                if (![self isRange:self.showRange containAnotherRange:maskRange]) {
                    [self.displayString replaceCharactersInRange:maskRange withString:self.maskString];
                }
            }
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

- (void)setText:(NSString *)text {
    [super setText:text];
    
    NSCharacterSet *noDigitalSet = [NSCharacterSet decimalDigitCharacterSet].invertedSet;
    if ([text rangeOfCharacterFromSet:noDigitalSet].location == NSNotFound) {
        self.contentString = [NSMutableString stringWithString:text];
    }
}
@end
