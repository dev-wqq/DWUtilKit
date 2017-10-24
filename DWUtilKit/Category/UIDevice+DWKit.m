//
//  UIDevice+DWKit.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/4/6.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "UIDevice+DWKit.h"
#import "DWUtilAppInfo.h"

@implementation UIDevice (DWKit)

+ (NSOperatingSystemVersion)dw_systemVersion {
    return [[NSProcessInfo processInfo] operatingSystemVersion];
}

+ (NSInteger)dw_majorVersion {
    return [self dw_systemVersion].majorVersion;
}

+ (NSInteger)dw_minorVersion {
    return [self dw_systemVersion].minorVersion;
}

+ (NSInteger)dw_patchVersion {
    return [self dw_systemVersion].patchVersion;
}

+ (NSString *)dw_getBundleIdentifier {
    return [DWUtilAppInfo dw_getBundleIdentifier];
}

+ (NSString *)dw_getBundleVersion {
    return [DWUtilAppInfo dw_getBundleVersion];
}

+ (NSString *)dw_getPureVersionName {
    return [DWUtilAppInfo dw_getPureVersionName];
}

+ (NSString *)dw_getVersionIName {
    return [DWUtilAppInfo dw_getVersionIName];
}

+ (NSString *)dw_getVersionVName {
    return [DWUtilAppInfo dw_getVersionVName];
}



@end
