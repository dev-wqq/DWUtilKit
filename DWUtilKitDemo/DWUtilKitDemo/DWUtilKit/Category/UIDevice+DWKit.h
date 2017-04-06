//
//  UIDevice+DWKit.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/4/6.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (DWKit)

+ (NSOperatingSystemVersion)dw_systemVersion;
+ (NSInteger)dw_majorVersion;
+ (NSInteger)dw_minorVersion;
+ (NSInteger)dw_patchVersion;

/**
 @return Bundle identifier
 */
+ (NSString *)dw_getBundleIdentifier;

/**
 @return Bundle version
 */
+ (NSString *)dw_getBundleVersion;

/**
 @return x.y.z版本号，不带有任何前缀字符
 */
+ (NSString *)dw_getPureVersionName;

/**
 @return i.x.y.z版本号
 */
+ (NSString *)dw_getVersionIName;

/**
 @return Vx.y.z版本号
 */
+ (NSString *)dw_getVersionVName;

@end
