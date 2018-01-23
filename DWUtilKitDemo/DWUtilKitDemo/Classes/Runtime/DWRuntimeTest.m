//
//  DWRuntimeTest.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/9/3.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DWRuntimeTest.h"


/*
 clang -rewrite-objc DWRuntime.m (使用clang重写为cpp代码)
 */

@interface DWRuntime: NSObject

@end

@implementation DWRuntime

- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"call [self class] %@", NSStringFromClass([self class]));
        NSLog(@"call [super class] %@", NSStringFromClass([super class]));
    }
    return self;
}


@end

@interface DWRuntimeTest : DWRuntime {
    int age;
    NSString *name;
}

- (void)test;
+ (void)test;

@end

@implementation DWRuntimeTest

- (void)test {
    printf("instance test ~");
}

+ (void)test {
    printf("class test ~");
}

@end
