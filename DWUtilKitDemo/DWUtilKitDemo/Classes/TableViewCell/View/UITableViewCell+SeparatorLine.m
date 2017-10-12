//
//  UITableViewCell+SeparatorLine.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/9/2.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "UITableViewCell+SeparatorLine.h"
#import <objc/runtime.h>

static void *kTableView = &kTableView;
static void *kLastCellEdgeInset = &kLastCellEdgeInset;
static void *kFirstCellTopSeparatorLine = &kFirstCellTopSeparatorLine;
static void *kLastCellBottomSeparatorLine = &kLastCellBottomSeparatorLine;

@implementation UITableViewCell (SeparatorLine)

//+ (void)initialize {
//    if (self != [UITableViewCell class]) {
//        return;
//    }
//    
//    NSArray *selArr = @[@"layoutSubviews", @"removeFromSuperview"];
//    
//    for (NSString *selStr in selArr) {
//        SEL originalSelector = NSSelectorFromString(selStr);
//        SEL swizzledSelector = NSSelectorFromString([NSString stringWithFormat:@"_dw_%@",selStr]);
//        
//        Method originalMethod = class_getInstanceMethod(self, originalSelector);
//        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
//        if (!originalMethod || !swizzledMethod) {
//            continue;
//        }
//        BOOL didAddMethod = class_addMethod(self,originalSelector,method_getImplementation(swizzledMethod),method_getTypeEncoding(swizzledMethod));
//        
//        if (didAddMethod) {
//            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//        } else {
//            method_exchangeImplementations(originalMethod, swizzledMethod);
//        }
//    }
//}
//
//- (void)_dw_layoutSubviews {
//
//}
//
//- (void)_dw_removeFromSuperview {
//    [self _dw_removeFromSuperview];
//}

@end
