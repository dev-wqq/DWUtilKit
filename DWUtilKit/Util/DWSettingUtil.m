//
//  DWSettingUtil.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/4/6.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DWSettingUtil.h"

@implementation DWSettingUtil

+ (NSObject *)dw_getValueForkey:(NSString *)key {
    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
    NSObject *retobject = [persistentDefaults objectForKey:key];
    return retobject;
}

+ (void)dw_setValueForkey:(NSObject *)data forKey:(NSString *)key {
    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
    [persistentDefaults setObject:data forKey:key];
}

+ (BOOL)dw_getBoolValueForkey:(NSString *)key {
    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
    BOOL ret = [persistentDefaults boolForKey:key];
    return ret;
}

+ (void)dw_setBoolValueForkey:(BOOL)data forKey:(NSString *)key {
    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
    [persistentDefaults setBool:data forKey:key];
}

+ (void)dw_setIntValue:(NSInteger)value forKey:(NSString *)key {
    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
    [persistentDefaults setInteger:value forKey:key];
}

+ (NSInteger)dw_getIntValueForKey:(NSString *)key {
    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger value = [persistentDefaults integerForKey:key];
    return value;
}

+ (void)dw_setArrayValue:(NSArray *)array forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:key];
}

+ (NSArray *)dw_getArrayForKey:(NSString *)key {
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if ([arr isKindOfClass:[NSArray class]]) {
        return arr;
    } else {
        return nil;
    }
}

+ (void)dw_setStringValue:(NSString *)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

+ (NSString *)dw_getStringValueForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}

+ (void)dw_deleteValueForkey:(NSString *)key {
    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
    [persistentDefaults removeObjectForKey:key];
}

+ (void)dw_synchronize {
    [[NSUserDefaults standardUserDefaults] synchronize];
 }

@end
