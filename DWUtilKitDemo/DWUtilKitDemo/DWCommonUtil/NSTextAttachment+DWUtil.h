//
//  NSTextAttachment+DWUtil.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/5/10.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSTextAttachment (DWUtil)

@property (nonatomic, copy) NSString *dw_imageSrc;

+ (NSString *)dw_createImageSrcWithKey:(NSString *)imageLink;

@end
