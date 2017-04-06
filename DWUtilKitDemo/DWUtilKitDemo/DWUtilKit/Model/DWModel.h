//
//  DWModel.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/4/6.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 模型解析是用的之前同事写的，这里的修改只是做了前缀的修改将以前的cc/CC 替换成了dw/DW
 可以参考：https://github.com/kudocc/CCKit.git
 */

@class ContainerTypeObject;
@protocol DWModel <NSObject>

@optional
/// property name to json key
+ (NSDictionary<NSString *, NSString *> *)propertyNameToJsonKeyMap;

/// property black list, any property name in black list won't be serialization and deserialization
+ (NSSet<NSString *> *)propertyNameBlackList;

/// You must provide property set, so that we know how to calculate the hash, the property can't be changed when the Model is in a collection that uses hash values to determine the object’s position in the collection, for example NSSet.
/// if you don't implement this method, we use the address of Model as hash and `dwmodel_isEqual:` will always returns NO if two objects are not the same object.
+ (NSSet<NSString *> *)propertyNameCalculateHash;

/// property name to container value type description
+ (NSDictionary<NSString *, ContainerTypeObject *> *)propertyNameToContainerTypeObjectMap;

@optional
/// The method will be called when Model finishes constructing from JSON object
- (void)modelFinishConstructFromJSONObject:(NSDictionary *)jsonObject;
/// The method will be called when Model finishes convert ot JSON object
- (void)JSONObjectFinishConstructFromModel:(NSMutableDictionary *)jsonObject;

@end

