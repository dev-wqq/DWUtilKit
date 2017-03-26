//
//  UITextView+DWKit.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/20.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  tip: if want modify placeholder container inset you should modify self.textContainerInset to implementation
 */
@interface UITextView (DWKit)

@property (nonatomic, strong, readonly) UILabel *placeholderLabel;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;

/**
 * UITextField default placeholder color
 */
+ (UIColor *)dw_defaultPlaceholderColor;

@end
