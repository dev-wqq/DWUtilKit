//
//  NSObject+DWLogUnicode.m
//  DWUtilKit
//
//  Created by wangqiqi on 2017/3/31.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "NSObject+DWLogUnicode.h"
#import <objc/runtime.h>

@implementation NSObject (DWLogUnicode)

+ (NSString *)logUicode_stringByReplaceUnicode:(NSString *)string {
    // http://stackoverflow.com/questions/21436956/objc-ios-how-to-retrieve-unicode-hex-code-for-character
    NSMutableString *convertedString = [string mutableCopy];
    [convertedString replaceOccurrencesOfString:@"\\U" withString:@"\\u" options:0 range:NSMakeRange(0, convertedString.length)];
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((__bridge CFMutableStringRef)convertedString, NULL, transform, YES);
    return convertedString;
}

+ (BOOL)logUicode_swizzleInstanceMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector {
    // http://stackoverflow.com/questions/34542316/does-method-load-need-to-call-super-load
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    if (!originalMethod || !swizzledMethod) {
        return NO;
    }
    
    BOOL didAddMethod = class_addMethod(self,originalSelector,method_getImplementation(swizzledMethod),method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    return YES;
}

@end

@implementation NSArray (DWLogUnicode)

#ifdef DEBUG

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self logUicode_swizzleInstanceMethod:@selector(description) withMethod:@selector(_logUicode_description)];
        [self logUicode_swizzleInstanceMethod:@selector(descriptionWithLocale:) withMethod:@selector(_logUicode_descriptionWithLocale:)];
        [self logUicode_swizzleInstanceMethod:@selector(descriptionWithLocale:indent:) withMethod:@selector(_logUicode_descriptionWithLocale:indent:)];
    });
}

- (NSString *)_logUicode_description {
    return [NSObject logUicode_stringByReplaceUnicode:[self _logUicode_description]];
}

- (NSString *)_logUicode_descriptionWithLocale:(nullable id)locale {
    return [NSObject logUicode_stringByReplaceUnicode:[self _logUicode_descriptionWithLocale:locale]];
}

- (NSString *)_logUicode_descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    return [NSObject logUicode_stringByReplaceUnicode:[self _logUicode_descriptionWithLocale:locale indent:level]];
}

#endif

@end

@implementation NSDictionary (DWLogUnicode)

#ifdef DEBUG

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self logUicode_swizzleInstanceMethod:@selector(description) withMethod:@selector(_logUicode_description)];
        [self logUicode_swizzleInstanceMethod:@selector(descriptionWithLocale:) withMethod:@selector(_logUicode_descriptionWithLocale:)];
        [self logUicode_swizzleInstanceMethod:@selector(descriptionWithLocale:indent:) withMethod:@selector(_logUicode_descriptionWithLocale:indent:)];
    });
}

- (NSString *)_logUicode_description {
    return [NSObject logUicode_stringByReplaceUnicode:[self _logUicode_description]];
}

- (NSString *)_logUicode_descriptionWithLocale:(nullable id)locale {
    return [NSObject logUicode_stringByReplaceUnicode:[self _logUicode_descriptionWithLocale:locale]];
}

- (NSString *)_logUicode_descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    return [NSObject logUicode_stringByReplaceUnicode:[self _logUicode_descriptionWithLocale:locale indent:level]];
}

#endif

@end

@implementation NSSet (DWLogUnicode)

#ifdef DEBUG

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self logUicode_swizzleInstanceMethod:@selector(description) withMethod:@selector(_logUicode_description)];
        [self logUicode_swizzleInstanceMethod:@selector(descriptionWithLocale:) withMethod:@selector(_logUicode_descriptionWithLocale:)];
        [self logUicode_swizzleInstanceMethod:@selector(descriptionWithLocale:indent:) withMethod:@selector(_logUicode_descriptionWithLocale:indent:)];
    });
}

- (NSString *)_logUicode_description {
    return [NSObject logUicode_stringByReplaceUnicode:[self _logUicode_description]];
}

- (NSString *)_logUicode_descriptionWithLocale:(nullable id)locale {
    return [NSObject logUicode_stringByReplaceUnicode:[self _logUicode_descriptionWithLocale:locale]];
}

- (NSString *)_logUicode_descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    return [NSObject logUicode_stringByReplaceUnicode:[self _logUicode_descriptionWithLocale:locale indent:level]];
}

#endif

@end
