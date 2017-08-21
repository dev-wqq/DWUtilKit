//
//  DWPermissionUtil.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/4/5.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DWAuthorizationStatus) {
    DWAuthorizationStatusNotInstall = -1,
    DWAuthorizationStatusNotDetermined = 0,
    DWAuthorizationStatusRestricted,
    DWAuthorizationStatusDenied,
    DWAuthorizationStatusAuthorized,
};

typedef void(^DWAccessResult)(DWAuthorizationStatus status);

typedef void(^DWCompletionHandler)(BOOL granted);

@interface DWPermissionUtil : NSObject

/**
 判断是否支持访问摄像头
 */
+ (BOOL)dw_isCameraAccess NS_AVAILABLE_IOS(7.0);

+ (void)dw_cameraAccess:(DWAccessResult)result completionHandler:(DWCompletionHandler)handler NS_AVAILABLE_IOS(7.0);

/**
 判断是否支持访问相册
 */
+ (BOOL)dw_isPhotoLibraryAccess NS_AVAILABLE_IOS(8.0);

+ (void)dw_photoLibraryAccess:(DWAccessResult)result completionHandler:(DWCompletionHandler)handler NS_AVAILABLE_IOS(8.0);

/**
 判断推送是否打开
 */
+ (BOOL)dw_isNotificationEnabled NS_AVAILABLE_IOS(8.0);

/**
 前往设置界面
 */
+ (BOOL)dw_openSystemSettingInterface;


@end
