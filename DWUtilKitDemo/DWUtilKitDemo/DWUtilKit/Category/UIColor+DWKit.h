//
//  UIColor+DWKit.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/12.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (DWKit)

/** 
 from 0 ~ INT_MAX, alpha default is 1.0
 */
+ (UIColor *)dw_colorWithRed:(int)red green:(int)green blue:(int)blue;
+ (UIColor *)dw_colorWithRed:(int)red green:(int)green blue:(int)blue alpha:(CGFloat)alpha;

/**
 String should be 6 or 8 characters
 */
+ (UIColor *)dw_opaqueColorWithHexString:(NSString *)stringToConvert;
+ (UIColor *)dw_colorWithHexString:(NSString *)stringToConvert AndAlpha:(CGFloat)alpha;

/**
 @return the color's RGB value as hex string (lowercase). such as @"00aaff"
 */
- (NSString *)dw_hexString;

/**
 @return the color's RGBA value as hex string (lowercase). such as @"00aaffff"
 */
- (NSString *)dw_hexStringWithAlpha;

@end
