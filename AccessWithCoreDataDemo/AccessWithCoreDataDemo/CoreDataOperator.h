//
//  CoreDataOperator.h
//  CoreDataTest3
//
//  Created by Wayne on 2/9/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataOperator : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (BOOL)addCustomerWithId:(NSString *)customerId andName:(NSString *)ustomerName andPlate:(NSString *)carPlate andImage:(UIImage *)image;
- (NSMutableDictionary *)searchByDetermind:(int)determind withCondition:(NSString *)condition;
- (void)deleteCarByPlate:(NSString *)plate;
- (NSArray *)fetchAllCustomers;
- (void)deleteCustomer:(NSString *)customerId;
@end
