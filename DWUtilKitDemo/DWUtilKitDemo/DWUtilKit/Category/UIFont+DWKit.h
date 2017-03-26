//
//  UIFont+DWKit.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/12.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (DWKit)

/**
 *  whether the font is bold
 */
@property (nonatomic, readonly) BOOL isBold NS_AVAILABLE_IOS(7_0);
/**
 *  whether the font is italic(斜体)
 */
@property (nonatomic, readonly) BOOL isItalic NS_AVAILABLE_IOS(7_0);
/**
 *  whether the font is mono space
 */
@property (nonatomic, readonly) BOOL isMonoSpace NS_AVAILABLE_IOS(7_0);
/**
 *  whether the font is color glyphs (such as Emoji).
 */
@property (nonatomic, readonly) BOOL isColorGlyphs NS_AVAILABLE_IOS(7_0);
/**
 *  font weight from -1.0 to 1.0. Regular weight is 0.0.
 */
@property (nonatomic, readonly) CGFloat fontWeight NS_AVAILABLE_IOS(7_0);

- (UIFont *)dw_fontWithBold NS_AVAILABLE_IOS(7_0);

- (UIFont *)dw_fontWithItalic NS_AVAILABLE_IOS(7_0);

- (UIFont *)dw_fontWithBoldItalic NS_AVAILABLE_IOS(7_0);

- (UIFont *)dw_fontWithNormal NS_AVAILABLE_IOS(7_0);

@end
