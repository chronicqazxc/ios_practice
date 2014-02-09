//
//  Car.h
//  AccessWithCoreDataDemo
//
//  Created by Wayne on 2/9/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Customer;

@interface Car : NSManagedObject

@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSString * plate;
@property (nonatomic, retain) Customer *belongTo;

@end
