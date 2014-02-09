//
//  Customer.h
//  AccessWithCoreDataDemo
//
//  Created by Wayne on 2/9/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Car;

@interface Customer : NSManagedObject

@property (nonatomic, retain) NSString * customerId;
@property (nonatomic, retain) NSString * customerName;
@property (nonatomic, retain) NSSet *own;
@end

@interface Customer (CoreDataGeneratedAccessors)

- (void)addOwnObject:(Car *)value;
- (void)removeOwnObject:(Car *)value;
- (void)addOwn:(NSSet *)values;
- (void)removeOwn:(NSSet *)values;

@end
