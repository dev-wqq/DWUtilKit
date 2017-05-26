//
//  NSObject+DWCrash.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/5/25.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "NSObject+DWCrash.h"
#import <objc/runtime.h>

@implementation NSObject (DWCrash)

+ (BOOL)dwcrash_swizzleInstanceMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector {
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

+ (BOOL)dwcrash_swizzleClassMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector {
    return [object_getClass((id)self) dwcrash_swizzleInstanceMethod:originalSelector withMethod:swizzledSelector];
}


@end
