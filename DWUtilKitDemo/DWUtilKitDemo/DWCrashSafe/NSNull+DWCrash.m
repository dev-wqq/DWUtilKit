//
//  NSNull+DWNilSafe.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/5/22.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "NSNull+DWCrash.h"
#import "NSObject+DWCrash.h"

@implementation NSNull (DWCrash)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self dwcrash_swizzleInstanceMethod:@selector(methodSignatureForSelector:) withMethod:@selector(dwcrash_methodSignatureForSelector:)];
        [self dwcrash_swizzleInstanceMethod:@selector(forwardInvocation:) withMethod:@selector(dwcrash_forwardInvocation:)];
    });
}

- (NSMethodSignature *)dwcrash_methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig = [self dwcrash_methodSignatureForSelector:aSelector];
    if (sig) {
        return sig;
    }
    return [NSMethodSignature signatureWithObjCTypes:@encode(void)];
}

- (void)dwcrash_forwardInvocation:(NSInvocation *)anInvocation {
    NSUInteger returnLength = [[anInvocation methodSignature] methodReturnLength];
    if (!returnLength) {
        return;
    }
    char buffer[returnLength];
    memset(buffer, 0, returnLength);
    [anInvocation setReturnValue:buffer];
}

@end
