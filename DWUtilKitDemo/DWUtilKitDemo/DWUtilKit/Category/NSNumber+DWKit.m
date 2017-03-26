//
//  NSNumber+DWKit.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/15.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "NSNumber+DWKit.h"

@implementation NSNumber (DWKit)

- (NSString *)dw_stringWithDigit:(int)digit {
    return [self dw_stringWithDigit:digit rounded:NO];
}

- (NSString *)dw_stringWithDigit:(int)digit rounded:(BOOL)rounded {
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithDecimal:[self decimalValue]];
    return [decNumber dw_stringWithDigit:digit rounded:rounded];
}

@end

@implementation NSDecimalNumber (DWKit)

- (NSString *)dw_stringWithDigit:(int)digit {
    return [self dw_stringWithDigit:digit rounded:NO];
}

- (NSString *)dw_stringWithDigit:(int)digit rounded:(BOOL)rounded {
    NSRoundingMode roundingMode = rounded ? NSRoundPlain:NSRoundDown;
    NSDecimalNumberHandler *hander = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode scale:digit raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *decimalNum = [self decimalNumberByRoundingAccordingToBehavior:hander];
    NSString *str = [decimalNum stringValue];
    if (digit == 0) {
        return str;
    }
    // [decimalNum stringValue] 会省略小数点后面的0，包括没有没有小数点的数字，所以没有强制保留小数位数
    // 这里要在后面补上0*，或者.0*
    NSRange rangeFraction = [str rangeOfString:@"."];
    NSUInteger integerLen = 0;
    NSUInteger fractionLen = 0;
    if (rangeFraction.location == NSNotFound) {
        integerLen = [str length];
        fractionLen = 0;
    } else {
        integerLen = rangeFraction.location;
        fractionLen = [str length]-integerLen-1;
    }
    int paddingZero = (int)digit - (int)fractionLen;
    NSAssert(paddingZero >= 0, @"error");
    if (paddingZero == 0) {
        return str;
    } else if (paddingZero > 0) {
        if (rangeFraction.location == NSNotFound) {
            str = [str stringByAppendingString:@"."];
        }
        str = [str stringByPaddingToLength:[str length]+paddingZero withString:@"0" startingAtIndex:0];
    } else {
        int pos = (int)[str length] + paddingZero;
        int len = -paddingZero;
        NSRange rangeReplace = NSMakeRange(pos, len);
        str = [str stringByReplacingCharactersInRange:rangeReplace withString:@""];
    }
    return str;
}

@end
