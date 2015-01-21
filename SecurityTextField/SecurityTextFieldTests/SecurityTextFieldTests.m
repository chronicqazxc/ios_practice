//
//  SecurityTextFieldTests.m
//  SecurityTextFieldTests
//
//  Created by Wayne on 1/6/15.
//  Copyright (c) 2015 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface SecurityTextFieldTests : XCTestCase

@end

@implementation SecurityTextFieldTests

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

- (void)testReplaceString {
    NSMutableString *string = [NSMutableString stringWithString:@"123"];
    for (NSUInteger i=0; i<[string length]; i++) {
        [string replaceCharactersInRange:NSMakeRange(i,1) withString:@"X"];
    }
    NSLog(@"string: %@",string);
    XCTAssertTrue([string isEqualToString:@"XXX"]);
}

@end
