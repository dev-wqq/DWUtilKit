//
//  NSURL+DWKit.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2018/1/23.
//  Copyright © 2018年 duxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (DWKit)

/// Gets the parameters in the url.
@property (nonatomic, strong, readonly) NSDictionary *dwParameters;

@end
