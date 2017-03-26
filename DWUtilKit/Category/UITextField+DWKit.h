//
//  UITextField+DWKit.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/12.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (DWKit)

/**
 *  set all text selected.
 */
- (void)dw_selectAllText;

/**
 *  Set text in range selected.
 */
- (void)dw_selectRange:(NSRange)range;


@end
