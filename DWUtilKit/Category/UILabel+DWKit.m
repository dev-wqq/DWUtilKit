//
//  UILabel+DWKit.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/15.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "UILabel+DWKit.h"

@implementation UILabel (DWKit)

- (CGFloat)singleLineHeight {
    return self.font.lineHeight;
}

- (CGFloat)singlePointSize {
    return self.font.pointSize;
}

- (CGFloat)singleLineForSpacing {
    return self.multiLineForTBSpacing/2;
}

- (CGFloat)multiLineForTBSpacing {
    return self.font.lineHeight - self.font.pointSize;
}

- (CGFloat)dw_contextHopeSpacing:(CGFloat)lineSpacing {
    return lineSpacing - self.multiLineForTBSpacing;
}

+ (CGFloat)dw_lineSpacingWithLineSpacing:(CGFloat)lineSpacing topLable:(UILabel *)topLabel bottomLable:(UILabel *)bottomLabel {
    return lineSpacing - topLabel.singleLineForSpacing - bottomLabel.singleLineForSpacing;
}

- (void)dw_textAlignForTop {
    NSInteger lines = [self _dw_suggestContextLines];
    for(int i=0; i<lines; i++) {
        self.text = [self.text stringByAppendingString:@"\n "];
    }
}

- (void)dw_textAlignForBottom {
    NSInteger lines = [self _dw_suggestContextLines];
    for(int i=0; i<lines; i++) {
        self.text = [NSString stringWithFormat:@" \n%@",self.text];
    }
}

- (NSInteger)_dw_suggestContextLines {
    CGFloat finalHeight = self.frame.size.height;
    CGFloat finalWidth = self.frame.size.width;
    CGRect frame = [self.text boundingRectWithSize:CGSizeMake(finalWidth, finalHeight) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.font} context:nil];
    NSInteger lines = (finalHeight - frame.size.height)/self.font.lineHeight;
    return lines;
}

@end
