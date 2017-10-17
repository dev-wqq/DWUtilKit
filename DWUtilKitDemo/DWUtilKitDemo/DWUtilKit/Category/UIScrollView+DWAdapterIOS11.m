//
//  UIScrollView+DWAdapterIOS11.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/10/17.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "UIScrollView+DWAdapterIOS11.h"

@implementation UIScrollView (DWAdapterIOS11)

- (void)dw_insetAdjustNeverForIOS11 {
    if(@available(iOS 11, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

@end
