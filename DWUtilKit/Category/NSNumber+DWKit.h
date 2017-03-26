//
//  NSNumber+DWKit.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/15.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (DWKit)

/// cut the decimal point after digit and not rounded eg: digit = 3 10.0012 -> 10.001
- (NSString *)dw_stringWithDigit:(int)digit;
- (NSString *)dw_stringWithDigit:(int)digit rounded:(BOOL)rounded;

@end

@interface NSDecimalNumber (DWKit)

@end

