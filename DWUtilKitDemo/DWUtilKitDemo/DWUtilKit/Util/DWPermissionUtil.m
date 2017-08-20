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
#import <CoreTelephony/CTCellularData.h>

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

+ (void)dw_cameraAccess:(DWAccessResult)result completionHandler:(DWCompletionHandler)handler {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        if (result) result(DWAuthorizationStatusNotInstall);
        return;
    }
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (result) result((DWAuthorizationStatus)status);
    if (status == DWAuthorizationStatusNotDetermined && handler) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:handler];
    }
}

+ (BOOL)dw_isPhotoLibraryAccess {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
        return NO;
    } else {
        return YES;
    }
}

+ (void)dw_photoLibraryAccess:(DWAccessResult)result completionHandler:(DWCompletionHandler)handler {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (result) result((DWAuthorizationStatus)status);
    if (status == PHAuthorizationStatusNotDetermined && handler) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                handler(YES);
            } else {
                handler(NO);
            }
        }];
    }
}

+ (BOOL)dw_isNotificationEnabled {
    if (DWDeviceSystemMajorVersion() >= 8.0 && DWDeviceSystemMajorVersion() <10) {
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
