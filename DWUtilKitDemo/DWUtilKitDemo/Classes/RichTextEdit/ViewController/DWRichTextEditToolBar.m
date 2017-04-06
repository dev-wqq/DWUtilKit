//
//  DWRichTextEditToolBar.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/4/4.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DWRichTextEditToolBar.h"
#import "UIButton+DWKit.h"
#import "UIView+DWKit.h"

@implementation DWRichTextEditToolBar {
    UIScrollView *_scrollView;
    UIButton *_hideKeybordButton;
    UIView *_topSeparatorLine;
    UIView *_bottomSeparatorLine;
    NSArray *_items;
    NSMutableArray *_mItemButtons;
    DWRichTextEditToolBarClickBlock _clickBlock;
}

- (NSInteger)hideKeybordTag {
    return 0;
}

+ (NSInteger)dw_baseTag {
    return 1000;
}

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray<DWRichTextEditToolBarConfig *> *)items clickBlock:(DWRichTextEditToolBarClickBlock)clickBlock {
    if (self = [super initWithFrame:frame]) {
        _items = items;
        _clickBlock = clickBlock;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor whiteColor];
    
    _mItemButtons = [NSMutableArray array];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self addSubview:_scrollView];
    
    for (int i = 0; i < _items.count; i++) {
        DWRichTextEditToolBarConfig *config = _items[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scrollView addSubview:button];
        [button setImage:config.normalImage forState:UIControlStateNormal];
        [button setImage:config.selectedImage forState:UIControlStateSelected];
        button.tag = [self.class dw_baseTag] + i;
        [button dw_actionWithBlock:^(id sender) {
            _clickBlock(self,sender);
        } forControlEvents:UIControlEventTouchUpInside];
        [_mItemButtons addObject:button];
    }
    
    _hideKeybordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_hideKeybordButton];
    [_hideKeybordButton setImage:[UIImage imageNamed:@"hide_keybord_normal"] forState:UIControlStateNormal];
    _hideKeybordButton.tag = [self hideKeybordTag];
    [_hideKeybordButton dw_actionWithBlock:^(id sender) {
        _clickBlock(self,sender);
    } forControlEvents:UIControlEventTouchUpInside];
    
    _topSeparatorLine = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_topSeparatorLine];
    _topSeparatorLine.backgroundColor = [UIColor lightGrayColor];

    _bottomSeparatorLine = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_bottomSeparatorLine];
    _bottomSeparatorLine.backgroundColor = [UIColor lightGrayColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat margin = 15;
    CGSize size = _hideKeybordButton.imageView.image.size;
    CGFloat x = self.width - margin - size.width;
    CGFloat y = YCenterInContainer(size.height, self.height);
    _hideKeybordButton.frame = CGRectMake(x, y, size.width, size.height);
    
    x = 0;
    y = 0;
    _topSeparatorLine.frame = CGRectMake(x, y, self.width, CGFloatFromPixel(1));
    _scrollView.frame = CGRectMake(x, y, _hideKeybordButton.left, self.height);
    
    y = self.height - CGFloatFromPixel(1);
    _bottomSeparatorLine.frame = CGRectMake(x, y, self.width, CGFloatFromPixel(1));
    
    x = margin;
    for (int i = 0; i < _mItemButtons.count; i++) {
        UIButton *button = _mItemButtons[i];
        button.centerY = self.centerY;
        size = button.imageView.image.size;
        button.bounds = CGRectMake(0, 0, size.width, size.height);
        button.x = x;
        x += button.width + 25;
    }
    
    _scrollView.bounds = x > _scrollView.width ? CGRectMake(0, 0, x, _scrollView.height) : CGRectMake(0, 0, _scrollView.width, _scrollView.height);
}


@end

@implementation DWRichTextEditToolBarConfig

- (instancetype)initWithNormalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage {
    if (self = [super init]) {
        _normalImage = normalImage;
        _selectedImage = selectedImage;
    }
    return self;
}

@end
