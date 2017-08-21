//
//  NSAttributedString+DWKit.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/12.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (DWKit)

/**
 @return AttributedString, use system method conver
 */
+ (NSAttributedString *)dw_attributedStringWithHtmlString:(NSString *)htmlString;

/**
 @return htmlString, use system method conver
 */
+ (NSString *)dw_htmlStringWithAttributdString:(NSAttributedString *)attrs;

/**
 @return the attributes at first character.
 */
- (NSDictionary *)dw_attributes;

/**
 @return the attributes for the charactor at given index.
 */
- (NSDictionary *)dw_attributesAtIndex:(NSUInteger)index;

/**
 @return the value for an attribute with a given name of the character at a given index.
 */
- (id)dw_attribute:(NSString *)attributeName atIndex:(NSUInteger)index;

/**
 @return the font at first character.
 */
- (UIFont *)dw_font;
- (UIFont *)dw_fontAtIndex:(NSUInteger)index;

- (NSParagraphStyle *)dw_paragraphStyle;
- (NSParagraphStyle *)dw_paragraphStyleAtIndex:(NSUInteger)index;

- (UIColor *)dw_foregroundColor;
- (UIColor *)dw_foregroundColorAtIndex:(NSUInteger)index;

- (UIColor *)dw_backgroundColor;
- (UIColor *)dw_backgroundColorAtIndex:(NSUInteger)index;

- (NSNumber *)dw_ligature;
- (NSNumber *)dw_ligatureAtIndex:(NSUInteger)index;

- (NSNumber *)dw_kern;
- (NSNumber *)dw_kernAtIndex:(NSUInteger)index;

- (NSUnderlineStyle)dw_strikethroughStyle;
- (NSUnderlineStyle)dw_strikethroughStyleAtIndex:(NSUInteger)index;

- (NSUnderlineStyle)dw_underlineStyle;
- (NSUnderlineStyle)dw_underlineStyleAtIndex:(NSUInteger)index;

- (UIColor *)dw_strokeColor;
- (UIColor *)dw_strokeColorAtIndex:(NSUInteger)index;

- (NSNumber *)dw_strokeWidth;
- (NSNumber *)dw_strokeWidthAtIndex:(NSUInteger)index;

- (NSShadow *)dw_shadow;
- (NSShadow *)dw_shadowAtIndex:(NSUInteger)index;

- (NSString *)dw_textEffect;
- (NSString *)dw_textEffectAtIndex:(NSUInteger)index;

- (NSTextAttachment *)dw_attachment;
- (NSTextAttachment *)dw_attachmentAtIndex:(NSUInteger)index;

- (NSNumber *)dw_baselineOffset;
- (NSNumber *)dw_baselineOffsetAtIndex:(NSUInteger)index;

- (UIColor *)dw_underlineColor;
- (UIColor *)dw_underlineColorAtIndex:(NSUInteger)index;

- (UIColor *)dw_strikethroughColor;
- (UIColor *)dw_strikethroughColorAtIndex:(NSUInteger)index;

- (NSNumber *)dw_obliqueness;
- (NSNumber *)dw_obliquenessAtIndex:(NSUInteger)index;

- (NSNumber *)dw_expansion;
- (NSNumber *)dw_expansionAtIndex:(NSUInteger)index;

- (NSArray<NSNumber *> *)dw_writingDirection;
- (NSArray<NSNumber *> *)dw_writingDirectionAtIndex:(NSUInteger)index;


- (BOOL)dw_verticalGlyphForm;
- (BOOL)dw_verticalGlyphFormAtIndex:(NSUInteger)index;

#pragma mark - paragraph attribute

- (CGFloat)dw_lineSpacing;
- (CGFloat)dw_lineSpacingAtIndex:(NSUInteger)index;

- (CGFloat)dw_paragraphSpacing;
- (CGFloat)dw_paragraphSpacingAtIndex:(NSUInteger)index;

- (NSTextAlignment)dw_alignment;
- (NSTextAlignment)dw_alignmentAtIndex:(NSUInteger)index;

- (CGFloat)dw_headIndent;
- (CGFloat)dw_headIndentAtIndex:(NSUInteger)index;

- (CGFloat)dw_tailIndent;
- (CGFloat)dw_tailIndentAtIndex:(NSUInteger)index;

- (CGFloat)dw_firstLineHeadIndent;
- (CGFloat)dw_firstLineHeadIndentAtIndex:(NSUInteger)index;

- (CGFloat)dw_minimumLineHeight;
- (CGFloat)dw_minimumLineHeightAtIndex:(NSUInteger)index;

- (CGFloat)dw_maximumLineHeight;
- (CGFloat)dw_maximumLineHeightAtIndex:(NSUInteger)index;

- (NSLineBreakMode)dw_lineBreakMode;
- (NSLineBreakMode)dw_lineBreakModeAtIndex:(NSUInteger)index;

- (NSWritingDirection)dw_baseWritingDirection;
- (NSWritingDirection)dw_baseWritingDirectionAtIndex:(NSUInteger)index;

- (CGFloat)dw_lineHeightMultiple;
- (CGFloat)dw_lineHeightMultipleAtIndex:(NSUInteger)index;

- (CGFloat)dw_paragraphSpacingBefore;
- (CGFloat)dw_paragraphSpacingBeforeAtIndex:(NSUInteger)index;

- (NSArray<NSTextTab *> *)dw_tabStops;
- (NSArray<NSTextTab *> *)dw_tabStopsAtIndex:(NSUInteger)index;

- (CGFloat)dw_defaultTabInterval;
- (CGFloat)dw_defaultTabIntervalAtIndex:(NSUInteger)index;

- (NSRange)dw_rangeOfAll;

@end

@interface NSMutableAttributedString (DWKit)

/**
 sets the attributes to the entire text string.
 */
- (void)dw_setAttributes:(NSDictionary<NSString *, id> *)attributes;

/**
 sets an attribute with the given name and value to the entire text string.
 */
- (void)dw_setAttribute:(NSString *)name value:(id)value;

/**
  sets an attribute with the given name and value to the characters in the specified range.
 */
- (void)dw_setAttribute:(NSString *)name value:(id)value range:(NSRange)range;

/**
 removes all attributes in the specified range.
 */
- (void)dw_removeAttributesInRange:(NSRange)range;

- (void)dw_setFont:(UIFont *)font;
- (void)dw_setFont:(UIFont *)font range:(NSRange)range;

- (void)dw_setParagraphStyle:(NSParagraphStyle *)style;
- (void)dw_setParagraphStyle:(NSParagraphStyle *)style range:(NSRange)range;

- (void)dw_setForegroundColor:(UIColor *)color;
- (void)dw_setForegroundColor:(UIColor *)color range:(NSRange)range;

- (void)dw_setBackgroundColor:(UIColor *)color;
- (void)dw_setBackgroundColor:(UIColor *)color range:(NSRange)range;

- (void)dw_setLigature:(NSNumber *)ligature;
- (void)dw_setLigature:(NSNumber *)ligature range:(NSRange)range;

- (void)dw_setKern:(NSNumber *)kern;
- (void)dw_setKern:(NSNumber *)kern range:(NSRange)range;

- (void)dw_setStrikethroughStyle:(NSUnderlineStyle)style;
- (void)dw_setStrikethroughStyle:(NSUnderlineStyle)style range:(NSRange)range;

- (void)dw_setUnderlineStyle:(NSUnderlineStyle)style;
- (void)dw_setUnderlineStyle:(NSUnderlineStyle)style range:(NSRange)range;

- (void)dw_setStrokeColor:(UIColor *)color;
- (void)dw_setStrokeColor:(UIColor *)color range:(NSRange)range;

- (void)dw_setStrokeWidth:(NSNumber *)strokeWidth;
- (void)dw_setStrokeWidth:(NSNumber *)strokeWidth range:(NSRange)range;

- (void)dw_setShadow:(NSShadow *)shadow;
- (void)dw_setShadow:(NSShadow *)shadow range:(NSRange)range;

- (void)dw_setTextEffect:(NSString *)textEffect;
- (void)dw_setTextEffect:(NSString *)textEffect range:(NSRange)range;

- (void)dw_setAttachment:(NSTextAttachment *)attachment;
- (void)dw_setAttachment:(NSTextAttachment *)attachment range:(NSRange)range;

- (void)dw_setBaselineOffset:(NSNumber *)baselineOffset;
- (void)dw_setBaselineOffset:(NSNumber *)baselineOffset range:(NSRange)range;

- (void)dw_setUnderlineColor:(UIColor *)underlineColor;
- (void)dw_setUnderlineColor:(UIColor *)underlineColor range:(NSRange)range;

- (void)dw_setStrikethroughColor:(UIColor *)color;
- (void)dw_setStrikethroughColor:(UIColor *)color range:(NSRange)range;

- (void)dw_setObliqueness:(NSNumber *)obliqueness;
- (void)dw_setObliqueness:(NSNumber *)obliqueness range:(NSRange)range;

- (void)dw_setExpansion:(NSNumber *)expansion;
- (void)dw_setExpansion:(NSNumber *)expansion range:(NSRange)range;

- (void)dw_setWritingDirection:(NSArray<NSNumber *> *)writingDirection;
- (void)dw_setWritingDirection:(NSArray<NSNumber *> *)writingDirection range:(NSRange)range;

- (void)dw_setVerticalGlyphForm:(BOOL)verticalGlyphForm;
- (void)dw_setVerticalGlyphForm:(BOOL)verticalGlyphForm range:(NSRange)range;

#pragma mark - paragraph attribute

- (void)dw_setLineSpacing:(CGFloat)lineSpacing;
- (void)dw_setLineSpacing:(CGFloat)lineSpacing range:(NSRange)range;

- (void)dw_setParagraphSpacing:(CGFloat)paragraphSpacing;
- (void)dw_setParagraphSpacing:(CGFloat)paragraphSpacing range:(NSRange)range;

- (void)dw_setAlignment:(NSTextAlignment)alignment;
- (void)dw_setAlignment:(NSTextAlignment)alignment range:(NSRange)range;

- (void)dw_setHeadIndent:(CGFloat)headIndent;
- (void)dw_setHeadIndent:(CGFloat)headIndent range:(NSRange)range;

- (void)dw_setTailIndent:(CGFloat)tailIndent;
- (void)dw_setTailIndent:(CGFloat)tailIndent range:(NSRange)range;

- (void)dw_setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent;
- (void)dw_setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent range:(NSRange)range;

- (void)dw_setMinimumLineHeight:(CGFloat)minimumLineHeight;
- (void)dw_setMinimumLineHeight:(CGFloat)minimumLineHeight range:(NSRange)range;

- (void)dw_setMaximumLineHeight:(CGFloat)maximumLineHeight;
- (void)dw_setMaximumLineHeight:(CGFloat)maximumLineHeight range:(NSRange)range;

- (void)dw_setLineBreakMode:(NSLineBreakMode)lineBreakMode;
- (void)dw_setLineBreakMode:(NSLineBreakMode)lineBreakMode range:(NSRange)range;

- (void)dw_setBaseWritingDirection:(NSWritingDirection)baseWritingDirection;
- (void)dw_setBaseWritingDirection:(NSWritingDirection)baseWritingDirection range:(NSRange)range;

- (void)dw_setLineHeightMultiple:(CGFloat)lineHeightMultiple;
- (void)dw_setLineHeightMultiple:(CGFloat)lineHeightMultiple range:(NSRange)range;

- (void)dw_setParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore;
- (void)dw_setParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore range:(NSRange)range;

- (void)dw_setTabStops:(NSArray<NSTextTab *> *)tabStops;
- (void)dw_setTabStops:(NSArray<NSTextTab *> *)tabStops range:(NSRange)range;

- (void)dw_setDefaultTabInterval:(CGFloat)defaultTabInterval;
- (void)dw_setDefaultTabInterval:(CGFloat)defaultTabInterval range:(NSRange)range;

@end

