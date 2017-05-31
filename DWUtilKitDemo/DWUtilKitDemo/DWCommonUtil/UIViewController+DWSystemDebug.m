//
//  UIViewController+DWSystemDebug.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/5/27.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "UIViewController+DWSystemDebug.h"

@implementation UIViewController (DWSystemDebug)

- (void)dw_showSystemDebuggingInfomationOverlay {
// http://developer.limneos.net/?ios=9.3.3&framework=UIKit.framework&header=UIDebuggingInformationOverlay.h
// http://ryanipete.com/blog/ios/swift/objective-c/uidebugginginformationoverlay/
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    id debugClass = NSClassFromString(@"UIDebuggingInformationOverlay");
    SEL prepareDebuggingOverlay = NSSelectorFromString(@"prepareDebuggingOverlay");
    if ([debugClass respondsToSelector:prepareDebuggingOverlay]) {
        [debugClass performSelector:prepareDebuggingOverlay];
    } else {
        return;
    }
    SEL overlay = NSSelectorFromString(@"overlay");
    id debugOverlay;
    if ([debugClass respondsToSelector:overlay]) {
        debugOverlay = [debugClass performSelector:overlay];
    } else {
        return;
    }
    SEL toggleVisibility = NSSelectorFromString(@"toggleVisibility");
    if ([debugOverlay respondsToSelector:toggleVisibility]) {
        [debugOverlay performSelector:toggleVisibility];
    }
#pragma clang diagnostic pop
}

@end
