//
//  NSAttributedString+DWUtil.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/5/10.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *dw_convertAttributedStringToHtml(NSAttributedString *attStr);

extern NSAttributedString *dw_convertHtmlToAttributedString(NSString *htmlString);

/**
 rich text edit
 */
@interface NSAttributedString (DWUtil)

/**
 <p><span style="color:#333333"><b>con</b>text<span><br>text</p>
 @return html string
 */
- (NSString *)dw_htmlString;

/**
 从range 返回第一段落中的range
 */
- (NSRange)dw_firstParagraphRangeFromTextRange:(NSRange)range;

/**
 从textRange 返回一个段落range 数组
 */
- (NSArray *)dw_rangeOfParagraphsFromTextRange:(NSRange)textRange;

@end
