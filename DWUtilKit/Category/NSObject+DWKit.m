//
//  NSObject+DWKit.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/15.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "NSObject+DWKit.h"

@implementation NSObject (DWKit)

#pragma mark - Json

+ (id)dw_jsonWithData:(NSData *)data {
    NSError *error;
    id serial = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"Error: NSData parsing json error %@",error.description);
        return nil;
    }
    return serial;
}

+ (id)dw_jsonWithString:(NSString *)string {
    NSError *error;
    id serial = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"Error: NSString parsing json error %@",error.description);
        return nil;
    }
    return serial;
}

+ (NSData *)dw_dataWithJson:(id)json {
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"Error: json parsing data error %@",error.description);
        return nil;
    }
    return data;
}

+ (NSString *)dw_stringWithJson:(id)json {
    NSData *data = [self dw_dataWithJson:json];
    if (!data) {
        return nil;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


@end
