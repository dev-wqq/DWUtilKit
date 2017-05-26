//
//  NSObject+DWLogUnicode.h
//  DWUtilKit
//
//  Created by wangqiqi on 2017/3/31.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DWLogUnicode)

+ (NSString *)logUicode_stringByReplaceUnicode:(NSString *)string;

+ (BOOL)logUicode_swizzleInstanceMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector;

@end

@interface NSArray (DWLogUnicode)

@end

@interface NSDictionary (DWLogUnicode)

@end

@interface NSSet (DWLogUnicode)

@end

