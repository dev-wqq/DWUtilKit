//
//  DWAppInfo.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/10/22.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DWUtilAppInfo.h"

@implementation DWUtilAppInfo

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
