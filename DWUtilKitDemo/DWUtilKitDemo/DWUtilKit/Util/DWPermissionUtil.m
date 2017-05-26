//
//  DWPermissionUtil.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/4/5.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DWPermissionUtil.h"
#import "DWUtilities.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@implementation DWPermissionUtil

+ (BOOL)dw_isCameraAccess {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
        return NO;
    } else {
        return YES;
    }
}

+ (BOOL)dw_isPhotoLibraryAccess {
    if (DWDeviceSystemMajorVersion() < 8.0) {
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        if (status == ALAuthorizationStatusDenied || status == ALAuthorizationStatusRestricted) {
            return NO;
        }
    } else {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)dw_isNotificationEnabled {
#if !defined(IS_EXTENSION_TARGET)
    if (DWDeviceSystemMajorVersion() < 8.0) {
        UIRemoteNotificationType notificationType = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
        return (notificationType != UIRemoteNotificationTypeNone);
    } else if (DWDeviceSystemMajorVersion() >= 8.0 && DWDeviceSystemMajorVersion() <10) {
        UIUserNotificationSettings * setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        const UIUserNotificationType notificationType = setting.types;
        return (notificationType != UIUserNotificationTypeNone);
    } else {
        __block BOOL notificationsAlertAuthorization = NO;
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (settings.alertSetting == UNNotificationSettingEnabled ||
                settings.soundSetting == UNNotificationSettingEnabled ||
                settings.badgeSetting == UNNotificationSettingEnabled ) {
                notificationsAlertAuthorization = YES;
            }
        }];
        return notificationsAlertAuthorization;
    }
#else
    // extension不支持
#endif
    return NO;
}

+ (BOOL)dw_openSystemSettingInterface {
    NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:settingUrl]) {
        [[UIApplication sharedApplication] openURL:settingUrl];
        return YES;
    } else {
        return NO;
    }
}

@end
