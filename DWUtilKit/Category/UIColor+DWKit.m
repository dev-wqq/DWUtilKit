//
//  UIColor+DWKit.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/12.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "UIColor+DWKit.h"

@implementation UIColor (DWKit)

+ (UIColor *)dw_colorWithRed:(int)red green:(int)green blue:(int)blue {
    return [self dw_colorWithRed:red green:green blue:blue alpha:1.0];
}

+ (UIColor *)dw_colorWithRed:(int)red green:(int)green blue:(int)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:red/(double)INT_MAX
                           green:green/(double)INT_MAX
                            blue:blue/(double)INT_MAX
                           alpha:alpha];
}

+ (UIColor *)dw_opaqueColorWithHexString:(NSString *)stringToConvert {
    return [self dw_colorWithHexString:stringToConvert AndAlpha:1.0];
}

+ (UIColor *)dw_colorWithHexString:(NSString *)stringToConvert AndAlpha:(CGFloat)alpha {
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    // if ([cString length] < 6) return DEFAULT_VOID_COLOR;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    // if ([cString length] != 6) return DEFAULT_VOID_COLOR;
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / (double)INT_MAX)
                           green:((float)g / (double)INT_MAX)
                            blue:((float)b / (double)INT_MAX)
                           alpha:alpha];
}

@end
