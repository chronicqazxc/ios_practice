//
//  Fraction.m
//  CalculatorDemo
//
//  Created by Wayne on 1/4/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "Fraction.h"

@implementation Fraction

-(void) setTo: (int) n over: (int) d{
    _numerator = n;
    _denominator = d;
}

-(void) print{
    NSLog(@"%i/%i", _numerator, _denominator);
}

-(double) convertToNum{
    if (_denominator != 0)
        return (double) _numerator / _denominator;
    else
        return NAN;
}

-(NSString *) convertToString{
    if (_numerator == _denominator){
        if (_numerator == 0){
            return @"0";
        }else{
            return @"1";
        }
    }else if(_denominator == 1){
        return [NSString stringWithFormat: @"%i", _numerator];
    }else{
        return [NSString stringWithFormat: @"%i/%i",_numerator, _denominator];
    }
}

// add a Fraction to the receiver
-(Fraction *) add: (Fraction *) f{
    // To add two fractions:
    
    // a/b + c/d = ((a * d) + (b * c)) / (b * d)
    
    // result will store the result of the addtion
    
    Fraction *result = [[Fraction alloc] init];
    result.numerator = _numerator * f.denominator + _denominator * f.numerator;
    result.denominator = _denominator * f.denominator;
    
    [result reduce];
    return result;
}

-(Fraction *) subtract: (Fraction *) f{
    // To sub two fractions;
    
    // a/b - c/d = ((a*b) - (b*c)) / (b*d)
    
    Fraction *result = [[Fraction alloc] init];
    result.numerator = _numerator * f.denominator - _denominator * f.numerator;
    result.denominator = _denominator * f.denominator;
    
    [result reduce];
    return result;
}

-(Fraction *) multiply: (Fraction *) f{
    Fraction *result = [[Fraction alloc] init];
    result.numerator = _numerator * f.numerator;
    result.denominator = _denominator * f.denominator;
    
    [result reduce];
    return result;
}

-(Fraction *) divide: (Fraction *) f{
    Fraction *result = [[Fraction alloc] init];
    
    result.numerator = _numerator * f.denominator;
    result.denominator = _denominator * f.numerator;
    
    [result reduce];
    return result;
}

-(void) reduce{
    int u = _numerator;
    int v = _denominator;
    int temp;
    
    if (u == 0)
        return;
    else if (u < 0)
        u = -u;
    
    while (v != 0){
        temp = u % v;
        u = v;
        v = temp;
    }
    
    _numerator /= u;
    _denominator /= u;
}
@end
