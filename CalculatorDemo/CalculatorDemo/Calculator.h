//
//  Calculator.h
//  CalculatorDemo
//
//  Created by Wayne on 1/4/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fraction.h"

@interface Calculator : NSObject

@property (strong, nonatomic) Fraction *operand1, *operand2, *accumulator;

-(Fraction *) performOperation: (char) op;
-(void) clear;

@end
