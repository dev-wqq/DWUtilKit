//
//  DWSettingUtil.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/4/6.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWSettingUtil : NSObject

+ (NSObject *)dw_getValueForkey:(NSObject *)key;
+ (void)dw_setValueForkey:(NSObject *)data forKey:(NSObject *)key;

+ (BOOL)dw_getBoolValueForkey:(NSString *)key;
+ (void)dw_setBoolValueForkey:(BOOL)data forKey:(NSString *)key;

+ (void)dw_setIntValue:(NSInteger)value forKey:(NSString *)key;
+ (NSInteger)dw_getIntValueForKey:(NSString *)key;

+ (void)dw_setArrayValue:(NSArray *)array forKey:(NSString *)key;
+ (NSArray *)dw_getArrayForKey:(NSString *)key;

+ (void)dw_setStringValue:(NSString *)value forKey:(NSString *)key;
+ (NSString *)dw_getStringValueForKey:(NSString *)key;

+ (void)dw_deleteValueForkey:(NSString *)key;
+ (void)dw_synchronize;

@end
