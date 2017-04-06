//
//  DWRichTextEditToolBar.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/4/4.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DWRichTextEditToolBar;
typedef void(^DWRichTextEditToolBarClickBlock)(DWRichTextEditToolBar *toolBar, UIButton *sender);

@class DWRichTextEditToolBarConfig;
@interface DWRichTextEditToolBar : UIView

@property (nonatomic, readonly) NSInteger hideKeybordTag;

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray<DWRichTextEditToolBarConfig *> *)items clickBlock:(DWRichTextEditToolBarClickBlock)clickBlock;

/**
 作为基础的tag，按钮button.tag = [self dw_baseTag] + idx(items index)
 */
+ (NSInteger)dw_baseTag;

@end

@interface DWRichTextEditToolBarConfig : NSObject

@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectedImage;

- (instancetype)initWithNormalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage;

@end
