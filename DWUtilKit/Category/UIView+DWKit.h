//
//  UIView+DWKit.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/12.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DWKit)

// Frame
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;

// Frame Origin
@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;

// Frame Size
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

// Frame Borders
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat right;

// Center Point
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

// Middle Point
@property (nonatomic, readonly) CGPoint middlePoint;
@property (nonatomic, readonly) CGFloat middleX;
@property (nonatomic, readonly) CGFloat middleY;

@property (nonatomic, readonly) CGFloat maxX;
@property (nonatomic, readonly) CGFloat maxY;

#pragma mark - Util

- (void)dw_logViewHierarchy;

- (void)dw_removeAllSubviews;

- (UIViewController *)dw_viewController;

/// change layer mask
- (void)dw_drawCornerRadius:(CGFloat)radius corners:(UIRectCorner)corners;
- (void)dw_drawCornerRadius:(CGFloat)radius corners:(UIRectCorner)corners roundedRect:(CGRect)rect;

/**
 *  截屏, afterUpdate 是否截取最近跟新
 */
- (UIImage *)dw_snapshotImageAfterScreenUpdates:(BOOL)afterUpdate NS_AVAILABLE_IOS(7_0);

+ (CGRect)dw_frameOfContentWithContentSize:(CGSize)contentSize
                             containerSize:(CGSize)size
                               contentMode:(UIViewContentMode)contentMode;

@end
