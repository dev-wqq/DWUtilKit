//
//  DWUtilTests.m
//  DWUtilTests
//
//  Created by wangqiqi on 2017/5/28.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface DWUtilTests : XCTestCase

@end

@implementation DWUtilTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testArrayZeroElementExample {
    NSArray *arr = [NSArray array];
    NSString *className = NSStringFromClass(arr.class);
    [arr subarrayWithRange:NSMakeRange(1, 2)];
    NSLog(@"zero %@",className);
 
    
    arr = @[@"1"];
    className = NSStringFromClass(arr.class);
    [arr subarrayWithRange:NSMakeRange(2, 2)];
    NSLog(@"zero %@",className);
    
    arr = @[@"1",@"2"];
    className = NSStringFromClass(arr.class);
    [arr subarrayWithRange:NSMakeRange(3, 3)];
    NSLog(@"zero %@",className);
}


@end
