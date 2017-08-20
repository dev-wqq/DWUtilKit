//
//  DWTestDemo.m
//  Pods
//
//  Created by wangqiqi on 2017/8/7.
//
//

#import "DWTestDemo.h"

@implementation DWTestDemo

+ (instancetype)sharedInstance {
    return [[DWTestDemo alloc] init];
}

- (void)test1 {
    NSLog(@"test demo 1");
}

+ (void)test2 {
    NSLog(@"test demo 2");
}


@end
