//
//  NSDictionary+DWCrash.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/5/22.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "NSDictionary+DWCrash.h"
#import "NSObject+DWCrash.h"

@implementation NSDictionary (DWCrash)

#ifndef DWCrashSafeClose

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self dwcrash_swizzleInstanceMethod:@selector(initWithObjects:forKeys:count:) withMethod:@selector(dwcrash_initWithObjects:forKeys:count:)];
        [self dwcrash_swizzleClassMethod:@selector(dictionaryWithObjects:forKeys:count:) withMethod:@selector(dwcrash_dictionaryWithObjects:forKeys:count:)];
    });
}

+ (instancetype)dwcrash_dictionaryWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger index = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key) {
            continue;
        }
        if (!obj) {
            obj = [NSNull null];
        }
        safeKeys[index] = key;
        safeObjects[index] = obj;
        index++;
     }
    return [self dwcrash_dictionaryWithObjects:safeObjects forKeys:safeKeys count:cnt];
}

- (instancetype)dwcrash_initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger index = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key) {
            continue;
        }
        if (!obj) {
            obj = [NSNull null];
        }
        safeKeys[index] = key;
        safeObjects[index] = obj;
        index++;
    }
    return [self dwcrash_initWithObjects:safeObjects forKeys:safeKeys count:cnt];
}

#endif

@end

@implementation NSMutableDictionary (DWCrash)

#ifndef DWCrashSafeClose

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // -[__NSDictionaryM setObject:forKey:]
        Class class = NSClassFromString(@"__NSDictionaryM");
        [class dwcrash_swizzleInstanceMethod:@selector(setObject:forKey:) withMethod:@selector(dwcrash_setObject:forKey:)];
        [class dwcrash_swizzleInstanceMethod:@selector(setObject:forKeyedSubscript:) withMethod:@selector(dwcrash_setObject:forKeyedSubscript:)];
        [class dwcrash_swizzleInstanceMethod:@selector(removeObjectForKey:) withMethod:@selector(dwcrash_removeObjectForKey:)];
    });
}

- (void)dwcrash_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!aKey) {
        return;
    }
    if (!anObject) {
        anObject = [NSNull null];
    }
    [self dwcrash_setObject:anObject forKey:aKey];
}

- (void)dwcrash_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    if (!key) {
        return;
    }
    if (!obj) {
        obj = [NSNull null];
    }
    [self dwcrash_setObject:obj forKeyedSubscript:key];
}

- (void)dwcrash_removeObjectForKey:(id)aKey {
    if (!aKey) {
        return;
    }
    [self dwcrash_removeObjectForKey:aKey];
}

#endif

@end
