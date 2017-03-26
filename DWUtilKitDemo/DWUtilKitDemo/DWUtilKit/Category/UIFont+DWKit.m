//
//  UIFont+DWKit.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/12.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "UIFont+DWKit.h"
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>

@implementation UIFont (DWKit)

- (BOOL)isBold {
    if (![self respondsToSelector:@selector(fontDescriptor)]) {
        return NO;
    }
    return (self.fontDescriptor.symbolicTraits & UIFontDescriptorTraitBold) > 0;
}

- (BOOL)isItalic {
    if (![self respondsToSelector:@selector(fontDescriptor)]) {
        return NO;
    }
    return (self.fontDescriptor.symbolicTraits & UIFontDescriptorTraitItalic) > 0;
}

- (BOOL)isMonoSpace {
    if (![self respondsToSelector:@selector(fontDescriptor)]) {
        return NO;
    }
    return (self.fontDescriptor.symbolicTraits & UIFontDescriptorTraitMonoSpace) > 0;
}

- (BOOL)isColorGlyphs {
    if (![self respondsToSelector:@selector(fontDescriptor)]) {
        return NO;
    }
    return (CTFontGetSymbolicTraits((__bridge CTFontRef) self) & kCTFontColorGlyphsTrait) != 0;
}

- (CGFloat)fontWeight {
    NSDictionary *traits = [self.fontDescriptor objectForKey:UIFontDescriptorTraitsAttribute];;
    return [traits[UIFontWeightTrait] floatValue];
}

- (UIFont *)dw_fontWithBold {
    if (![self respondsToSelector:@selector(fontDescriptor)]) {
        return self;
    }
    return [UIFont fontWithDescriptor:[self.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold] size:self.pointSize];
}

- (UIFont *)dw_fontWithItalic {
    if (![self respondsToSelector:@selector(fontDescriptor)]) {
        return self;
    }
    return [UIFont fontWithDescriptor:[self.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic] size:self.pointSize];
}

- (UIFont *)dw_fontWithBoldItalic {
    if (![self respondsToSelector:@selector(fontDescriptor)]) {
        return self;
    }
    return [UIFont fontWithDescriptor:[self.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold | UIFontDescriptorTraitItalic] size:self.pointSize];
}

- (UIFont *)dw_fontWithNormal {
    if (![self respondsToSelector:@selector(fontDescriptor)]) {
        return self;
    }
    return [UIFont fontWithDescriptor:[self.fontDescriptor fontDescriptorWithSymbolicTraits:0] size:self.pointSize];
}

@end
