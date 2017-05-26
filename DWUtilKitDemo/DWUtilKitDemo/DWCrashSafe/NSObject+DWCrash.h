//
//  NSObject+DWCrash.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/5/25.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (DWCrash)

/**
 exchange instance method
 */
+ (BOOL)dwcrash_swizzleInstanceMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector;

/**
 exchange class method
 */
+ (BOOL)dwcrash_swizzleClassMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector;

@end

