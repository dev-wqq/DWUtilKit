//
//  DWFPSLabel.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/9.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DWFPSLabel.h"
#import "DWWeakProxy.h"

#define DWFPSSize CGSizeMake(50, 20);

@interface DWFPSLabel ()

@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, strong) UIFont *mainFont;
@property (nonatomic, strong) UIFont *subFont;
@property (nonatomic, assign) NSTimeInterval llll;

@end

@implementation DWFPSLabel

- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    _count ++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    CGFloat progress = fps / 60.0;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d FPS",(int)round(fps)]];
    [text addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, text.length-3)];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(text.length-3, 3)];
    [text addAttribute:NSFontAttributeName value:_mainFont range:NSMakeRange(text.length-3, 3)];
    [text addAttribute:NSFontAttributeName value:_subFont range:NSMakeRange(text.length-4, 1)];
    self.attributedText = text;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 || frame.size.height == 0 ) {
        frame.size = DWFPSSize;
    }
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.textAlignment = NSTextAlignmentCenter;
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.7];
        _mainFont = [UIFont fontWithName:@"Menlo" size:14];
        if (_mainFont) {
            _subFont = [UIFont fontWithName:@"Menlo" size:4];
        } else {
            _mainFont = [UIFont fontWithName:@"Courier" size:14];
            _subFont = [UIFont fontWithName:@"Courier" size:4];
        }
        _link = [CADisplayLink displayLinkWithTarget:[DWWeakProxy proxyWithTarget:self] selector:@selector(tick:)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return DWFPSSize;
}

- (void)dealloc {
    [_link invalidate];
    _link = nil;
}

@end
