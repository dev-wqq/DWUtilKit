//
//  DWWeakProxy.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/9.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWWeakProxy : NSProxy

/**
 *  The proxy target
 */
@property (nonatomic, weak, readonly) id target;

- (instancetype)initWithTarget:(id)target;

+ (instancetype)proxyWithTarget:(id)target;


@end
