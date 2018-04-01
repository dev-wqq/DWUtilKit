//
//  UITableView+DWAdapterIOS11.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/10/17.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 可以设置全局宏定义，DW_ADAPTER_IOS_11, 使用runtime在初始化 call - (void)dw_adapterIOS11;
 */
@interface UITableView (DWAdapterIOS11)

/**
 iOS11 以后 estimatedRowHeight，estimatedSectionHeaderHeight，estimatedSectionFooterHeight 默认这是为 UITableViewAutomaticDimension,
 
 为了设置以前的项目将estimatedRowHeight，estimatedSectionHeaderHeight，estimatedSectionFooterHeight 统一设置为0.
 
 并且设置 contentInsetAdjustmentBehavior 为 UIScrollViewContentInsetAdjustmentNever。
 */
- (void)dw_adapterIOS11;

@end
