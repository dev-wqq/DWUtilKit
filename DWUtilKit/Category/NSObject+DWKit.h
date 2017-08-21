//
//  NSObject+DWKit.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/15.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DWKit)

#pragma mark - Json

+ (id)dw_jsonWithData:(NSData *)data;
+ (id)dw_jsonWithString:(NSString *)data;

+ (NSData *)dw_dataWithJson:(id)json;
+ (NSString *)dw_stringWithJson:(id)json;

#pragma mark - swizzle method

/**
 exchange instance method
 */
+ (BOOL)dw_swizzleInstanceMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector;

/**
 exchange class method
 */
+ (BOOL)dw_swizzleClassMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector;

@end
