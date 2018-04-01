//
//  UITableView+DWAdapterIOS11.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/10/17.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "UITableView+DWAdapterIOS11.h"
#import "NSObject+DWKit.h"

@implementation UITableView (DWAdapterIOS11)

#ifdef DW_ADAPTER_IOS_11
// 为了适配iOS11 做的简单粗暴的处理
+ (void)initialize {
    if (self == [UITableView class]) {
        [self dw_swizzleInstanceMethod:@selector(initWithFrame:style:) withMethod:@selector(dw_initWithFrame:style:)];
    }
}

- (instancetype)dw_initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    UITableView *tableView = [self dw_initWithFrame:frame style:style];
    [tableView dw_adapterIOS11];
    return tableView;
}
#endif

// 针对现状做简单调整
- (void)dw_adapterIOS11 {
    self.estimatedRowHeight = 0.0;
    self.estimatedSectionHeaderHeight = 0.0;
    self.estimatedSectionFooterHeight = 0.0;
    if(@available(iOS 11, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

@end
