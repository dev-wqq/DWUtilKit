//
//  UIViewController+DWKit.h
//  o2o
//
//  Created by wangqiqi on 2017/2/10.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DWKit)

/**
 *  get animate duration
 */
@property (nonatomic, readonly) CGFloat dw_duration;

@end

@interface UIViewController (DWShowHeaderView)

/**
 *  you can modify its font & textColor properties
 */
@property (nonatomic, readonly) UILabel *dw_textLabel;
/**
 *  header view height
 */
@property (nonatomic, readonly) CGFloat dw_showHeaderViewHeight;

/**
 *  set Height of show tips header view, the default height is 40
 */
- (void)dw_setShowTipsHeight:(CGFloat)height;
- (void)dw_setShowTipsText:(NSString *)text;
- (void)dw_setShowTipsAttrs:(NSAttributedString *)attrs;
- (void)dw_setShowTipsImage:(UIImage *)image;
- (void)dw_setBackgroundColor:(UIColor *)color;

- (void)dw_showTipsAtYPos:(CGFloat)yPos animated:(BOOL)animated;
- (void)dw_hideTips:(BOOL)animated;

@end

@interface UIViewController (DWShowFooterView)

/**
 *  footer view height
 */
@property (nonatomic, readonly) CGFloat dw_showFooterViewHeight;

/**
 *  set height of show footer view, the default height is 55
 */
- (void)dw_setShowFooterViewHeight:(CGFloat)height;
- (void)dw_setShowFooterViewBgColor:(UIColor *)bgColor;
/**
 *  set separator top line color #ececec
 */
- (void)dw_setShowFooterViewTopSeparatorColor:(UIColor *)color;
- (void)dw_footerViewAddSubView:(UIView *)subView;

- (void)dw_showFooterViewAtYPost:(CGFloat)yPos animated:(BOOL)animated;
- (void)dw_hideFooterView:(BOOL)animated;

@end
