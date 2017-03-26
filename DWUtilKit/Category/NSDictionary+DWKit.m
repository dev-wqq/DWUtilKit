//
//  NSDictionary+DWKit.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/12.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "NSDictionary+DWKit.h"

@implementation NSDictionary (DWKit)

- (id)dw_objectNotNullForKey:(NSString *)key {
    id obj = self[key];
    if (obj == [NSNull null]) {
        return nil;
    }
    return obj;
}

- (NSString *)dw_stringForKey:(NSString *)key {
    id obj = self[key];
    if (![obj isKindOfClass:[NSString class]]) {
        return nil;
    }
    return obj;
}

- (NSNumber *)dw_numberForKey:(NSString *)key {
    id obj = self[key];
    if (![obj isKindOfClass:[NSNumber class]]) {
        return nil;
    }
    return obj;
}

- (NSArray *)dw_arrayForKey:(NSString *)key {
    id obj = self[key];
    if (![obj isKindOfClass:[NSArray class]]) {
        return nil;
    }
    return obj;
}

- (NSDictionary *)dw_dictionaryForKey:(NSString *)key {
    id obj = self[key];
    if (![obj isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return obj;
}

- (NSString *)dw_stringAllowNSNumberForKey:(NSString *)key {
    id obj = self[key];
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    }
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj description];
    }
    return nil;
}


- (id)dw_objectForKeyPath:(NSString *)keyPath {
    return [self dw_objectForKeyPath:keyPath separator:@"."];
}

- (id)dw_objectForKeyPath:(NSString *)keyPath separator:(NSString *)separator {
    NSArray *array = [keyPath componentsSeparatedByString:separator];
    if ([array count] == 0) return nil;
    id value = self;
    for (NSString *key in array) {
        value = value[key];
        if (!value || value == [NSNull null]) {
            value = nil;
            break;
        }
    }
    return value;
}

@end

@implementation NSMutableDictionary (DWKit)

- (void)dw_setObject:(id)object forKeyPath:(NSString *)keyPath {
    return [self dw_setObject:object forKeyPath:keyPath separator:@"."];
}

- (void)dw_setObject:(id)object forKeyPath:(NSString *)keyPath separator:(NSString *)separator {
    NSArray *array = [keyPath componentsSeparatedByString:separator];
    if ([array count] == 0) return;
    __block NSMutableDictionary *mutableDictionary = self;
    __block BOOL error = NO;
    [array enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        if (array.count > idx+1) {
            NSMutableDictionary *mTmpDict = mutableDictionary[key];
            if (mTmpDict && ![mTmpDict isKindOfClass:[NSMutableDictionary class]]) {
                *stop = YES;
                error = YES;
                return;
            }
            if (!mTmpDict) {
                mTmpDict = [NSMutableDictionary dictionary];
            }
            [mutableDictionary setObject:mTmpDict forKey:key];
            mutableDictionary = mTmpDict;
        } else {
            NSAssert([mutableDictionary isKindOfClass:[NSMutableDictionary class]], @"logic error");
            [mutableDictionary setObject:object forKey:key];
        }
    }];
}

@end
