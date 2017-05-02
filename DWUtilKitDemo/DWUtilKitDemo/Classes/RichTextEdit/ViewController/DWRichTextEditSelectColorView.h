//
//  DWRichTextEditSelectColorView.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/4/30.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DWRichTextEditSelectColorView;
typedef void (^DWSelectBlock)(DWRichTextEditSelectColorView *selectColorView, UIColor *selectColor);

@interface DWRichTextEditSelectColorView : UIView 

/**
 定制微小店当前需要的六种颜色分别为：
 #2d2d2d、#de4118、#19a2e5、#1cb72e、#d82b5d、#fbbb1d
 */
+ (NSArray <UIColor *> *)dw_richTextColors;

- (instancetype)initWithColors:(NSArray *)colors atPoint:(CGPoint)point selectBlock:(DWSelectBlock)selectBlock;

- (void)dw_show:(BOOL)animated inView:(UIView *)superView;

- (void)dw_dismiss:(BOOL)animated;


@end
