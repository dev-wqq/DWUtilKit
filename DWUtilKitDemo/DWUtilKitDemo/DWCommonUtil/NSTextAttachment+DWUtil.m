//
//  NSTextAttachment+DWUtil.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/5/10.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "NSTextAttachment+DWUtil.h"

static const void *kDWTextAttachmentImageUrl = &kDWTextAttachmentImageUrl;

@implementation NSTextAttachment (DWUtil)

- (void)setDw_imageSrc:(NSString *)dw_imageSrc {
    objc_setAssociatedObject(self, kDWTextAttachmentImageUrl, dw_imageSrc, OBJC_ASSOCIATION_COPY);
}

- (NSString *)dw_imageSrc {
    NSString *imageSrc = objc_getAssociatedObject(self, kDWTextAttachmentImageUrl);
    return imageSrc;
}

+ (NSString *)dw_createImageSrcWithKey:(NSString *)imageLink {
    if (imageLink.length == 0) {
        return nil;
    }
    if ([imageLink hasPrefix:@"https://"] || [imageLink hasPrefix:@"http://"]) {
        return imageLink;
    } else {
        NSString *url = [NSString stringWithFormat:@"%@",imageLink];
        return url;
    }
}

@end
