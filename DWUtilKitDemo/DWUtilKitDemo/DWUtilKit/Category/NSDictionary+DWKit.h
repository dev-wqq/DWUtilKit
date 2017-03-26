//
//  NSDictionary+DWKit.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/12.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (DWKit)

- (id)dw_objectNotNullForKey:(NSString *)key;
- (NSString *)dw_stringForKey:(NSString *)key;
- (NSNumber *)dw_numberForKey:(NSString *)key;
- (NSArray *)dw_arrayForKey:(NSString *)key;
- (NSDictionary *)dw_dictionaryForKey:(NSString *)key;
- (NSString *)dw_stringAllowNSNumberForKey:(NSString *)key;

/**
 *  call - (id)dw_objectForKeyPath:(NSString *)keyPath separator:(NSString *)separator with separator '.'
 */
- (id)dw_objectForKeyPath:(NSString *)keyPath;
- (id)dw_objectForKeyPath:(NSString *)keyPath separator:(NSString *)separator;

@end

@interface NSMutableDictionary (DWKit)

/**
    call `- (void)dw_setObject:(id)object forKeyPath:(NSString *)keyPath separator:(NSString *)separator` with
    separator '.'
 */
- (void)dw_setObject:(id)object forKeyPath:(NSString *)keyPath;
- (void)dw_setObject:(id)object forKeyPath:(NSString *)keyPath separator:(NSString *)separator;

@end
