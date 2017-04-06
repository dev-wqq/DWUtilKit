//
//  ModelClass.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/4/6.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DWModel.h"
#import <objc/runtime.h>

// Type Encodings
// https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
typedef NS_OPTIONS(NSUInteger, DWEncodingType) {
    DWEncodingTypeMask = 0xff,
    DWEncodingTypeChar = 0,
    DWEncodingTypeInt = 1,
    DWEncodingTypeShort = 2,
    DWEncodingTypeLong = 3,
    DWEncodingTypeLongLong = 4,
    DWEncodingTypeUnsignedChar = 5,
    DWEncodingTypeUnsignedInt = 6,
    DWEncodingTypeUnsignedShort = 7,
    DWEncodingTypeUnsignedLong = 8,
    DWEncodingTypeUnsignedLongLong = 9,
    DWEncodingTypeFloat = 10,
    DWEncodingTypeDouble = 11,
    DWEncodingTypeBool = 12, /// C++ bool or C99 _Bool
    DWEncodingTypeVoid = 13,
    DWEncodingTypeCharacterString = 14,/// char *
    DWEncodingTypeObject = 15,
    DWEncodingTypeClassObject = 16,
    DWEncodingTypeMethodSelector = 17,
    DWEncodingTypeArray = 18,
    DWEncodingTypeStruct = 19,
    DWEncodingTypeUnion = 20,
    DWEncodingTypebnum = 21,
    DWEncodingTypePointer = 22,
    DWEncodingTypeUnknown = 23,
    
    DWEncodingTypePropertyMask = 0xff00,
    DWEncodingTypePropertyReadonly = 1 << 8,
    DWEncodingTypePropertyCopy = 1 << 9,
    DWEncodingTypePropertyRetain = 1 << 10,
    DWEncodingTypePropertyNonatomic = 1 << 11,
    DWEncodingTypePropertyCustomGetter = 1 << 12,
    DWEncodingTypePropertyCustomSetter = 1 << 13,
    DWEncodingTypePropertyDynamic = 1 << 14,
    DWEncodingTypePropertyWeak = 1 << 15,
};

typedef NS_ENUM(NSUInteger, DWObjectType) {
    DWObjectTypeNSString,
    DWObjectTypeNSMutableString,
    DWObjectTypeNSNumber,
    DWObjectTypeNSDecimalNumber,
    DWObjectTypeNSNull,
    DWObjectTypeNSURL,
    DWObjectTypeNSDate,
    DWObjectTypeNSArray,
    DWObjectTypeNSMutableArray,
    DWObjectTypeNSDictionary,
    DWObjectTypeNSMutableDictionary,
    DWObjectTypeNotSupport,
};

/**
 When represents a NSArray, classObj and valueClassObj would be used. classObj is [NSArray class].
 All the values must have the same class, `valueClassObj` indicates their class.
 
 When represents a NSDictionary, all the three properties would be used. classObj is [NSDictionary class].
 1.If all the values are the same class, the `valueClassObj` indicates the class of value.
 2.If there values aren't the same type, `keyToClass` indicates the class for each value of corresponding key.
 
 If neither NSArray nor NSDictionary, it's not a container, just set `classObj`.
 */
@interface ContainerTypeObject : NSObject
/// type
@property (nonatomic, readonly) Class classObj;
/// value class
@property (nonatomic) ContainerTypeObject *valueClassObj;
/// all the values have the same class
@property (nonatomic) NSDictionary<NSString *, ContainerTypeObject *> *keyToClass;

+ (id)containerTypeObjectWithClass:(Class)classObj;
+ (id)arrayContainerTypeObjectWithValueClass:(Class)valueClass;
+ (id)dictionaryContainerTypeObjectWithValueClass:(Class)valueClass;
+ (id)dictionaryContainerTypeObjectWithKeyToValueClass:(NSDictionary<NSString *, ContainerTypeObject *> *)valueClass;

- (id)initWithClass:(Class)classObj;

@end

extern DWEncodingType DWEncodingTypeFromChar(const char *ptype);
extern DWEncodingType DWEncodingPropertyType(DWEncodingType type);
extern DWObjectType DWObjectTypeFromClass(Class classObj);

extern BOOL isNumberTypeOfEncodingType(DWEncodingType type);
extern BOOL isObjectTypeOfEncodingType(DWEncodingType type);
extern BOOL isContainerTypeForObjectType(DWObjectType type);


@class DWProperty;
@interface DWClass : NSObject

@property (nonatomic, readonly) DWClass *superClass;

/// property key to DWProperty, not property name
@property (nonatomic, readonly) NSDictionary<NSString *, DWProperty *> *properties;

/// black list property name
@property (nonatomic, readonly) NSSet<NSString *> *propertyNameBlackList;

/// hash property name
@property (nonatomic, readonly) NSSet<NSString *> *propertyNameCalculateHash;

/// map from propertyName to jsonKey
@property (nonatomic, readonly) NSDictionary<NSString *, NSString *> *propertyNameToJsonKeyMap;

/// map from propertyName to ContainerTypeObject, the ContainerTypeObject describes the container.
@property (nonatomic, readonly) NSDictionary<NSString *, ContainerTypeObject *> *propertyNameToContainerTypeObjectMap;

+ (DWClass *)classWithClassObject:(Class)classObject;

@end

@interface DWProperty : NSObject

@property (nonatomic, copy) NSString *propertyName;
@property (nonatomic, copy) NSString *jsonKey;
@property (nonatomic) DWEncodingType encodingType;
@property (nonatomic) DWObjectType objectType;
@property (nonatomic, strong) Class propertyClass;
@property (nonatomic) SEL getter;
@property (nonatomic) SEL setter;

+ (DWProperty *)propertyWithRuntime:(objc_property_t)objc_property;

@end
