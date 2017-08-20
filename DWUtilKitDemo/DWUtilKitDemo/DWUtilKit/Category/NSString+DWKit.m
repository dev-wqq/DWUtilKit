//
//  NSString+DWKit.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/15.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "NSString+DWKit.h"
#import "NSNumber+DWKit.h"

typedef NS_ENUM(NSInteger, DWElementaryArithmetic) {
    DWElementaryArithmeticAdding      = 0,
    DWElementaryArithmeticSubtracting = 1,
    DWElementaryArithmeticMultiplying = 2,
    DWElementaryArithmeticDividing    = 3,
};

@implementation NSString (DWKit)

#pragma mark - encode and decode

- (NSString *)dw_urlEncodeString {
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)dw_urlDecodeString {
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - drawing

- (CGSize)dw_suggestSizeWithFont:(UIFont *)font {
    return [self _dw_suggestSizeWithFont:font size:CGSizeMake(MAXFLOAT, MAXFLOAT)];
}

- (CGFloat)dw_suggestWidthWithFont:(UIFont *)font height:(CGFloat)height {
    return [self _dw_suggestSizeWithFont:font size:CGSizeMake(MAXFLOAT, height)].width;
}

- (CGFloat)dw_suggestHeightWithFont:(UIFont *)font width:(CGFloat)width {
    return [self _dw_suggestSizeWithFont:font size:CGSizeMake(width, MAXFLOAT)].height;
}

- (CGSize)_dw_suggestSizeWithFont:(UIFont *)font size:(CGSize)size {
    NSDictionary *attr = @{NSFontAttributeName:font};
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine attributes:attr context:nil];
    return rect.size;
}

#pragma mark - emoji

- (NSString *)dw_showSystemEmoji {
    NSString *str = [NSString stringWithCString:[self cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    return str;
}

#pragma mark - util

+ (NSString *)dw_stringWithUUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}

- (NSString *)dw_transformToPinyin {
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return [mutableString stringByReplacingOccurrencesOfString:@"'" withString:@""];
}

- (NSString *)dw_stringByTrimSpaceAndNewLine {
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:characterSet];
}

- (NSString *)dw_stringByTrimLastTrivalZero {
    NSRange range = [self rangeOfString:@"."];
    if (range.location == NSNotFound) {
        return [self copy];
    } else {
        // discover '.'
        NSRange rangeTrim = NSMakeRange(NSNotFound, 0);
        for (NSInteger i = [self length]-1; i > range.location; --i) {
            if ([self characterAtIndex:i] == '0') {
                rangeTrim.location = i;
                ++rangeTrim.length;
            } else {
                break;
            }
        }
        if (rangeTrim.location != NSNotFound) {
            NSRange subRange = NSMakeRange(0, [self length] - rangeTrim.length);
            NSString *subStr = [self substringWithRange:subRange];
            if ([subStr characterAtIndex:[subStr length]-1] == '.') {
                subStr = [subStr substringToIndex:subRange.length-1];
            }
            return subStr;
        } else {
            return [self copy];
        }
    }
}

- (NSString *)dw_stringWithDigit:(int)digit {
    return [self dw_stringWithDigit:digit rounded:NO];
}

- (NSString *)dw_stringWithDigit:(int)digit rounded:(BOOL)rounded {
    if (self.length == 0) {
        return @"";
    }
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:self];
    return [decNumber dw_stringWithDigit:digit rounded:rounded];
}

- (BOOL)dw_isNotBlank {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; i++) {
        unichar c = [self characterAtIndex:i];
        if (![set characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)dw_containsString:(NSString *)str {
    if (str == nil) {
        return NO;
    }
    return [self rangeOfString:str].location != NSNotFound;
}

- (BOOL)dw_containsCharacter:(NSCharacterSet *)set {
    if (set == nil) {
        return NO;
    }
    return [self rangeOfCharacterFromSet:set].location != NSNotFound;
}

- (BOOL)dw_isAllDigit {
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filterString = [[self componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
    return [self isEqualToString:filterString];
}

- (BOOL)dw_isAllDigitOrPoint {
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSString *filterString = [[self componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
    return [self isEqualToString:filterString];
}

- (NSRange)dw_rangeOfAll {
    return NSMakeRange(0, self.length);
}

- (NSData *)dw_dataValue {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - formatter

- (NSString *)dw_stringFormatterStyle {
    if (self == nil || self.length == 0) {
        return @"";
    }
    NSArray *arr = [self componentsSeparatedByString:@","];
    NSMutableString *mStr = [NSMutableString string];
    for (int i = 0; i < arr.count; i++) {
        NSString *str = arr[i];
        [mStr appendFormat:@"\"%@\" ",str];
    }
    return mStr;
}

#pragma mark - regex

- (BOOL)dw_isValidEmail {
    if (self == nil || self.length == 0) {
        return NO;
    }
    NSString *emailRegex = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)dw_isValidQQ {
    if (self == nil || self.length == 0) {
        return NO;
    }
    NSString *qqRegex = @"[1-9][0-9]{4,}";
    NSPredicate *qqTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", qqRegex];
    return [qqTest evaluateWithObject:self];
}

- (BOOL)dw_isValidMobileNumber {
    if (self == nil || self.length == 0) {
        return NO;
    }
    NSString *mobileRegex =@"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobileRegex];
    return [mobileTest evaluateWithObject:self];
}

- (BOOL)dw_isValidPhoneNumber {
    if (self == nil || self.length == 0) {
        return NO;
    }
    NSString *phoneNumberRegex = @"(^[0-9]+$)";
    NSPredicate *phoneNumberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneNumberRegex];
    return [phoneNumberTest evaluateWithObject:phoneNumberRegex];
}

- (BOOL)dw_isStringAndNumber {
    if (self == nil || self.length == 0) {
        return NO;
    }
    NSString *stringNumberRegex = @"(^[A-Za-z0-9]+$)";
    NSPredicate * stringNumberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringNumberRegex];
    return [stringNumberTest evaluateWithObject:stringNumberRegex];
}

#pragma mark - file path

+ (NSString *)dw_documentPath {
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return array.firstObject;
}

+ (NSString *)dw_libraryPath {
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return array.firstObject;
}

+ (NSString *)dw_tempPath {
    return NSTemporaryDirectory();
}

#pragma mark - elementary arithmetic

- (NSString *)dw_stringByArithmeticString:(NSString *)string style:(DWElementaryArithmetic)style {
    if (string.length == 0) {
        return self;
    }
    if (![self dw_isAllDigitOrPoint]) {
        NSAssert(NO, @"%@ format is not correct",self);
        return nil;
    }
    if (![string dw_isAllDigitOrPoint]) {
        NSAssert(NO, @"%@ format is not correct",string);
        return self;
    }
    NSDecimalNumber *decimalNumber = [[NSDecimalNumber alloc] initWithString:self];
    NSDecimalNumber *byDecimalNumber = [[NSDecimalNumber alloc] initWithString:string];
    NSDecimalNumber *result = nil;
    switch (style) {
        case DWElementaryArithmeticAdding:
            result = [decimalNumber decimalNumberByAdding:byDecimalNumber];
            break;
        case DWElementaryArithmeticSubtracting:
            result = [decimalNumber decimalNumberBySubtracting:byDecimalNumber];
            break;
        case DWElementaryArithmeticMultiplying:
            result = [decimalNumber decimalNumberByMultiplyingBy:byDecimalNumber];
            break;
        case DWElementaryArithmeticDividing:
            if (byDecimalNumber.doubleValue == 0) {
                NSAssert(NO, @"DividingBy can not equal zero");
                break;
            }
            result = [decimalNumber decimalNumberByDividingBy:byDecimalNumber];
            break;
    }
    return result.stringValue;
}

- (NSString *)dw_stringByAdding:(NSString *)string {
    return [self dw_stringByArithmeticString:string style:DWElementaryArithmeticAdding];
}

- (NSString *)dw_stringBySubtracting:(NSString *)string {
    return [self dw_stringByArithmeticString:string style:DWElementaryArithmeticSubtracting];
}

- (NSString *)dw_stringByMultiplyingBy:(NSString *)string {
    return [self dw_stringByArithmeticString:string style:DWElementaryArithmeticMultiplying];
}

- (NSString *)dw_stringByDividingBy:(NSString *)string {
    return [self dw_stringByArithmeticString:string style:DWElementaryArithmeticDividing];
}

- (NSString *)dw_stringByMultiplyingByPowerOf10:(short)power {
    if (![self dw_isAllDigitOrPoint]) {
        NSAssert(NO, @"%@ format is not correct",self);
        return nil;
    }
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:self];
    return [decimalNumber decimalNumberByMultiplyingByPowerOf10:power].stringValue;
}

@end
