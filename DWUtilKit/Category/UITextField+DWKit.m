//
//  UITextField+DWKit.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/12.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "UITextField+DWKit.h"

@implementation UITextField (DWKit)

- (void)dw_selectAllText {
    UITextRange *range = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
    [self setSelectedTextRange:range];
}

- (void)dw_selectRange:(NSRange)range {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:NSMaxRange(range)];
    UITextRange *selectRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectRange];
}

@end
