//
//  DWUtilities.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/23.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  main screen's scale
 */
#ifndef kScreenScale
#define kScreenScale DWScreenScale()
#endif

/**
 *  main screen's size (portrait)
 */
#ifndef kScreenSize
#define kScreenSize DWScreenSize()
#endif

/**
 *  main screen's width (portrait)
 */
#ifndef kScreenWidth
#define kScreenWidth DWScreenSize().width
#endif

/**
 *  main screen's height (portrait)
 */
#ifndef kScreenHeight
#define kScreenHeight DWScreenSize().height
#endif

#ifndef kNavigationBarHeight
#define kNavigationBarHeight 64
#endif

#ifndef kStatusBarHeight
#define kStatusBarHeight 20
#endif

#ifndef kTabBarHeight
#define kTabBarHeight 49
#endif

/**
 *  marco define __weak
 */
#define kWeakSelf(weakSelf) __weak typeof(&*self) weakSelf = self;

/**
 *  Get main screen's scale.
 */
CGFloat DWScreenScale();

/**
 *  Get main screen's size. Height is always larger than width.
 */
CGSize DWScreenSize();

/**
 *  Get device system major version
 */
NSUInteger DWDeviceSystemMajorVersion();

/**
 *  Convert degrees to radians.
 */
CG_INLINE CGFloat DWDegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}

/**
 *  Convert radians to degrees.
 */
CG_INLINE CGFloat DWRadiansToDegrees(CGFloat radians) {
    return radians * 180 / M_PI;
}

/**
 *  Convert point to pixel.
 */
CG_INLINE CGFloat CGFloatToPixel(CGFloat value) {
    return value * DWScreenScale();
}

/**
 *  Convert pixel to point.
 */
CG_INLINE CGFloat CGFloatFromPixel(CGFloat value) {
    return value / DWScreenScale();
}

#pragma mark - UI Help

/**
 *  UED design main screen's width (portrait)
 */
#ifndef kScreen_UED_Width
#define kScreen_UED_Width 375
#endif

/**
 *  UED design main screen's height (portrait)
 */
#ifndef kScreen_UED_Height
#define kScreen_UED_Height 667
#endif

CG_INLINE CGFloat DWAutoScaleX(const CGFloat value) {
    return kScreenWidth / kScreen_UED_Width * value;
}

CG_INLINE CGFloat DWAutoScaleY(const CGFloat value) {
    return kScreenHeight / kScreen_UED_Height * value;
}

CG_INLINE CGFloat DWAutoScaleY_noNavigationBar (const CGFloat value) {
    return (kScreenHeight - kNavigationBarHeight) / (kScreen_UED_Height - kNavigationBarHeight) * value;
}

CG_INLINE CGFloat DWAutoScaleY_noTabBar(const CGFloat value) {
    return (kScreenHeight - kTabBarHeight) / (kScreen_UED_Height - kTabBarHeight) * value;
}

CG_INLINE CGFloat DWAutoScaleY_noBar(const CGFloat value) {
    return (kScreenHeight-kNavigationBarHeight-kTabBarHeight) / (kScreen_UED_Height-kNavigationBarHeight-kTabBarHeight) * value;
}

CG_INLINE CGRect GHRectMake(const CGFloat x, const CGFloat y, const CGFloat width, const CGFloat height) {
    CGRect rect;
    rect.origin.x = DWAutoScaleX(x);
    rect.size.width = DWAutoScaleX(width);
    rect.origin.y = DWAutoScaleY(y);
    rect.size.height = DWAutoScaleY(height);
    return rect;
}

CG_INLINE CGRect GHRectMakeByRect(const CGRect rect) {
    return GHRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

CG_INLINE CGSize GHSizeMake(const CGFloat width, const CGFloat height) {
    CGSize resultSize;
    resultSize.width = DWAutoScaleX(width);
    resultSize.height = DWAutoScaleY(height);
    return resultSize;
}

CG_INLINE CGSize GHSizeMakeBySize(const CGSize size) {
    return GHSizeMake(size.width, size.height);
}

NS_INLINE NSUInteger CellCountInOnePage(CGFloat estimatedCellHeight, CGFloat tableViewHeight) {
    NSUInteger count = tableViewHeight / estimatedCellHeight;
    return count < 10 ? 10 : count;
}

NS_INLINE CGFloat XCenterInContainer(CGFloat width, CGFloat containerWidth) {
    return containerWidth/2-width/2;
}

NS_INLINE CGFloat YCenterInContainer(CGFloat height, CGFloat containerHeight) {
    return containerHeight/2-height/2;
}

NS_INLINE CGFloat AspectRatioWidth(CGFloat width, CGFloat height, CGFloat targetHeight) {
    return targetHeight*width/height;
}

NS_INLINE CGFloat AspectRatioHeight(CGFloat width, CGFloat height, CGFloat targetWidth) {
    return targetWidth*height/width;
}

NS_INLINE CGFloat AspectRatioWidthWithSize(CGSize size, CGFloat targetHeight) {
    return AspectRatioHeight(size.width, size.height, targetHeight);
}

NS_INLINE CGFloat AspectRatioHeightWithSize(CGSize size, CGFloat targetWidth) {
    return AspectRatioWidth(size.width, size.height, targetWidth);
}

#pragma mark - For iPhone 4/4s adapter

CG_INLINE CGFloat DWForHeight480(const CGFloat value1, const CGFloat value2) {
    return kScreenHeight == 480 ? value1 : value2;
}

CG_INLINE CGFloat DWForWith320(const CGFloat value1, const CGFloat value2) {
    return kScreenWidth == 320 ? value1 : value2;
}

