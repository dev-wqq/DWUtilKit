//
//  UIWindow+DWKit.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/8/20.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "UIWindow+DWKit.h"

@implementation UIWindow (DWKit)

+ (UIViewController *)dw_keyWindowVisibleViewController {
    return [[UIApplication sharedApplication].keyWindow dw_visibleViewController];
}

- (UIViewController *)dw_visibleViewController {
    UIViewController *vc = self.rootViewController;
    return [self.class _dw_visibleViewControllerFromVC:vc];
}

+ (UIViewController *)_dw_visibleViewControllerFromVC:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _dw_visibleViewControllerFromVC:[(UINavigationController *)vc visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _dw_visibleViewControllerFromVC:[(UITabBarController *)vc selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self _dw_visibleViewControllerFromVC:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}

@end
