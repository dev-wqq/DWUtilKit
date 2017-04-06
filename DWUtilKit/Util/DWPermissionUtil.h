//
//  DWPermissionUtil.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/4/5.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWPermissionUtil : NSObject

/**
 判断是否支持访问摄像头
 */
+ (BOOL)dw_isCameraAccess NS_AVAILABLE_IOS(7.0);

/**
 判断是否支持访问相册
 */
+ (BOOL)dw_isPhotoLibraryAccess;

/**
 判断推送是否打开
 */
+ (BOOL)dw_isNotificationEnabled;

@end
