//
//  NSObject+DWModel.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/4/6.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "ModelClass.h"

/*
 Apple says in NSJSONSerialization,
 An object that may be converted to JSON must have the following properties:
 1. The top level object is an NSArray or NSDictionary.
 2. All objects are instances of NSString, NSNumber, NSArray, NSDictionary, or NSNull.
 3. All dictionary keys are instances of NSString.
 4. Numbers are not NaN or infinity.
 
 So the model property type is limited, but I will try to support as many as I could
 ______________________________________________________________________________________
 property                   JSON object
 ______________________________________________________________________________________
 NSString               NSString/NSNumber,
 NSMutableString        NSString/NSNumber,
 NSNumber               NSString/NSNumber,
 NSDecimalNumber        NSString/NSNumber,
 NSNull                 NSNull,
 NSURL                  NSString with `URLWithString:`
 NSDate                 NSNumber/NSString it's a timestamp value
 NSArray
 NSMutableArray
 NSDictionary
 NSMutableDictionary
 ______________________________________________________________________________________
 */

@interface NSObject (DWModel)

/// json must be NSDictionary or NSString or NSData
+ (id)dwmodel_modelWithJSON:(id)json;

/// model to json object
- (NSDictionary *)dwmodel_jsonObjectDictionary;
- (NSData *)dwmodel_jsonObjectData;
- (NSString *)dwmodel_jsonObjectString;

/// NSCopying protocol
- (id)dwmodel_copyWithZone:(NSZone *)zone;

/// NSCoding protocol
- (id)dwmodel_initWithCoder:(NSCoder *)coder;
- (void)dwmodel_encodeWithCoder:(NSCoder *)coder;

/// NSObject protocol
/**
 Compare all the properties, only if all the properties are equal it would return YES, or returns NO.
 
 if you don't implement `propertyNameCalculateHash` method and the two object is not the same object, we just return NO.
 */
- (BOOL)dwmodel_isEqual:(id)object;

/**
 In Apple's documentation, it talks about the `hash` method in NSObject protocol :
 "If two objects are equal (as determined by the isEqual: method), they must have the same hash value. This last point is particularly important if you define hash in a subclass and intend to put instances of that subclass into a collection.
 If a mutable object is added to a collection that uses hash values to determine the object’s position in the collection, the value returned by the hash method of the object must not change while the object is in the collection. Therefore, either the hash method must not rely on any of the object’s internal state information or you must make sure the object’s internal state information does not change while the object is in the collection. Thus, for example, a mutable dictionary can be put in a hash table but you must not change it while it is in there. (Note that it can be difficult to know whether or not a given object is in a collection.)"
 
 As we don't know if you would add the object into a collection, if you do intend to add it in a collection, we also don't know which property won't be changed so it can be used to calculate the hash. Therefore we recommand you to implement `+ (NSSet<NSString *> *)propertyNameCalculateHash` method, so we can use the returned `NSSet` to calculate the hash, OR we just use the address of the Model as the hash.
 */
- (NSUInteger)dwmodel_hash;

/// debug information
- (NSString *)dwmodel_debugDescription;

@end


@interface NSArray (DWModel)

/**
 convert json array to Objective-C object array, all values in array must be the same type.
 @param json json must be NSArray or NSString or NSData
 @param typeObject describe the value type
 */
+ (id)dwmodel_modelArrayWithJSON:(id)json withValueType:(ContainerTypeObject *)typeObject;

/**
 convert Objective-C object array to json array, all values in array must be the same type.
 @param typeObject describe the value type
 */
- (NSArray *)dwmodel_jsonObjectArrayWithValueType:(ContainerTypeObject *)typeObject;

@end


@interface NSDictionary (DWModel)

/**
 convert json dictionary to Objective-C object dictionary, all values in dictionary is same type.
 @param json json must be NSDictionary or NSString or NSData
 @param typeObject describe the value type
 */
+ (id)dwmodel_modelDictionaryWithJSON:(id)json withValueType:(ContainerTypeObject *)typeObject;
/**
 convert json dictionary to Objective-C object dictionary, value type is indicated by keyToValueType.
 @param json json must be NSDictionary or NSString or NSData
 @param keyToValueType describe the value type
 */
+ (id)dwmodel_modelDictionaryWithJSON:(id)json withKeyToValueType:(NSDictionary<NSString *, ContainerTypeObject *> *)keyToValueType;

/**
 convert Objective-C object dictionary to json dictionary, all values has the same type indicated by typeObject.
 @param typeObject describe the value type
 */
- (NSDictionary *)dwmodel_jsonObjectDictionaryWithValueType:(ContainerTypeObject *)typeObject;
/**
 convert Objective-C object dictionary to json dictionary, value's type is indicated by keyToValueType.
 @param keyToValueType describe the value type
 */
- (NSDictionary *)dwmodel_jsonObjectDictionaryWithKeyToValueType:(NSDictionary<NSString *, ContainerTypeObject *> *)keyToValueType;

@end
