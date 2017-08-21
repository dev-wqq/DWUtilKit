//
//  UIWindow+DWKit.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/8/20.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (DWKit)

/**
 @return key window visible viewController
 */
+ (UIViewController *)dw_keyWindowVisibleViewController;

/**
 @return current window visible viewController
 */
- (UIViewController *)dw_visibleViewController;

@end

