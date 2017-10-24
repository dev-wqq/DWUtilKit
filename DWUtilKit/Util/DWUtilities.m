//
//  DWUtilities.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/23.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DWUtilities.h"

@interface DWUtilConfig: NSObject

+ (CGFloat)dw_statusHeight;

+ (BOOL)dw_iPhoneX;

@end

@implementation DWUtilConfig

+ (CGFloat)dw_statusHeight {
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

+ (BOOL)dw_iPhoneX {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone &&
        CGSizeEqualToSize([UIScreen mainScreen].nativeBounds.size, CGSizeMake(1125, 3436))) {
        return YES;
    }
    return NO;
}

@end

BOOL DWIPhoneX() {
    return [DWUtilConfig dw_iPhoneX];
}

CGFloat DWStatusHeight() {
    return [DWUtilConfig dw_statusHeight];
}

CGFloat DWScreenScale() {
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [UIScreen mainScreen].scale;
    });
    return scale;
}

CGSize DWScreenSize() {
    static CGSize size;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size = [UIScreen mainScreen].bounds.size;
        if (size.height < size.width) {
            CGFloat tmp = size.height;
            size.height = size.width;
            size.width = tmp;
        }
    });
    return size;
}

NSUInteger DWDeviceSystemMajorVersion() {
    static NSUInteger systemVersion = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemVersion = [[[[[UIDevice currentDevice] systemVersion]
                            componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return systemVersion;
}

