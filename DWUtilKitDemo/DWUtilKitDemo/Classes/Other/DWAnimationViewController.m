//
//  DWAnimationViewController.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/7/20.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DWAnimationViewController.h"
#import "UIColor+DWKit.h"

@interface DWDotZoonAnimationView : UIView

@property (nonatomic, strong) CALayer *animationLayer;

@end

@implementation DWDotZoonAnimationView

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor dw_colorWithHexString:@"#0d87f4" AndAlpha:0.3];
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    _animationLayer = [[CALayer alloc] init];
    [self.layer addSublayer:_animationLayer];
    _animationLayer.cornerRadius = 4;
    _animationLayer.masksToBounds = YES;
    _animationLayer.shouldRasterize = YES;
    _animationLayer.rasterizationScale = [UIScreen mainScreen].scale;
    _animationLayer.backgroundColor = [UIColor dw_opaqueColorWithHexString:@"#0d87f4"].CGColor;
    [self startKeyAnimated];
}

- (void)startAnimated {
    CABasicAnimation *reduceScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    reduceScale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    reduceScale.fromValue = @(1);
    reduceScale.toValue = @(0.5);
    reduceScale.duration = 0.5;
    reduceScale.repeatCount = HUGE_VALF;
    
    [_animationLayer addAnimation:reduceScale forKey:@"kDotZoomAnimationKey"];
}

- (void)startKeyAnimated {
    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    keyframeAnimation.values = @[@(1), @(0.6), @(1)];
    keyframeAnimation.keyTimes = @[@0, @0.5, @1];
    keyframeAnimation.duration = 1;
    keyframeAnimation.repeatCount = HUGE_VALF;
    [_animationLayer addAnimation:keyframeAnimation forKey:@"kDotZoomAnimationKey"];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bounds = CGRectMake(0, 0, 12, 12);
    self.animationLayer.frame = CGRectMake(2, 2, 8, 8);
}

@end

@interface DWAnimationViewController ()

@end

@implementation DWAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DWDotZoonAnimationView *view = [[DWDotZoonAnimationView alloc] init];
    [self.view addSubview:view];
//    [view startAnimated];
//    [view startKeyAnimated];
    view.center = self.view.center;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
