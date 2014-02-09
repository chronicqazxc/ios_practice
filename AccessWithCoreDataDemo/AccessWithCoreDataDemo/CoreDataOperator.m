//
//  CoreDataOperator.m
//  CoreDataTest3
//
//  Created by Wayne on 2/9/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "CoreDataOperator.h"
#import "Customer.h"
#import "Car.h"

@interface CoreDataOperator(){
    Customer *customer;
    Car *car;
    
    NSFetchRequest *fetchRequest;
    NSMutableDictionary *individualCustomersDictionary;
}

@end
@implementation CoreDataOperator

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)addCustomerWithId:(NSString *)customerId andName:(NSString *)ustomerName andPlate:(NSString *)carPlate andImage:(UIImage *)image{
    // Whether the customer already exist
    fetchRequest = [[self managedObjectModel] fetchRequestFromTemplateWithName:@"FetchFullID" substitutionVariables:[NSDictionary dictionaryWithObject:customerId forKey:@"ID"]];
    
    NSArray *customerResult = [[self managedObjectContext] executeFetchRequest:fetchRequest error:nil];
    
    if([customerResult count] > 0){
        customer = customerResult[0];
    }else{
        customer = [NSEntityDescription insertNewObjectForEntityForName:@"Customer" inManagedObjectContext: [self managedObjectContext]];
        customer.customerId = customerId;
        customer.customerName = ustomerName;
    }
    
    car = [NSEntityDescription insertNewObjectForEntityForName:@"Car" inManagedObjectContext:self.managedObjectContext];
    car.plate = carPlate;
    car.image = image;
    
    [customer addOwnObject:car];
    
    return [[self managedObjectContext] save:nil];
}

-(NSMutableDictionary *)searchByDetermind:(int)determind withCondition:(NSString *)condition{
    NSString *templateName;
    NSString *templateKey;
    NSArray *cars;
    NSArray *customers;
    NSArray *individualCustomers;
    NSMutableArray *carsBelongCustomer;
    
    fetchRequest = [[NSFetchRequest alloc]init];
    cars = [[NSArray alloc]init];
    customers = [[NSArray alloc]init];
    individualCustomers = [[NSArray alloc]init];
    individualCustomersDictionary = [[NSMutableDictionary alloc]init];
    
    switch(determind){
        case 1:
            templateName = @"FetchCustomerByID";
            templateKey  = @"CUSTOMERID";
            fetchRequest = [[self managedObjectModel] fetchRequestFromTemplateWithName:templateName substitutionVariables:[NSDictionary dictionaryWithObject:condition forKey:templateKey]];
            break;
        case 2:
            templateName = @"FetchCustomerByName";
            templateKey  = @"CUSTOMERNAME";
            fetchRequest = [[self managedObjectModel] fetchRequestFromTemplateWithName:templateName substitutionVariables:[NSDictionary dictionaryWithObject:condition forKey:templateKey]];
            break;
        case 3:
            templateName = @"FetchCar";
            templateKey  = @"PLATE";
            fetchRequest = [[self managedObjectModel] fetchRequestFromTemplateWithName:templateName substitutionVariables:[NSDictionary dictionaryWithObject:condition forKey:templateKey]];
            break;
    }
    
//    NSEntityDescription *customerNntity = [NSEntityDescription entityForName:@"Customer" inManagedObjectContext:self.managedObjectContext];
//    [fetchRequest setEntity:customerNntity];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"customerId like '00*'"];
//    [fetchRequest setPredicate:predicate];
//    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"customerId" ascending:1];
//    NSArray *sortArray = [[NSArray alloc]initWithObjects:sort,nil];
//    [fetchRequest setSortDescriptors:sortArray];
    
    individualCustomers = [[self managedObjectContext] executeFetchRequest:fetchRequest error:nil];
    if(determind != 3){
        for(Customer *fetchCustomer in individualCustomers){
            NSSet *set = fetchCustomer.own;
            cars = [set allObjects];
            carsBelongCustomer = [[NSMutableArray alloc]init];
            for(Car *fetchCar in cars)
                [carsBelongCustomer addObject:fetchCar];
            [individualCustomersDictionary setObject:@[fetchCustomer,carsBelongCustomer] forKey:fetchCustomer.customerId];
        }
    }else if(determind == 3){
        for(Car *fetchCar in individualCustomers){
            customer = (Customer *)fetchCar.belongTo;
            carsBelongCustomer = [[NSMutableArray alloc]init];
            [carsBelongCustomer addObject:fetchCar];
            [individualCustomersDictionary setObject:@[customer,carsBelongCustomer] forKey:customer.customerId];
        }
    }
    return individualCustomersDictionary;
}

- (void)deleteCarByPlate:(NSString *)plate{
    fetchRequest = [self.managedObjectModel fetchRequestFromTemplateWithName:@"FetchForDeleteCar" substitutionVariables:[NSDictionary dictionaryWithObject:plate forKey:@"PLATE"]];
    NSArray *fetchResult = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    for(Car *deleteCar in fetchResult)
        [self.managedObjectContext deleteObject:deleteCar];
    [self.managedObjectContext save:nil];
}

- (NSArray *)fetchAllCustomers{
    fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Customer" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

- (void)deleteCustomer:(NSString *)customerId{
    fetchRequest = [self.managedObjectModel fetchRequestFromTemplateWithName:@"FetchForDeleteCustomer" substitutionVariables:[NSDictionary dictionaryWithObject:customerId forKey:@"CUSTOMERID"]];
    NSArray *fetchResult = [[self managedObjectContext] executeFetchRequest:fetchRequest error:nil];
    for(Customer *deleteCustomer in fetchResult)
        [self.managedObjectContext deleteObject:deleteCustomer];
    [self.managedObjectContext save:nil];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Database" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Database.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
