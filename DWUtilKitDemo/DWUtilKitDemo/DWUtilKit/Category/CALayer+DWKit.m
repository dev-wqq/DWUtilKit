//
//  CALayer+DWKit.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/15.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "CALayer+DWKit.h"

@implementation CALayer (DWKit)

- (void)dw_shake {
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    CGFloat s = 5;
    keyFrameAnimation.values = @[@(-s),@(0),@(s),@(0),@(-s),@(0),@(s),@(0)];
    keyFrameAnimation.duration = 0.3f;
    keyFrameAnimation.repeatCount = 2;
    keyFrameAnimation.removedOnCompletion = YES;
    [self addAnimation:keyFrameAnimation forKey:@"shake"];
}

@end
