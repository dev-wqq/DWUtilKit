//
//  NSAttributedString+DWUtil.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/5/10.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "NSAttributedString+DWUtil.h"
#import "NSTextAttachment+DWUtil.h"
#import "NSAttributedString+DWUtil.h"
#import "UIFont+DWKit.h"

NSString *dw_convertAttributedStringToHtml(NSAttributedString *attStr) {
    // http://stackoverflow.com/questions/5298188/how-do-i-convert-nsattributedstring-into-html-string
    NSDictionary *documentAttributes = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
    NSError *error;
    NSData *htmlData = [attStr dataFromRange:NSMakeRange(0, attStr.length) documentAttributes:documentAttributes error:&error];
    if (error) {
        NSLog(@"AttributedString to HTML Error:%@",error);
    }
    NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    return htmlString;
}

NSAttributedString *dw_convertHtmlToAttributedString(NSString *htmlString) {
    if (htmlString.length == 0) {
        return [[NSAttributedString alloc] init];
    }
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                              NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)};
    NSError *error;
    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSAttributedString *htmlAttributedString = [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:&error];
    if (error) {
        NSLog(@"HTML to AttributedString Error:%@",error);
    }
    return htmlAttributedString;
}

@implementation NSAttributedString (DWUtil)

- (NSString *)dw_htmlString {
    if (self.string.length == 0) {
        return nil;
    }
    NSMutableString *mHtmlString = [NSMutableString string];
    NSArray *paragraphRanges = [self dw_rangeOfParagraphsFromTextRange:NSMakeRange(0, self.string.length-1)];
    for (int i = 0; i<paragraphRanges.count; i++) {
        [mHtmlString appendString:@"<p>"];
        NSRange range = [paragraphRanges[i] rangeValue];
        [self enumerateAttributesInRange:range options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
            NSTextAttachment *textAttachment = attrs[NSAttachmentAttributeName];
            if (textAttachment) {
                NSString *imageName = textAttachment.dw_imageSrc;
                NSString *subImageHtml = [NSString stringWithFormat:@"<img src=\"%@\">",imageName];
                [mHtmlString appendString:subImageHtml];
            } else {
                UIFont *font = attrs[NSFontAttributeName];
                UIColor *color = attrs[NSForegroundColorAttributeName];
                
                NSString *boldPrefix = @"";
                NSString *boldSuffix = @"";
                if ([font isBold]) {
                    boldPrefix = @"<b>";
                    boldSuffix = @"</b>";
                }
                NSString *colorHexName = [color dw_hexString];
                NSString *styleColor = @"";
                if (colorHexName.length > 0) {
                    colorHexName = [NSString stringWithFormat:@"#%@",colorHexName];
                    styleColor = [NSString stringWithFormat:@" style=\"color:%@\"",colorHexName];
                }
                NSString *context = [self.string substringWithRange:range];
                NSString *subTextHtml = [NSString stringWithFormat:@"<span%@>%@%@%@</span>",styleColor,boldPrefix,context,boldSuffix];
                [mHtmlString appendString:subTextHtml];
            }
        }];
        [mHtmlString appendString:@"</p>"];
    }
    return mHtmlString;
}

- (NSRange)dw_firstParagraphRangeFromTextRange:(NSRange)range {
    NSInteger start = -1;
    NSInteger end = -1;
    NSInteger length = 0;
    
    NSInteger startingRange = (range.location == self.string.length || [self.string characterAtIndex:range.location] == '\n') ?
    range.location-1 :
    range.location;
    
    for (NSInteger i=startingRange ; i>=0 ; i--) {
        char c = [self.string characterAtIndex:i];
        if (c == '\n') {
            start = i+1;
            break;
        }
    }
    
    start = (start == -1) ? 0 : start;
    NSInteger moveForwardIndex = (range.location > start) ? range.location : start;
    for (NSInteger i=moveForwardIndex; i<= self.string.length-1 ; i++) {
        char c = [self.string characterAtIndex:i];
        if (c == '\n') {
            end = i;
            break;
        }
    }
    
    end = (end == -1) ? self.string.length : end;
    length = end - start;
    return NSMakeRange(start, length);
}

- (NSArray *)dw_rangeOfParagraphsFromTextRange:(NSRange)textRange {
    NSMutableArray *paragraphRanges = [NSMutableArray array];
    NSInteger rangeStartIndex = textRange.location;
    
    while (true) {
        NSRange range = [self dw_firstParagraphRangeFromTextRange:NSMakeRange(rangeStartIndex, 0)];
        rangeStartIndex = range.location + range.length + 1;
        [paragraphRanges addObject:[NSValue valueWithRange:range]];
        if (range.location + range.length >= textRange.location + textRange.length) {
            break;
        }
    }
    return paragraphRanges;
}

@end
