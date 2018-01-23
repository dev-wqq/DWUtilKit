//
//  NSURL+DWKit.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2018/1/23.
//  Copyright © 2018年 duxing. All rights reserved.
//

#import "NSURL+DWKit.h"

@implementation NSURL (DWKit)
@dynamic dwParameters;

- (NSDictionary *)dwParameters {
    if ([self.absoluteString rangeOfString:@"?"].location == NSNotFound) {
        return nil;
    }
    NSURLComponents *components = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:NO];
    
    NSArray *queryItems = [components queryItems];
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    for (NSURLQueryItem *item in queryItems) {
        mDict[item.name] = item.value;
    }
    return mDict;
}

@end
