//
//  UITextView+DWKit.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/20.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "UITextView+DWKit.h"
#import <objc/runtime.h>

@implementation UITextView (DWKit)

+ (void)load {
    // need not add [super load];
    // https://developer.apple.com/reference/objectivec/nsobject/1418815-load
    // http://stackoverflow.com/questions/34542316/does-method-load-need-to-call-super-load
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = NSSelectorFromString(@"dealloc");
        SEL swizzledSelector = @selector(_dw_swizzledDealloc);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (UILabel *)placeholderLabel {
    UILabel *label = objc_getAssociatedObject(self, @selector(placeholderLabel));
    if (!label) {
        NSAttributedString *originalText = self.attributedText;
        self.text = @" "; // lazily set font of `UITextView`.
        self.attributedText = originalText;
        
        label = [[UILabel alloc] init];
        label.textColor = [self.class dw_defaultPlaceholderColor];
        label.numberOfLines = 0;
        label.userInteractionEnabled = NO;
        objc_setAssociatedObject(self, @selector(placeholderLabel), label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_dw_updatePlaceholderLabelFrame) name:UITextViewTextDidChangeNotification object:self];
        for (NSString *key in [self.class _dw_observingKeys]) {
            [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    return label;
}

+ (UIColor *)dw_defaultPlaceholderColor {
    static UIColor *defaultColor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UITextField *textField = [[UITextField alloc] init];
        textField.placeholder = @" ";
        defaultColor = [textField valueForKeyPath:@"_placeholderLabel.textColor"];
    });
    return defaultColor;
}

#pragma mark - Setter And Getter

- (NSString *)placeholder {
    return self.placeholderLabel.text;
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.placeholderLabel.text = placeholder;
    [self _dw_updatePlaceholderLabelFrame];
}

- (UIColor *)placeholderColor {
    return self.placeholderLabel.textColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    self.placeholderLabel.textColor = placeholderColor;
}

- (NSAttributedString *)attributedPlaceholder {
    return self.placeholderLabel.attributedText;
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    self.placeholderLabel.attributedText = attributedPlaceholder;
    [self _dw_updatePlaceholderLabelFrame];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self _dw_updatePlaceholderLabelFrame];
}

#pragma mark - Private Method

- (void)_dw_swizzledDealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    UILabel *label = objc_getAssociatedObject(self, @selector(placeholderLabel));
    if (label) {
        for (NSString *key in [self.class _dw_observingKeys]) {
            @try {
                [self removeObserver:self forKeyPath:key];
            } @catch (NSException *exception) {
               
            }
        }
    }
    [self _dw_swizzledDealloc];
}

- (void)_dw_updatePlaceholderLabelFrame {
    if (self.text.length > 0) {
        [self.placeholderLabel removeFromSuperview];
        return;
    }
    [self insertSubview:self.placeholderLabel atIndex:0];
    self.placeholderLabel.font = self.font;
    self.placeholderLabel.textAlignment = self.textAlignment;
    
    CGFloat lineFragmentPadding = self.textContainer.lineFragmentPadding;
    UIEdgeInsets textContainerInset = self.textContainerInset;
    CGFloat x = lineFragmentPadding + textContainerInset.left;
    CGFloat y = textContainerInset.top;
    CGFloat width = CGRectGetWidth(self.bounds) - x - textContainerInset.right-lineFragmentPadding;
    CGFloat height = [self.placeholderLabel sizeThatFits:CGSizeMake(width, 0)].height;
    self.placeholderLabel.frame = CGRectMake(x, y, width, height);
}

+ (NSArray *)_dw_observingKeys {
    return @[@"text",@"font",@"textAlignment",@"attributedText",@"bounds",@"frame",@"textContainerInset"];
}

@end
