//
//  UIViewController+DWKit.m
//  o2o
//
//  Created by wangqiqi on 2017/2/10.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "UIViewController+DWKit.h"
#import "UIView+DWKit.h"
#import <objc/runtime.h>

static CGFloat const HeaderViewHeight = 40;
static CGFloat const FooterViewHeight = 55;

@interface DWShowTipsHeaderView : UIView

@property (nonatomic) UILabel *labelText;
@property (nonatomic) UIImageView *imageView;

- (void)setText:(NSString *)text;
- (void)setImage:(UIImage *)image;

@end

@implementation DWShowTipsHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _labelText = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_labelText];
        _labelText.font = [UIFont systemFontOfSize:16];
        _labelText.textColor = [UIColor whiteColor];
        _labelText.numberOfLines = 0;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setText:(NSString *)text {
    _labelText.text = text;
    [_labelText sizeToFit];
    [self setNeedsLayout];
}

- (void)setImage:(UIImage *)image {
    _imageView.image = image;
    _imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [self setNeedsLayout];
}

- (void)setAtts:(NSAttributedString *)atts {
    _labelText.attributedText = atts;
    [_labelText sizeToFit];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat x = 0;
    if (_imageView.width != 0) {
        CGFloat paddingX = 2;
        CGFloat w = _imageView.width + _labelText.width + paddingX;
        x = floor((self.width - w)/2);
        _imageView.frame = CGRectMake(x, self.height/2-_imageView.height/2, _imageView.width, _imageView.height);

        x = _imageView.width != 0 ? _imageView.right + paddingX : 0;
    } else {
        x = self.width/2-_labelText.width/2;
    }
    _labelText.frame = CGRectMake(x, self.height/2-_labelText.height/2, _labelText.width, self.height);
}

@end

static void *kHeaderView = &kHeaderView;
static void *kFooterView = &kFooterView;

@implementation UIViewController (DWKit)

- (CGFloat)dw_duration {
    return 0.4;
}

@end

@implementation UIViewController (DWShowHeaderView)

- (DWShowTipsHeaderView *)dw_headerView {
    DWShowTipsHeaderView *view = objc_getAssociatedObject(self, kHeaderView);
    if (!view) {
        view = [[DWShowTipsHeaderView alloc] initWithFrame:CGRectMake(0, -HeaderViewHeight, 0, HeaderViewHeight)];
        objc_setAssociatedObject(self, kHeaderView, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self.view addSubview:view];
    }
    return view;
}

- (UILabel *)dw_textLabel {
    return self.dw_headerView.labelText;
}

- (CGFloat)dw_showHeaderViewHeight {
    return self.dw_headerView.height;
}

- (void)dw_setShowTipsHeight:(CGFloat)height {
    self.dw_headerView.height = height;
}

- (void)dw_setShowTipsText:(NSString *)text {
    [self.dw_headerView setText:text];
}

- (void)dw_setShowTipsAttrs:(NSAttributedString *)attrs {
    [self.dw_headerView setAtts:attrs];
}

- (void)dw_setShowTipsImage:(UIImage *)image {
    [self.dw_headerView setImage:image];
}

- (void)dw_setBackgroundColor:(UIColor *)color {
    self.dw_headerView.backgroundColor = color;
}

- (void)dw_showTips:(BOOL)animated {
    BOOL hasNavBar = self.navigationController.navigationBar != nil;
    CGFloat yPos = 0.0;
    if (hasNavBar) {
        CGRect frame = [self.navigationController.navigationBar convertRect:self.navigationController.navigationBar.bounds toView:self.view];
        yPos = frame.origin.y + frame.size.height;
    } else {
        yPos = 0;
    }
    [self dw_showTipsAtYPos:yPos animated:animated];
}

- (void)dw_showTipsAtYPos:(CGFloat)yPos animated:(BOOL)animated {
    CGRect frameStart = CGRectMake(0, yPos-self.dw_headerView.height, self.view.width, self.dw_headerView.height);
    CGRect frameEnd = frameStart;
    frameEnd.origin.y = frameStart.origin.y + frameStart.size.height;
    [self.view bringSubviewToFront:self.dw_headerView];
    
    self.dw_headerView.frame = frameStart;
    if (animated) {
        [UIView animateWithDuration:[self dw_duration] animations:^{
            self.dw_headerView.frame = frameEnd;
        }];
    } else {
        self.dw_headerView.frame = frameEnd;
    }
}

- (void)dw_hideTips:(BOOL)animated {
    BOOL hasNavBar = self.navigationController.navigationBar != nil;
    CGRect frameStart = CGRectMake(0, 0, self.view.width, self.dw_headerView.height);
    if (hasNavBar) {
        CGRect frame = [self.navigationController.navigationBar convertRect:self.navigationController.navigationBar.bounds toView:self.view];
        frameStart.origin.y = frame.origin.y + frame.size.height - frameStart.size.height;
        self.dw_headerView.frame = frameStart;
        [self.view bringSubviewToFront:self.dw_headerView];
    } else {
        frameStart.origin.y = -self.dw_headerView.height;
    }
    
    if (animated) {
        [UIView animateWithDuration:[self dw_duration] animations:^{
            self.dw_headerView.frame = frameStart;
        }];
    } else {
        self.dw_headerView.frame = frameStart;
    }
}

@end

@implementation UIViewController (DWShowFooterView)

- (CGFloat)dw_showFooterViewHeight {
    return self.dw_footerView.height;
}

- (UIView *)dw_footerView {
    UIView *footerView = objc_getAssociatedObject(self, kFooterView);
    if (!footerView) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        footerView = [[UIView alloc] initWithFrame:CGRectMake(0, (size.height-64+FooterViewHeight), size.width, FooterViewHeight)];
        objc_setAssociatedObject(self, kFooterView, footerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self.view addSubview:footerView];
        footerView.backgroundColor = [UIColor whiteColor];
        CGFloat height = (1/[UIScreen mainScreen].scale);
        UIView *separaterLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, height)];
        separaterLine.tag = 10001;
        separaterLine.backgroundColor = [UIColor clearColor];
        [footerView addSubview:separaterLine];
    }
    return footerView;
}

- (void)dw_setShowFooterViewHeight:(CGFloat)height {
    UIView *footerView = [self dw_footerView];
    footerView.height = height;
}

- (void)dw_setShowFooterViewBgColor:(UIColor *)bgColor {
    UIView *footerView = [self dw_footerView];
    footerView.backgroundColor = bgColor;
}

- (void)dw_setShowFooterViewTopSeparatorColor:(UIColor *)color {
    UIView *footerView = [self dw_footerView];
    UIView *topViewline = [footerView viewWithTag:10001];
    topViewline.backgroundColor = color;
}

- (void)dw_footerViewAddSubView:(UIView *)subView {
    UIView *footer = [self dw_footerView];
    [footer addSubview:subView];
}

- (void)dw_showFooterViewAtYPost:(CGFloat)yPos animated:(BOOL)animated {
    CGRect frameStart = CGRectMake(0, yPos+self.dw_footerView.height, self.view.width, self.dw_footerView.height);
    CGRect frameEnd = frameStart;
    frameEnd.origin.y = frameStart.origin.y - frameStart.size.height;
    [self.view bringSubviewToFront:self.dw_footerView];
    
    self.dw_footerView.frame = frameStart;
    if (animated) {
        [UIView animateWithDuration:[self dw_duration] animations:^{
            self.dw_footerView.frame = frameEnd;
        }];
    } else {
        self.dw_footerView.frame = frameEnd;
    }
}

- (void)dw_hideFooterView:(BOOL)animated {
    BOOL hasNavBar = self.navigationController.navigationBar != nil;
    UIView *footerView = [self dw_footerView];
    CGRect frameStart = footerView.frame;
    if (hasNavBar) {
        [self.view bringSubviewToFront:footerView];
    }
    frameStart.origin.y = - self.dw_footerView.height;
    
    if (animated) {
        [UIView animateWithDuration:[self dw_duration] animations:^{
            self.dw_footerView.frame = frameStart;
        }];
    } else {
        self.dw_footerView.frame = frameStart;
    }
}

@end
