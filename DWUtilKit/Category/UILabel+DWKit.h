//
//  UILabel+DWKit.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/15.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (DWKit)

/**
 *  current font line height
 */
@property (nonatomic, readonly, assign) CGFloat singleLineHeight;
/**
 *  current font point Size
 */
@property (nonatomic, readonly, assign) CGFloat singlePointSize;
/**
 * （font.lineHight - font.pointSize) / 2 (top or bottom spacing)
 */
@property (nonatomic, readonly, assign) CGFloat singleLineForSpacing;
/**
 *  (font.lineHight - font.pointSize) TB(top and bottom)
 */
@property (nonatomic, readonly, assign) CGFloat multiLineForTBSpacing;
/**
 *  @return 期待的上下文的行间距，这里的label的高度使用 lineHight or boundingRectWithSize 计算的高度
 */
- (CGFloat)dw_contextHopeSpacing:(CGFloat)lineSpacing;
/**
 *  设置两个label之间的间隔（是context之间的间隔）这里的label的高度使用 lineHight or boundingRectWithSize 计算的高度
 */
+ (CGFloat)dw_lineSpacingWithLineSpacing:(CGFloat)lineSpacing
                                topLable:(UILabel *)topLabel
                             bottomLable:(UILabel *)bottomLabel;
/**
 *  text align top
 */
- (void)dw_textAlignForTop;
/**
 *  text align bottom
 */
- (void)dw_textAlignForBottom;


@end
