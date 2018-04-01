//
//  UIScrollView+DWAdapterIOS11.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/10/17.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (DWAdapterIOS11)

/**
 Configure the behavior of adjustedContentInset.
 Default is UIScrollViewContentInsetAdjustmentAutomatic.
 
 For adjust setup  self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
 */
- (void)dw_insetAdjustNeverForIOS11;

@end
