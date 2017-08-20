//
//  NSObject+DWKit.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/15.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "NSObject+DWKit.h"
#import <objc/runtime.h>

@implementation NSObject (DWKit)

#pragma mark - Json

+ (id)dw_jsonWithData:(NSData *)data {
    NSError *error;
    id serial = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"Error: NSData parsing json error %@",error.description);
        return nil;
    }
    return serial;
}

+ (id)dw_jsonWithString:(NSString *)string {
    NSError *error;
    id serial = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"Error: NSString parsing json error %@",error.description);
        return nil;
    }
    return serial;
}

+ (NSData *)dw_dataWithJson:(id)json {
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"Error: json parsing data error %@",error.description);
        return nil;
    }
    return data;
}

+ (NSString *)dw_stringWithJson:(id)json {
    NSData *data = [self dw_dataWithJson:json];
    if (!data) {
        return nil;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

#pragma mark - swizzle method

+ (BOOL)dw_swizzleInstanceMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector {
    // http://stackoverflow.com/questions/34542316/does-method-load-need-to-call-super-load
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    if (!originalMethod || !swizzledMethod) {
        return NO;
    }
    
    BOOL didAddMethod = class_addMethod(self,originalSelector,method_getImplementation(swizzledMethod),method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    return YES;
}

+ (BOOL)dw_swizzleClassMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector {
    return [object_getClass((id)self) dw_swizzleInstanceMethod:originalSelector withMethod:swizzledSelector];
}


@end
