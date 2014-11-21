//
//  ExpandContractTableTests.m
//  ExpandContractTableTests
//
//  Created by Wayne on 11/21/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ExpandContractController.h"

@interface ExpandContractTableTests : XCTestCase

@end

@implementation ExpandContractTableTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testExpandContractDataStructure {
    ExpandContractController *expand = [[ExpandContractController alloc] initWithDelegate:self tableView:[UITableView new]];
    NSMutableArray *dataArray = [NSMutableArray array];
    dataArray = [expand setNumberOfSection:3 dataArray:dataArray];
    dataArray = [expand setNumberOfParent:3 andHeigh:@"10" section:0 dataArray:dataArray];
    dataArray = [expand setNumberOfParent:1 andHeigh:@"10" section:1 dataArray:dataArray];
    dataArray = [expand setNumberOfParent:2 andHeigh:@"10" section:2 dataArray:dataArray];
//    for (int i=0; i<3; i++) {
//        dataArray = [expand setNumberOfChild:@"3" andHeigh:@"10" section:0 withParentIndex:i dataArray:dataArray];
//    }
    dataArray = [expand setNumberOfChild:@"2" andHeigh:@"10" section:0 withParentIndex:0 dataArray:dataArray];
    dataArray = [expand setNumberOfChild:@"0" andHeigh:@"10" section:0 withParentIndex:1 dataArray:dataArray];
    dataArray = [expand setNumberOfChild:@"3" andHeigh:@"10" section:0 withParentIndex:2 dataArray:dataArray];
    
    
    dataArray = [expand setNumberOfChild:@"6" andHeigh:@"10" section:1 withParentIndex:0 dataArray:dataArray];
    
    
    dataArray = [expand setNumberOfChild:@"2" andHeigh:@"10" section:2 withParentIndex:0 dataArray:dataArray];
    dataArray = [expand setNumberOfChild:@"0" andHeigh:@"10" section:2 withParentIndex:1 dataArray:dataArray];
    
    NSLog(@"%@",dataArray);
}

- (void)testJson {
    NSDictionary *jsonDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"1111-2222-3333-4444",@"credit_card",
                             @"03/19",@"expiration",
                             @"123456",@"mobile_id",nil];
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:jsonDic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    // for log
    NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonString);
}
@end
