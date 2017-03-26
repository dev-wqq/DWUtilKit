//
//  UIButton+DWKit.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/12.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (DWKit)

- (void)dw_exchangeTitleAndImageLocation;

- (void)dw_actionWithBlock:(void (^)(id sender))block forControlEvents:(UIControlEvents)ConfrolEvents;

@end
