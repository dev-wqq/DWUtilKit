//
//  UIButton+DWKit.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/12.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "UIButton+DWKit.h"
#import <objc/runtime.h>

static const void *KButtonClickEventKey = &KButtonClickEventKey;

@implementation UIButton (DWKit)

- (void)dw_exchangeTitleAndImageLocation {
    self.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    self.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    self.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    self.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
}

- (void)doClick:(id)sender {
    void(^block)(id sender) = objc_getAssociatedObject(self, &KButtonClickEventKey);
    if (block) {
        block(sender);
    }
}

- (void)dw_actionWithBlock:(void (^)(id sender))block forControlEvents:(UIControlEvents)ConfrolEvents {
    objc_setAssociatedObject(self, &KButtonClickEventKey, block, OBJC_ASSOCIATION_COPY);
    [self addTarget:self action:@selector(doClick:) forControlEvents:ConfrolEvents];
}

@end
