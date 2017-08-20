//
//  NSString+DWKit.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/15.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (DWKit)

#pragma mark - url encode and decode

/// url encode a string in UTF-8.
- (NSString *)dw_urlEncodeString;

/// url decode a string in UTF-8.
- (NSString *)dw_urlDecodeString;

#pragma mark - drawing

/// @return the width of the string if it were to be rendered with the specified font on a single line.
- (CGSize)dw_suggestSizeWithFont:(UIFont *)font NS_AVAILABLE_IOS(7.0);

/// @return the width of the string if it were rendered with the specified constraints.
- (CGFloat)dw_suggestWidthWithFont:(UIFont *)font height:(CGFloat)height NS_AVAILABLE_IOS(7.0);

/// @return the height of the string if it were rendered with the specified constraints.
- (CGFloat)dw_suggestHeightWithFont:(UIFont *)font width:(CGFloat)width NS_AVAILABLE_IOS(7.0);

#pragma mark - emoji

/// @return the string can show system enoji.
- (NSString *)dw_showSystemEmoji;

#pragma mark - util

/// @return a new UUID NSString eg:3E49C12A-1FB1-4646-B1C2-57EB34F77C27.
+ (NSString *)dw_stringWithUUID;

/// @"上海" --> @"shang hai"
- (NSString *)dw_transformToPinyin;

/// trim blank character (space and new line) in head and tail.
- (NSString *)dw_stringByTrimSpaceAndNewLine;

/// trim last trival zero. if format error return @"" eg: 100 -> 100; 0.010 -> 0.01;
- (NSString *)dw_stringByTrimLastTrivalZero;

/// cut the decimal point dwter digit and not rounded eg: digit = 3 10.0012 -> 10.001
- (NSString *)dw_stringWithDigit:(int)digit;
- (NSString *)dw_stringWithDigit:(int)digit rounded:(BOOL)rounded;

/// nil, @"", @"  ", @"\n" will return NO; otherwise return YES.
- (BOOL)dw_isNotBlank;

/// @return YES if contained str.
- (BOOL)dw_containsString:(NSString *)str;

/// @return YES if contined set.
- (BOOL)dw_containsCharacter:(NSCharacterSet *)set;

/// @return YES if all digit ,otherwise NO
- (BOOL)dw_isAllDigit;

/// @return YES if digit or point , otherwise NO
- (BOOL)dw_isAllDigitOrPoint;

/// @return NSMakeRange(0, self.length).
- (NSRange)dw_rangeOfAll;

/// @return an NSData using UTF-8 edcoding
- (NSData *)dw_dataValue;

#pragma mark - formatter

/// eg: xx,xx --> "xx" "xx"  xx --> "xx" 
- (NSString *)dw_stringFormatterStyle;

#pragma mark - regex

- (BOOL)dw_isValidEmail;
- (BOOL)dw_isValidQQ;
- (BOOL)dw_isValidMobileNumber;
- (BOOL)dw_isValidPhoneNumber;
- (BOOL)dw_isStringAndNumber;

#pragma mark - file path

/// @return document path
+ (NSString *)dw_documentPath;

/// @return library path
+ (NSString *)dw_libraryPath;

/// @return temp path
+ (NSString *)dw_tempPath;

#pragma mark - elementary arithmetic
/**
 if string.length = 0 return self;
 if self   is not digit(0123456789) or point(.) return nil;
 if string is not digit(0123456789) or point(.) return self;
 */
/// "+"
- (NSString *)dw_stringByAdding:(NSString *)string;
/// "-"
- (NSString *)dw_stringBySubtracting:(NSString *)string;
/// "*"
- (NSString *)dw_stringByMultiplyingBy:(NSString *)string;
/// "/"
- (NSString *)dw_stringByDividingBy:(NSString *)string;

- (NSString *)dw_stringByMultiplyingByPowerOf10:(short)power;


@end
