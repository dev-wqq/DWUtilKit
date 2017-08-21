//
//  NSAttributedString+DWKit.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/12.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "NSAttributedString+DWKit.h"

@implementation NSAttributedString (DWKit)

+ (NSAttributedString *)dw_attributedStringWithHtmlString:(NSString *)htmlString {
    if (htmlString.length == 0) {
        return [[NSAttributedString alloc] init];
    }
    NSDictionary *documentAttributes = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                                         NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)};
    NSError *error;
    NSAttributedString *attrs = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding] options:documentAttributes documentAttributes:nil error:&error];
    if (error) {
        NSAssert(NO, @"HTML to AttributedString Error:%@",error.description);
    }
    return attrs;
}

+ (NSString *)dw_htmlStringWithAttributdString:(NSAttributedString *)attrs {
    // http://stackoverflow.com/questions/5298188/how-do-i-convert-nsattributedstring-into-html-string
    NSDictionary *documentAttributes = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
    NSError *error;
    NSData *htmlData = [attrs dataFromRange:NSMakeRange(0, attrs.length) documentAttributes:documentAttributes error:&error];
    if (error) {
        NSAssert(NO,@"AttributedString to HTML Error:%@",error.description);
    }
    NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    return htmlString;
}

- (NSDictionary *)dw_attributes {
    return [self dw_attributesAtIndex:0];
}

- (NSDictionary *)dw_attributesAtIndex:(NSUInteger)index {
    if (index > self.length || self.length == 0) {
        return nil;
    }
    if (self.length > 0 && index == self.length) {
        index--;
    }
    return [self attributesAtIndex:index effectiveRange:NULL];
}

- (id)dw_attribute:(NSString *)attributeName atIndex:(NSUInteger)index {
    if (!attributeName) {
        return nil;
    }
    if (index > self.length || self.length == 0) {
        return nil;
    }
    if (self.length > 0 && index == self.length) {
        index--;
    }
    return [self attribute:attributeName atIndex:index effectiveRange:NULL];
}

- (UIFont *)dw_font {
    return [self dw_fontAtIndex:0];
}

- (UIFont *)dw_fontAtIndex:(NSUInteger)index {
    return [self dw_attribute:NSFontAttributeName atIndex:index];
}

- (NSParagraphStyle *)dw_paragraphStyle {
    return [self dw_paragraphStyleAtIndex:0];
}

- (NSParagraphStyle *)dw_paragraphStyleAtIndex:(NSUInteger)index {
    return [self dw_attribute:NSParagraphStyleAttributeName atIndex:index];
}

- (UIColor *)dw_foregroundColor {
    return [self dw_foregroundColorAtIndex:0];
}

- (UIColor *)dw_foregroundColorAtIndex:(NSUInteger)index {
    return [self dw_attribute:NSForegroundColorAttributeName atIndex:index];
}

- (UIColor *)dw_backgroundColor {
    return [self dw_backgroundColorAtIndex:0];
}

- (UIColor *)dw_backgroundColorAtIndex:(NSUInteger)index {
    return [self dw_attribute:NSBackgroundColorAttributeName atIndex:index];
}

- (NSNumber *)dw_ligature {
    return [self dw_ligatureAtIndex:0];
}

- (NSNumber *)dw_ligatureAtIndex:(NSUInteger)index {
    return [self dw_attribute:NSLigatureAttributeName atIndex:index];
}

- (NSNumber *)dw_kern {
    return [self dw_kernAtIndex:0];
}

- (NSNumber *)dw_kernAtIndex:(NSUInteger)index {
    return [self dw_attribute:NSKernAttributeName atIndex:0];
}

- (NSUnderlineStyle)dw_strikethroughStyle {
    return [self dw_strikethroughStyleAtIndex:0];
}

- (NSUnderlineStyle)dw_strikethroughStyleAtIndex:(NSUInteger)index {
    NSNumber *number = [self dw_attribute:NSStrikethroughStyleAttributeName atIndex:index];
    return number.integerValue;
}

- (NSUnderlineStyle)dw_underlineStyle {
    return [self dw_underlineStyleAtIndex:0];
}

- (NSUnderlineStyle)dw_underlineStyleAtIndex:(NSUInteger)index {
    NSNumber *number = [self dw_attribute:NSUnderlineStyleAttributeName atIndex:index];
    return number.integerValue;
}

- (UIColor *)dw_strokeColor {
    return [self dw_strokeColorAtIndex:0];
}

- (UIColor *)dw_strokeColorAtIndex:(NSUInteger)index {
    return [self dw_attribute:NSStrokeColorAttributeName atIndex:0];
}

- (NSNumber *)dw_strokeWidth {
    return [self dw_strokeWidthAtIndex:0];
}

- (NSNumber *)dw_strokeWidthAtIndex:(NSUInteger)index {
    return [self dw_attribute:NSStrokeWidthAttributeName atIndex:index];
}

- (NSShadow *)dw_shadow {
    return [self dw_shadowAtIndex:0];
}

- (NSShadow *)dw_shadowAtIndex:(NSUInteger)index {
    return [self dw_attribute:NSShadowAttributeName atIndex:index];
}

- (NSString *)dw_textEffect {
    return [self dw_textEffectAtIndex:0];
}

- (NSString *)dw_textEffectAtIndex:(NSUInteger)index {
    return [self dw_attribute:NSTextEffectAttributeName atIndex:index];
}

- (NSTextAttachment *)dw_attachment {
    return [self dw_attachmentAtIndex:0];
}

- (NSTextAttachment *)dw_attachmentAtIndex:(NSUInteger)index {
    return [self dw_attribute:NSAttachmentAttributeName atIndex:index];
}

- (NSNumber *)dw_baselineOffset {
    return [self dw_baselineOffsetAtIndex:0];
}

- (NSNumber *)dw_baselineOffsetAtIndex:(NSUInteger)index {
    return [self dw_attribute:NSBaselineOffsetAttributeName atIndex:index];
}

- (UIColor *)dw_underlineColor {
    return [self dw_underlineColorAtIndex:0];
}

- (UIColor *)dw_underlineColorAtIndex:(NSUInteger)index {
    return [self dw_attribute:NSUnderlineColorAttributeName atIndex:index];
}

- (UIColor *)dw_strikethroughColor {
    return [self dw_strikethroughColorAtIndex:0];
}

- (UIColor *)dw_strikethroughColorAtIndex:(NSUInteger)index {
    return [self dw_attribute:NSStrikethroughColorAttributeName atIndex:index];
}

- (NSNumber *)dw_obliqueness {
    return [self dw_obliquenessAtIndex:0];
}

- (NSNumber *)dw_obliquenessAtIndex:(NSUInteger)index {
    return [self dw_attribute:NSObliquenessAttributeName atIndex:index];
}

- (NSNumber *)dw_expansion {
    return [self dw_expansionAtIndex:0];
}

- (NSNumber *)dw_expansionAtIndex:(NSUInteger)index {
    return [self dw_attribute:NSExpansionAttributeName atIndex:index];
}

- (NSArray<NSNumber *> *)dw_writingDirection {
    return [self dw_writingDirectionAtIndex:0];
}

- (NSArray<NSNumber *> *)dw_writingDirectionAtIndex:(NSUInteger)index {
    return [self dw_writingDirectionAtIndex:index];
}

- (BOOL)dw_verticalGlyphForm {
    return [self dw_verticalGlyphFormAtIndex:0];
}

- (BOOL)dw_verticalGlyphFormAtIndex:(NSUInteger)index {
    NSNumber *number = [self dw_attribute:NSVerticalGlyphFormAttributeName atIndex:index];
    return number.boolValue;
}

#pragma mark - paragraph attribute

#define DWParagraphAttribute(_attr_) { \
    NSParagraphStyle *style = self.dw_paragraphStyle; \
    if(!style) { \
        style = [NSParagraphStyle defaultParagraphStyle]; \
    } \
    return style. _attr_; \
}

#define DWParagraphAttributeAtIndex(_attr_) { \
    NSParagraphStyle *style = [self dw_paragraphStyleAtIndex:index]; \
    if(!style) { \
        style = [NSParagraphStyle defaultParagraphStyle]; \
    } \
    return style. _attr_; \
}

- (CGFloat)dw_lineSpacing {
    DWParagraphAttribute(lineSpacing);
}

- (CGFloat)dw_lineSpacingAtIndex:(NSUInteger)index {
    DWParagraphAttributeAtIndex(lineSpacing);
}

- (CGFloat)dw_paragraphSpacing {
    DWParagraphAttribute(paragraphSpacing);
}

- (CGFloat)dw_paragraphSpacingAtIndex:(NSUInteger)index {
    DWParagraphAttributeAtIndex(paragraphSpacing);
}

- (NSTextAlignment)dw_alignment {
    DWParagraphAttribute(alignment);
}

- (NSTextAlignment)dw_alignmentAtIndex:(NSUInteger)index {
    DWParagraphAttributeAtIndex(alignment);
}

- (CGFloat)dw_headIndent {
    DWParagraphAttribute(headIndent);
}

- (CGFloat)dw_headIndentAtIndex:(NSUInteger)index {
    DWParagraphAttributeAtIndex(headIndent);
}

- (CGFloat)dw_tailIndent {
    DWParagraphAttribute(tailIndent);
}

- (CGFloat)dw_tailIndentAtIndex:(NSUInteger)index {
    DWParagraphAttributeAtIndex(tailIndent);
}

- (CGFloat)dw_firstLineHeadIndent {
    DWParagraphAttribute(firstLineHeadIndent);
}

- (CGFloat)dw_firstLineHeadIndentAtIndex:(NSUInteger)index {
    DWParagraphAttributeAtIndex(firstLineHeadIndent);
}

- (CGFloat)dw_minimumLineHeight {
    DWParagraphAttribute(minimumLineHeight);
}

- (CGFloat)dw_minimumLineHeightAtIndex:(NSUInteger)index {
    DWParagraphAttributeAtIndex(minimumLineHeight);
}

- (CGFloat)dw_maximumLineHeight {
    DWParagraphAttribute(maximumLineHeight);
}

- (CGFloat)dw_maximumLineHeightAtIndex:(NSUInteger)index {
    DWParagraphAttributeAtIndex(maximumLineHeight);
}

- (NSLineBreakMode)dw_lineBreakMode {
    DWParagraphAttribute(lineBreakMode);
}

- (NSLineBreakMode)dw_lineBreakModeAtIndex:(NSUInteger)index {
    DWParagraphAttributeAtIndex(lineBreakMode);
}

- (NSWritingDirection)dw_baseWritingDirection {
    DWParagraphAttribute(baseWritingDirection);
}

- (NSWritingDirection)dw_baseWritingDirectionAtIndex:(NSUInteger)index {
    DWParagraphAttributeAtIndex(baseWritingDirection);
}

- (CGFloat)dw_lineHeightMultiple {
    DWParagraphAttribute(lineHeightMultiple);
}

- (CGFloat)dw_lineHeightMultipleAtIndex:(NSUInteger)index {
    DWParagraphAttributeAtIndex(lineHeightMultiple);
}

- (CGFloat)dw_paragraphSpacingBefore {
    DWParagraphAttribute(paragraphSpacingBefore);
}

- (CGFloat)dw_paragraphSpacingBeforeAtIndex:(NSUInteger)index {
    DWParagraphAttributeAtIndex(paragraphSpacingBefore);
}

- (NSArray<NSTextTab *> *)dw_tabStops {
    DWParagraphAttribute(tabStops);
}

- (NSArray<NSTextTab *> *)dw_tabStopsAtIndex:(NSUInteger)index {
    DWParagraphAttributeAtIndex(tabStops);
}

- (CGFloat)dw_defaultTabInterval {
    DWParagraphAttribute(defaultTabInterval);
}

- (CGFloat)dw_defaultTabIntervalAtIndex:(NSUInteger)index {
    DWParagraphAttributeAtIndex(defaultTabInterval);
}

- (NSRange)dw_rangeOfAll {
    return NSMakeRange(0, self.length);
}

@end

@implementation NSMutableAttributedString (DWKit)

- (void)dw_setAttributes:(NSDictionary<NSString *, id> *)attributes {
    if (attributes == (id)[NSNull null]) {
        attributes = nil;
    }
    [self setAttributes:@{} range:self.dw_rangeOfAll];
    [attributes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self dw_setAttribute:key value:obj];
    }];
}

- (void)dw_setAttribute:(NSString *)name value:(id)value {
    [self dw_setAttribute:name value:value range:self.dw_rangeOfAll];
}

- (void)dw_setAttribute:(NSString *)name value:(id)value range:(NSRange)range {
    if (!name || [NSNull isEqual:name]) {
        return;
    }
    if (value && ![NSNull isEqual:value]) {
        [self addAttribute:name value:value range:range];
    } else {
        [self removeAttribute:name range:range];
    }
}

- (void)dw_removeAttributesInRange:(NSRange)range {
    [self setAttributes:nil range:range];
}

- (void)dw_setFont:(UIFont *)font {
    [self dw_setFont:font range:self.dw_rangeOfAll];
}

- (void)dw_setFont:(UIFont *)font range:(NSRange)range {
    [self dw_setAttribute:NSFontAttributeName value:font range:range];
}

- (void)dw_setParagraphStyle:(NSParagraphStyle *)style {
    [self dw_setParagraphStyle:style range:self.dw_rangeOfAll];
}
- (void)dw_setParagraphStyle:(NSParagraphStyle *)style range:(NSRange)range {
    [self dw_setAttribute:NSParagraphStyleAttributeName value:style range:range];
}

- (void)dw_setForegroundColor:(UIColor *)color {
    [self dw_setForegroundColor:color range:self.dw_rangeOfAll];
}

- (void)dw_setForegroundColor:(UIColor *)color range:(NSRange)range {
    [self dw_setAttribute:NSForegroundColorAttributeName value:color range:range];
}

- (void)dw_setBackgroundColor:(UIColor *)color {
    [self dw_setBackgroundColor:color range:self.dw_rangeOfAll];
}
- (void)dw_setBackgroundColor:(UIColor *)color range:(NSRange)range {
    [self dw_setAttribute:NSBackgroundColorAttributeName value:color range:range];
}

- (void)dw_setLigature:(NSNumber *)ligature {
    [self dw_setLigature:ligature range:self.dw_rangeOfAll];
}

- (void)dw_setLigature:(NSNumber *)ligature range:(NSRange)range {
    [self dw_setAttribute:NSLigatureAttributeName value:ligature range:range];
}

- (void)dw_setKern:(NSNumber *)kern {
    [self dw_setKern:kern range:self.dw_rangeOfAll];
}

- (void)dw_setKern:(NSNumber *)kern range:(NSRange)range {
    [self dw_setAttribute:NSKernAttributeName value:kern range:range];
}

- (void)dw_setStrikethroughStyle:(NSUnderlineStyle)style {
    [self dw_setStrikethroughStyle:style range:self.dw_rangeOfAll];
}

- (void)dw_setStrikethroughStyle:(NSUnderlineStyle)style range:(NSRange)range {
    NSNumber *number = style == 0 ? nil : @(style);
    [self dw_setAttribute:NSStrikethroughStyleAttributeName value:number range:range];
}

- (void)dw_setUnderlineStyle:(NSUnderlineStyle)style {
    [self dw_setUnderlineStyle:style range:self.dw_rangeOfAll];
}
- (void)dw_setUnderlineStyle:(NSUnderlineStyle)style range:(NSRange)range {
    NSNumber *number = style == 0 ? nil : @(style);
    [self dw_setAttribute:NSUnderlineStyleAttributeName value:number range:range];
}

- (void)dw_setStrokeColor:(UIColor *)color {
    [self dw_setStrokeColor:color range:self.dw_rangeOfAll];
}

- (void)dw_setStrokeColor:(UIColor *)color range:(NSRange)range {
    [self dw_setAttribute:NSStrokeColorAttributeName value:color range:range];
}

- (void)dw_setStrokeWidth:(NSNumber *)strokeWidth {
    [self dw_setStrokeWidth:strokeWidth range:self.dw_rangeOfAll];
}

- (void)dw_setStrokeWidth:(NSNumber *)strokeWidth range:(NSRange)range {
    [self dw_setAttribute:NSStrokeWidthAttributeName value:strokeWidth range:range];
}

- (void)dw_setShadow:(NSShadow *)shadow {
    [self dw_setShadow:shadow range:self.dw_rangeOfAll];
}

- (void)dw_setShadow:(NSShadow *)shadow range:(NSRange)range {
    [self dw_setAttribute:NSShadowAttributeName value:shadow range:range];
}

- (void)dw_setTextEffect:(NSString *)textEffect {
    [self dw_setTextEffect:textEffect range:self.dw_rangeOfAll];
}

- (void)dw_setTextEffect:(NSString *)textEffect range:(NSRange)range {
    [self dw_setAttribute:NSTextEffectAttributeName value:textEffect range:range];
}

- (void)dw_setAttachment:(NSTextAttachment *)attachment {
    [self dw_setAttachment:attachment range:self.dw_rangeOfAll];
}

- (void)dw_setAttachment:(NSTextAttachment *)attachment range:(NSRange)range {
    [self dw_setAttribute:NSAttachmentAttributeName value:attachment range:range];
}

- (void)dw_setBaselineOffset:(NSNumber *)baselineOffset {
    [self dw_setBaselineOffset:baselineOffset range:self.dw_rangeOfAll];
}

- (void)dw_setBaselineOffset:(NSNumber *)baselineOffset range:(NSRange)range {
    [self dw_setAttribute:NSBaselineOffsetAttributeName value:baselineOffset range:range];
}

- (void)dw_setUnderlineColor:(UIColor *)underlineColor {
    [self dw_setUnderlineColor:underlineColor range:self.dw_rangeOfAll];
}
- (void)dw_setUnderlineColor:(UIColor *)underlineColor range:(NSRange)range {
    [self dw_setAttribute:NSUnderlineColorAttributeName value:underlineColor range:range];
}

- (void)dw_setStrikethroughColor:(UIColor *)color {
    [self dw_setStrikethroughColor:color range:self.dw_rangeOfAll];
}

- (void)dw_setStrikethroughColor:(UIColor *)color range:(NSRange)range {
    [self dw_setAttribute:NSStrikethroughColorAttributeName value:color range:range];
}

- (void)dw_setObliqueness:(NSNumber *)obliqueness {
    [self dw_setObliqueness:obliqueness range:self.dw_rangeOfAll];
}

- (void)dw_setObliqueness:(NSNumber *)obliqueness range:(NSRange)range {
    [self dw_setAttribute:NSObliquenessAttributeName value:obliqueness range:range];
}

- (void)dw_setExpansion:(NSNumber *)expansion {
    [self dw_setExpansion:expansion range:self.dw_rangeOfAll];
}

- (void)dw_setExpansion:(NSNumber *)expansion range:(NSRange)range {
    [self dw_setAttribute:NSExpansionAttributeName value:expansion range:range];
}

- (void)dw_setWritingDirection:(NSArray<NSNumber *> *)writingDirection {
    [self dw_setWritingDirection:writingDirection range:self.dw_rangeOfAll];
}

- (void)dw_setWritingDirection:(NSArray<NSNumber *> *)writingDirection range:(NSRange)range {
    [self dw_setAttribute:NSWritingDirectionAttributeName value:writingDirection range:range];
}

- (void)dw_setVerticalGlyphForm:(BOOL)verticalGlyphForm {
    [self dw_setVerticalGlyphForm:verticalGlyphForm range:self.dw_rangeOfAll];
}
- (void)dw_setVerticalGlyphForm:(BOOL)verticalGlyphForm range:(NSRange)range {
    NSNumber *number = verticalGlyphForm ? @(YES) : nil;
    [self dw_setAttribute:NSVerticalGlyphFormAttributeName value:number range:range];
}

#pragma mark - paragraph attribute

#define DWParagraphStyleSet(_attr_) \
[self enumerateAttribute:NSParagraphStyleAttributeName \
                 inRange:range \
                 options:kNilOptions \
              usingBlock:^(NSParagraphStyle *value, NSRange subRange, BOOL * _Nonnull stop) { \
                  NSMutableParagraphStyle *style = nil; \
                  if (value) { \
                      if (value._attr_ == _attr_) { \
                          return ; \
                      } \
                      if ([value isKindOfClass:[NSMutableParagraphStyle class]]) { \
                          style = (id)value; \
                      } else { \
                          style = value.mutableCopy; \
                      } \
                  } else { \
                      if ([NSParagraphStyle defaultParagraphStyle]._attr_ == _attr_) { \
                          return ; \
                      } \
                      style = [NSParagraphStyle defaultParagraphStyle].mutableCopy; \
                  } \
                  style. _attr_ = _attr_; \
                  [self dw_setParagraphStyle:style range:subRange]; \
              }];

- (void)dw_setLineSpacing:(CGFloat)lineSpacing {
    [self dw_setLineSpacing:lineSpacing range:self.dw_rangeOfAll];
}

- (void)dw_setLineSpacing:(CGFloat)lineSpacing range:(NSRange)range {
    DWParagraphStyleSet(lineSpacing);
}

- (void)dw_setParagraphSpacing:(CGFloat)paragraphSpacing {
    [self dw_setParagraphSpacing:paragraphSpacing range:self.dw_rangeOfAll];
}

- (void)dw_setParagraphSpacing:(CGFloat)paragraphSpacing range:(NSRange)range {
    DWParagraphStyleSet(paragraphSpacing);
}

- (void)dw_setAlignment:(NSTextAlignment)alignment {
    [self dw_setAlignment:alignment range:self.dw_rangeOfAll];
}

- (void)dw_setAlignment:(NSTextAlignment)alignment range:(NSRange)range {
    DWParagraphStyleSet(alignment);
}

- (void)dw_setHeadIndent:(CGFloat)headIndent {
    [self dw_setHeadIndent:headIndent range:self.dw_rangeOfAll];
}

- (void)dw_setHeadIndent:(CGFloat)headIndent range:(NSRange)range {
    DWParagraphStyleSet(headIndent);
}

- (void)dw_setTailIndent:(CGFloat)tailIndent {
    [self dw_setTailIndent:tailIndent range:self.dw_rangeOfAll];
}

- (void)dw_setTailIndent:(CGFloat)tailIndent range:(NSRange)range {
    DWParagraphStyleSet(tailIndent);
}

- (void)dw_setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent {
    [self dw_setFirstLineHeadIndent:firstLineHeadIndent range:self.dw_rangeOfAll];
}

- (void)dw_setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent range:(NSRange)range {
    DWParagraphStyleSet(firstLineHeadIndent);
}

- (void)dw_setMinimumLineHeight:(CGFloat)minimumLineHeight {
    [self dw_setMinimumLineHeight:minimumLineHeight range:self.dw_rangeOfAll];
}

- (void)dw_setMinimumLineHeight:(CGFloat)minimumLineHeight range:(NSRange)range {
    DWParagraphStyleSet(minimumLineHeight);
}

- (void)dw_setMaximumLineHeight:(CGFloat)maximumLineHeight {
    [self dw_setMaximumLineHeight:maximumLineHeight range:self.dw_rangeOfAll];
}

- (void)dw_setMaximumLineHeight:(CGFloat)maximumLineHeight range:(NSRange)range {
    DWParagraphStyleSet(maximumLineHeight);
}

- (void)dw_setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    [self dw_setLineBreakMode:lineBreakMode range:self.dw_rangeOfAll];
}
- (void)dw_setLineBreakMode:(NSLineBreakMode)lineBreakMode range:(NSRange)range {
    DWParagraphStyleSet(lineBreakMode);
}

- (void)dw_setBaseWritingDirection:(NSWritingDirection)baseWritingDirection {
    [self dw_setBaseWritingDirection:baseWritingDirection range:self.dw_rangeOfAll];
}

- (void)dw_setBaseWritingDirection:(NSWritingDirection)baseWritingDirection range:(NSRange)range {
    DWParagraphStyleSet(baseWritingDirection);
}

- (void)dw_setLineHeightMultiple:(CGFloat)lineHeightMultiple {
    [self dw_setLineHeightMultiple:lineHeightMultiple range:self.dw_rangeOfAll];
}

- (void)dw_setLineHeightMultiple:(CGFloat)lineHeightMultiple range:(NSRange)range {
    DWParagraphStyleSet(lineHeightMultiple);
}

- (void)dw_setParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore {
    [self dw_setParagraphSpacingBefore:paragraphSpacingBefore range:self.dw_rangeOfAll];
}

- (void)dw_setParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore range:(NSRange)range {
    DWParagraphStyleSet(paragraphSpacingBefore);
}

- (void)dw_setTabStops:(NSArray<NSTextTab *> *)tabStops {
    [self dw_setTabStops:tabStops range:self.dw_rangeOfAll];
}

- (void)dw_setTabStops:(NSArray<NSTextTab *> *)tabStops range:(NSRange)range {
    DWParagraphStyleSet(tabStops);
}

- (void)dw_setDefaultTabInterval:(CGFloat)defaultTabInterval {
    [self dw_setDefaultTabInterval:defaultTabInterval range:self.dw_rangeOfAll];
}
- (void)dw_setDefaultTabInterval:(CGFloat)defaultTabInterval range:(NSRange)range {
    DWParagraphStyleSet(defaultTabInterval);
}


@end

