//
//  UIDevice+DWKit.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/4/6.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "UIDevice+DWKit.h"

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
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    return [dict objectForKey:@"CFBundleIdentifier"];
}

+ (NSString *)dw_getBundleVersion {
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    return [dict objectForKey:@"CFBundleVersion"];
}

+ (NSString *)dw_getPureVersionName {
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    return [dict objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)dw_getVersionIName {
    return [NSString stringWithFormat:@"i.%@", [self dw_getPureVersionName]];
}

+ (NSString *)dw_getVersionVName {
    return [NSString stringWithFormat:@"V.%@", [self dw_getPureVersionName]];
}



@end
