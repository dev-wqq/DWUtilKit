//
//  NSObject+DWModel.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/4/6.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "NSObject+DWModel.h"
#import "NSDictionary+DWKit.h"

@interface NSObject (DWModel_Util)

/**
 serialize is from JSON object to model or other Objective-C object
 @param containerTypeObj if classObject indicates its a container, then containerTypeObj describes the container
 */
+ (id)serializeJSONObj:(id)jsonObj toClass:(Class)classObject withContainerTypeObject:(ContainerTypeObject *)containerTypeObj;

/**
 deserialize is from model or other Objective-C object to JSON object
 @param containerTypeObj if classObject indicates its a container, then containerTypeObj describes the container
 */
+ (id)deserializeFromObject:(id)obj fromClass:(Class)classObject withContainerTypeObject:(ContainerTypeObject *)containerTypeObj;

@end

@implementation NSObject (DWModel_Util)

+ (id)serializeJSONObj:(id)jsonObj toClass:(Class)classObject withContainerTypeObject:(ContainerTypeObject *)containerTypeObj {
    DWObjectType type = DWObjectTypeFromClass(classObject);
    
    if (type == DWObjectTypeNSString ||
        type == DWObjectTypeNSMutableString) {
        // NSString/NSNumber
        if ([jsonObj isKindOfClass:[NSNumber class]]) {
            jsonObj = [jsonObj stringValue];
        }
        if ([jsonObj isKindOfClass:[NSString class]]) {
            if (type == DWObjectTypeNSMutableString) {
                return [jsonObj mutableCopy];
            } else {
                return jsonObj;
            }
        }
    } else if (type == DWObjectTypeNSNumber) {
        // support NSString / NSNumber
        if ([jsonObj isKindOfClass:[NSString class]]) {
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            jsonObj = [f numberFromString:jsonObj];
        }
        if ([jsonObj isKindOfClass:[NSNumber class]]) {
            return jsonObj;
        }
    } else if (type == DWObjectTypeNSDecimalNumber) {
        if ([jsonObj isKindOfClass:[NSNumber class]]) {
            jsonObj = [jsonObj stringValue];
        }
        if ([jsonObj isKindOfClass:[NSString class]]) {
            jsonObj = [NSDecimalNumber decimalNumberWithString:jsonObj];
        }
        if ([jsonObj isKindOfClass:[NSDecimalNumber class]]) {
            return jsonObj;
        }
    } else if (type == DWObjectTypeNSNull) {
        return [NSNull null];
    } else if (type == DWObjectTypeNSURL) {
        if ([jsonObj isKindOfClass:[NSString class]]) {
            return [NSURL URLWithString:jsonObj];
        }
    } else if (type == DWObjectTypeNSDate) {
        // NSNumber/NSString, it should be a timestamp
        if ([jsonObj isKindOfClass:[NSString class]] || [jsonObj isKindOfClass:[NSNumber class]]) {
            double timestamp = [jsonObj doubleValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
            return date;
        }
    } else if (type == DWObjectTypeNSArray ||
               type == DWObjectTypeNSMutableArray) {
        NSParameterAssert(containerTypeObj.valueClassObj);
        NSArray *array = [NSArray dwmodel_modelArrayWithJSON:jsonObj withValueType:containerTypeObj.valueClassObj];
        if (type == DWObjectTypeNSMutableArray) {
            return [array mutableCopy];
        }
        return array;
    } else if (type == DWObjectTypeNSDictionary ||
               type == DWObjectTypeNSMutableDictionary) {
        NSDictionary *dict = nil;
        if (containerTypeObj.keyToClass) {
            dict = [NSDictionary dwmodel_modelDictionaryWithJSON:jsonObj withKeyToValueType:containerTypeObj.keyToClass];
        } else if (containerTypeObj.valueClassObj) {
            dict = [NSDictionary dwmodel_modelDictionaryWithJSON:jsonObj withValueType:containerTypeObj.valueClassObj];
        }
        if (dict && type == DWObjectTypeNSMutableDictionary) {
            return [dict mutableCopy];
        }
        return dict;
    } else if ([jsonObj isKindOfClass:[NSDictionary class]]) {
        // try to convert to class
        return [classObject dwmodel_modelWithJSON:jsonObj];
    }
    NSLog(@"%@, can't serialize object class(%@) from json object(%@)", NSStringFromSelector(_cmd), classObject, jsonObj);
    return nil;
}

+ (id)deserializeFromObject:(id)obj fromClass:(Class)classObject withContainerTypeObject:(ContainerTypeObject *)containerTypeObj {
    DWObjectType type = DWObjectTypeFromClass(classObject);
    if (type == DWObjectTypeNSString ||
        type == DWObjectTypeNSMutableString ||
        type == DWObjectTypeNSDecimalNumber ||
        type == DWObjectTypeNSNumber ||
        type == DWObjectTypeNSNull) {
        return obj;
    } else if (type == DWObjectTypeNSURL) {
        return [((NSURL *)obj) absoluteString];
    } else if (type == DWObjectTypeNSDate) {
        NSDate *date = obj;
        return @([date timeIntervalSince1970]);
    } else if (type == DWObjectTypeNSArray ||
               type == DWObjectTypeNSMutableArray) {
        NSParameterAssert(containerTypeObj.valueClassObj);
        return [obj dwmodel_jsonObjectArrayWithValueType:containerTypeObj.valueClassObj];
    } else if (type == DWObjectTypeNSDictionary ||
               type == DWObjectTypeNSMutableDictionary) {
        if (containerTypeObj.keyToClass) {
            return [obj dwmodel_jsonObjectDictionaryWithKeyToValueType:containerTypeObj.keyToClass];
        } else if (containerTypeObj.valueClassObj) {
            return [obj dwmodel_jsonObjectDictionaryWithValueType:containerTypeObj.valueClassObj];
        }
    } else {
        // TODO: obj may be a model, may be not, if not, how to deal with??????
        return [obj dwmodel_jsonObjectDictionary];
    }
    return nil;
}

@end

@implementation NSObject (DWModel)

- (NSString *)dwmodel_debugDescription {
    NSMutableString *mutableString = [@"" mutableCopy];
    [mutableString appendFormat:@"class name:%@\n", self.class];
    DWClass *classInfo = [DWClass classWithClassObject:self.class];
    if (!classInfo) {
        NSAssert(NO, @"you can't mess it up with system class");
        return @"";
    }
    for (DWProperty *property in [classInfo.properties allValues]) {
        if (!property.getter) {
            continue;
        }
        DWEncodingType encodingType = property.encodingType;
        if (isNumberTypeOfEncodingType(encodingType)) {
            NSNumber *number = [self getNumberValueWithProperty:property];
            if (number) {
                [mutableString appendFormat:@"%@:%@\n", property.propertyName, number];
            }
        } else if (isObjectTypeOfEncodingType(encodingType)) {
            if (isContainerTypeForObjectType(property.objectType)) {
                ContainerTypeObject *containerTypeObject = classInfo.propertyNameToContainerTypeObjectMap[property.propertyName];
                NSAssert(containerTypeObject, @"container need description");
                if (!containerTypeObject) continue;
                id jsonObj = [self getContainerValueWithProperty:property containerTypeObject:containerTypeObject];
                if (jsonObj) {
                    [mutableString appendFormat:@"%@:%@\n", property.propertyName, jsonObj];
                }
            } else {
                id jsonObj = [self getObjectValueWithProperty:property];
                if (jsonObj) {
                    [mutableString appendFormat:@"%@:%@\n", property.propertyName, jsonObj];
                }
            }
        }
    }
    return mutableString;
}

#pragma mark - NSObject

- (BOOL)dwmodel_isEqual:(id)object {
    if ([self class] != [object class]) return NO;
    if (self == object) return YES;
    DWClass *classInfo = [DWClass classWithClassObject:self.class];
    if (!classInfo) {
        NSAssert(NO, @"you can't mess it up with system class");
        return NO;
    }
    if ([classInfo.propertyNameCalculateHash count] == 0) return NO;
    
    for (DWProperty *property in [classInfo.properties allValues]) {
        if (!property.setter || !property.getter) {
            continue;
        }
        
        if ([classInfo.propertyNameBlackList containsObject:property.propertyName]) {
            continue;
        }
        
        if (isNumberTypeOfEncodingType(property.encodingType)) {
            NSNumber *number = [self getNumberValueWithProperty:property];
            NSNumber *numberTarget = [object getNumberValueWithProperty:property];
            if (number && numberTarget) {
                if (![number isEqualToNumber:numberTarget]) {
                    return NO;
                }
            } else if (number != numberTarget) {
                return NO;
            }
        } else if (isObjectTypeOfEncodingType(property.encodingType)) {
            id obj = ((id (*)(id, SEL))objc_msgSend)(self, property.getter);
            id objTarget = ((id (*)(id, SEL))objc_msgSend)(object, property.getter);
            if (obj && objTarget) {
                if (![obj isEqual:objTarget]) {
                    return NO;
                }
            } else if (obj != objTarget) {
                return NO;
            }
        }
    }
    return YES;
}

- (NSUInteger)dwmodel_hash {
    DWClass *classInfo = [DWClass classWithClassObject:self.class];
    if (!classInfo) {
        NSAssert(NO, @"you can't mess it up with system class");
        return (NSUInteger)(__bridge void *)self;
    }
    if ([classInfo.propertyNameCalculateHash count] == 0) {
        return (NSUInteger)(__bridge void *)self;
    }
    
    NSUInteger hash = 0;
    for (DWProperty *property in [classInfo.properties allValues]) {
        if (!property.setter || !property.getter) {
            continue;
        }
        if (![classInfo.propertyNameCalculateHash containsObject:property.propertyName]) {
            continue;
        }
        if (isNumberTypeOfEncodingType(property.encodingType)) {
            NSNumber *number = [self getNumberValueWithProperty:property];
            hash ^= [number hash];
        } else if (isObjectTypeOfEncodingType(property.encodingType)) {
            id obj = ((id (*)(id, SEL))objc_msgSend)(self, property.getter);
            hash ^= [obj hash];
        }
    }
    return hash;
}

#pragma mark - NSCopying

- (id)dwmodel_copyWithZone:(NSZone *)zone {
    DWClass *classInfo = [DWClass classWithClassObject:self.class];
    if (!classInfo) {
        NSAssert(NO, @"you can't mess it up with system class");
        return nil;
    }
    
    id target = [[self.class alloc] init];
    for (DWProperty *property in [classInfo.properties allValues]) {
        if (!property.setter || !property.getter) {
            continue;
        }
        
        if ([classInfo.propertyNameBlackList containsObject:property.propertyName]) {
            continue;
        }
        
        if (isNumberTypeOfEncodingType(property.encodingType)) {
            NSNumber *number = [self getNumberValueWithProperty:property];
            if (number) {
                [target setNumberProperty:property withJsonObj:number];
            }
        } else if (isObjectTypeOfEncodingType(property.encodingType)) {
            id obj = ((id (*)(id, SEL))objc_msgSend)(self, property.getter);
            id copyObj = nil;
            if (property.objectType == DWObjectTypeNSMutableString ||
                property.objectType == DWObjectTypeNSMutableArray ||
                property.objectType == DWObjectTypeNSMutableDictionary) {
                copyObj = [obj mutableCopy];
            } else {
                copyObj = [obj copy];
            }
            if (copyObj) {
                ((void (*)(id, SEL, id))objc_msgSend)(target, property.setter, copyObj);
            }
        }
    }
    return target;
}

#pragma mar - NSCoding

- (id)dwmodel_initWithCoder:(NSCoder *)coder {
    DWClass *classInfo = [DWClass classWithClassObject:self.class];
    if (!classInfo) {
        NSAssert(NO, @"you can't mess it up with system class");
        return nil;
    }
    
    for (DWProperty *property in [classInfo.properties allValues]) {
        if (!property.getter || !property.setter) continue;
        
        if ([classInfo.propertyNameBlackList containsObject:property.propertyName]) {
            continue;
        }
        
        if (isNumberTypeOfEncodingType(property.encodingType)) {
            id number = [coder decodeObjectForKey:property.propertyName];
            if (number) {
                [self setNumberProperty:property withJsonObj:number];
            }
        } else if (isObjectTypeOfEncodingType(property.encodingType)) {
            id obj = [coder decodeObjectForKey:property.propertyName];
            ((void (*)(id, SEL, id))objc_msgSend)(self, property.setter, obj);
        }
    }
    return self;
}

- (void)dwmodel_encodeWithCoder:(NSCoder *)coder {
    DWClass *classInfo = [DWClass classWithClassObject:self.class];
    if (!classInfo) {
        NSAssert(NO, @"you can't mess it up with system class");
        return;
    }
    
    for (DWProperty *property in [classInfo.properties allValues]) {
        if (!property.getter || !property.setter) continue;
        
        if ([classInfo.propertyNameBlackList containsObject:property.propertyName]) {
            continue;
        }
        
        if (isNumberTypeOfEncodingType(property.encodingType)) {
            NSNumber *number = [self getNumberValueWithProperty:property];
            if (number) {
                [coder encodeObject:number forKey:property.propertyName];
            }
        } else if (isObjectTypeOfEncodingType(property.encodingType)) {
            id obj = ((id (*)(id, SEL))objc_msgSend)(self, property.getter);
            if (obj) {
                [coder encodeObject:obj forKey:property.propertyName];
            }
        }
    }
}

#pragma mark - JSON object to Model

+ (id)dwmodel_modelWithJSON:(id)json {
    NSDictionary *dict = nil;
    NSData *data = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dict = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        data = [json dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        data = json;
    }
    if (data && !dict) {
        dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        id obj = [[self class] dwmodel_modelWithJSONDictionary:dict];
        return obj;
    }
    return nil;
}

+ (id)dwmodel_modelWithJSONDictionary:(NSDictionary *)json {
    id obj = [[[self class] alloc] initWithJSONDictionary:json];
    return obj;
}

- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary {
    self = [self init];
    if (!self) return nil;
    
    DWClass *classInfo = [DWClass classWithClassObject:self.class];
    if (!classInfo) {
        NSAssert(NO, @"you can't mess it up with system class");
        return nil;
    }
    for (DWProperty *property in [classInfo.properties allValues]) {
        if (!property.setter || !property.getter) {
            continue;
        }
        
        id jsonObj = [jsonDictionary dw_objectForKeyPath:property.jsonKey];
        if (!jsonObj) {
            // property not exists in json
            continue;
        }
        
        // filter property in black list
        if ([classInfo.propertyNameBlackList containsObject:property.propertyName]) {
            continue;
        }
        
        DWEncodingType encodingType = property.encodingType;
        if (isNumberTypeOfEncodingType(encodingType)) {
            [self setNumberProperty:property withJsonObj:jsonObj];
        } else if (isObjectTypeOfEncodingType(encodingType)) {
            if (isContainerTypeForObjectType(property.objectType)) {
                ContainerTypeObject *containerTypeObject = classInfo.propertyNameToContainerTypeObjectMap[property.propertyName];
                NSAssert(containerTypeObject, @"container need description");
                if (!containerTypeObject) continue;
                [self setContainerProperty:property withJsonObj:jsonObj containerTypeObject:containerTypeObject];
            } else {
                [self setObjectProperty:property withJsonObj:jsonObj];
            }
        }
    }
    
    if ([self conformsToProtocol:@protocol(DWModel)]) {
        id model = (id<DWModel>)self;
        if ([model respondsToSelector:@selector(modelFinishConstructFromJSONObject:)]) {
            [model modelFinishConstructFromJSONObject:jsonDictionary];
        }
    }
    
    return self;
}

#pragma mark - Model To JSON object

- (NSDictionary *)dwmodel_jsonObjectDictionary {
    DWClass *classInfo = [DWClass classWithClassObject:self.class];
    if (!classInfo) {
        NSAssert(NO, @"you can't mess it up with system class");
        return nil;
    }
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
    for (DWProperty *property in [classInfo.properties allValues]) {
        if (!property.getter || !property.setter) {
            continue;
        }
        
        // filter property in black list
        if ([classInfo.propertyNameBlackList containsObject:property.propertyName]) {
            continue;
        }
        
        DWEncodingType encodingType = property.encodingType;
        if (isNumberTypeOfEncodingType(encodingType)) {
            NSNumber *number = [self getNumberValueWithProperty:property];
            if (number) {
                [mutableDictionary dw_setObject:number forKeyPath:property.jsonKey];
            }
        } else if (isObjectTypeOfEncodingType(encodingType)) {
            if (isContainerTypeForObjectType(property.objectType)) {
                ContainerTypeObject *containerTypeObject = classInfo.propertyNameToContainerTypeObjectMap[property.propertyName];
                NSAssert(containerTypeObject, @"container need description");
                if (!containerTypeObject) continue;
                id jsonObj = [self getContainerValueWithProperty:property containerTypeObject:containerTypeObject];
                if (jsonObj) {
                    [mutableDictionary dw_setObject:jsonObj forKeyPath:property.jsonKey];
                }
            } else {
                id jsonObj = [self getObjectValueWithProperty:property];
                if (jsonObj) {
                    [mutableDictionary dw_setObject:jsonObj forKeyPath:property.jsonKey];
                }
            }
        }
    }
    
    if ([self conformsToProtocol:@protocol(DWModel)]) {
        id model = (id<DWModel>)self;
        if ([model respondsToSelector:@selector(JSONObjectFinishConstructFromModel:)]) {
            [model JSONObjectFinishConstructFromModel:mutableDictionary];
        }
    }
    
    return [mutableDictionary copy];
}

- (NSData *)dwmodel_jsonObjectData {
    NSDictionary *dict = [self dwmodel_jsonObjectDictionary];
    if (dict) {
        return [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    }
    return nil;
}

- (NSString *)dwmodel_jsonObjectString {
    NSData *data = [self dwmodel_jsonObjectData];
    if (data) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (NSNumber *)getNumberValueWithProperty:(DWProperty *)property {
    switch (property.encodingType & DWEncodingTypeMask) {
        case DWEncodingTypeChar:
            return @(((char (*)(id, SEL))objc_msgSend)(self, property.getter));
        case DWEncodingTypeUnsignedChar:
            return @(((unsigned char (*)(id, SEL))objc_msgSend)(self, property.getter));
        case DWEncodingTypeInt:
            return @(((int (*)(id, SEL))objc_msgSend)(self, property.getter));
        case DWEncodingTypeUnsignedInt:
            return @(((unsigned int (*)(id, SEL))objc_msgSend)(self, property.getter));
        case DWEncodingTypeShort:
            return @(((short (*)(id, SEL))objc_msgSend)(self, property.getter));
        case DWEncodingTypeUnsignedShort:
            return @(((unsigned short (*)(id, SEL))objc_msgSend)(self, property.getter));
        case DWEncodingTypeLong:
            return @(((long (*)(id, SEL))objc_msgSend)(self, property.getter));
        case DWEncodingTypeUnsignedLong:
            return @(((unsigned long (*)(id, SEL))objc_msgSend)(self, property.getter));
        case DWEncodingTypeLongLong:
            return @(((long long (*)(id, SEL))objc_msgSend)(self, property.getter));
        case DWEncodingTypeUnsignedLongLong:
            return @(((unsigned long long (*)(id, SEL))objc_msgSend)(self, property.getter));
        case DWEncodingTypeFloat:
            return @(((float (*)(id, SEL))objc_msgSend)(self, property.getter));
        case DWEncodingTypeDouble:
            return @(((double (*)(id, SEL))objc_msgSend)(self, property.getter));
        case DWEncodingTypeBool:
            return @(((BOOL (*)(id, SEL))objc_msgSend)(self, property.getter));
        default:
            break;
    }
    return nil;
}

- (id)getObjectValueWithProperty:(DWProperty *)property {
    id obj = ((id (*)(id, SEL))objc_msgSend)(self, property.getter);
    return [NSObject deserializeFromObject:obj fromClass:property.propertyClass withContainerTypeObject:nil];
}

- (id)getContainerValueWithProperty:(DWProperty *)property containerTypeObject:(ContainerTypeObject *)containerTypeObj {
    id obj = ((id (*)(id, SEL))objc_msgSend)(self, property.getter);
    return [NSObject deserializeFromObject:obj fromClass:property.propertyClass withContainerTypeObject:containerTypeObj];
}

- (void)setNumberProperty:(DWProperty *)property withJsonObj:(id)jsonObj {
    // support NSString/NSNumber/NSNull
    if (jsonObj == [NSNull null]) {
        jsonObj = @0;
    } else if ([jsonObj isKindOfClass:[NSString class]]) {
        if ((property.encodingType & DWEncodingTypeMask) == DWEncodingTypeBool) {
            static NSDictionary *boolStringToNumberMap = nil;
            if (!boolStringToNumberMap) {
                boolStringToNumberMap = @{@"YES":@1, @"NO":@0,
                                          @"TRUE":@1, @"FALSE":@0};
            }
            NSNumber *number = boolStringToNumberMap[[jsonObj uppercaseString]];
            if (number) {
                jsonObj = number;
            } else {
                jsonObj = @([jsonObj boolValue]);
            }
        } else {
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            jsonObj = [f numberFromString:jsonObj];
        }
    }
    
    if (![jsonObj isKindOfClass:[NSNumber class]]) return;
    
    switch (property.encodingType & DWEncodingTypeMask) {
        case DWEncodingTypeChar:
            ((void (*)(id, SEL, char))objc_msgSend)(self, property.setter, [jsonObj charValue]);
            break;
        case DWEncodingTypeUnsignedChar:
            ((void (*)(id, SEL, unsigned char))objc_msgSend)(self, property.setter, [jsonObj unsignedCharValue]);
            break;
        case DWEncodingTypeInt:
            ((void (*)(id, SEL, int))objc_msgSend)(self, property.setter, [jsonObj intValue]);
            break;
        case DWEncodingTypeUnsignedInt:
            ((void (*)(id, SEL, unsigned int))objc_msgSend)(self, property.setter, [jsonObj unsignedIntValue]);
            break;
        case DWEncodingTypeShort:
            ((void (*)(id, SEL, short))objc_msgSend)(self, property.setter, [jsonObj shortValue]);
            break;
        case DWEncodingTypeUnsignedShort:
            ((void (*)(id, SEL, unsigned short))objc_msgSend)(self, property.setter, [jsonObj unsignedShortValue]);
            break;
        case DWEncodingTypeLong:
            ((void (*)(id, SEL, long))objc_msgSend)(self, property.setter, [jsonObj longValue]);
            break;
        case DWEncodingTypeUnsignedLong:
            ((void (*)(id, SEL, unsigned long))objc_msgSend)(self, property.setter, [jsonObj unsignedLongValue]);
            break;
        case DWEncodingTypeLongLong:
            ((void (*)(id, SEL, long long))objc_msgSend)(self, property.setter, [jsonObj longLongValue]);
            break;
        case DWEncodingTypeUnsignedLongLong:
            ((void (*)(id, SEL, unsigned long long))objc_msgSend)(self, property.setter, [jsonObj unsignedLongLongValue]);
            break;
        case DWEncodingTypeFloat:
            ((void (*)(id, SEL, float))objc_msgSend)(self, property.setter, [jsonObj floatValue]);
            break;
        case DWEncodingTypeDouble:
            ((void (*)(id, SEL, double))objc_msgSend)(self, property.setter, [jsonObj doubleValue]);
            break;
        case DWEncodingTypeBool:
            ((void (*)(id, SEL, bool))objc_msgSend)(self, property.setter, [jsonObj boolValue]);
            break;
        default:
            break;
    }
}

- (void)setObjectProperty:(DWProperty *)property withJsonObj:(id)jsonObj {
    id obj = [NSObject serializeJSONObj:jsonObj toClass:property.propertyClass withContainerTypeObject:nil];
    if (obj) {
        ((void (*)(id, SEL, id))objc_msgSend)(self, property.setter, obj);
    }
}

- (void)setContainerProperty:(DWProperty *)property withJsonObj:(id)jsonObj containerTypeObject:(ContainerTypeObject *)containerTypeObj {
    id obj = [NSObject serializeJSONObj:jsonObj toClass:property.propertyClass withContainerTypeObject:containerTypeObj];
    if (obj) {
        ((void (*)(id, SEL, id))objc_msgSend)(self, property.setter, obj);
    }
}

@end


@implementation NSArray (DWModel)

+ (id)dwmodel_modelArrayWithJSON:(id)json withValueType:(ContainerTypeObject *)typeObject {
    NSArray *array = nil;
    NSData *data = nil;
    if ([json isKindOfClass:[NSArray class]]) {
        array = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        data = [json dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        data = json;
    }
    if (data && !array) {
        array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
    if (array && [array isKindOfClass:[NSArray class]]) {
        id obj = [self dwmodel_modelArrayWithJSONArray:array withValueType:typeObject];
        return obj;
    }
    return nil;
}

+ (id)dwmodel_modelArrayWithJSONArray:(NSArray *)jsonArray withValueType:(ContainerTypeObject *)typeObject {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (id json in jsonArray) {
        id obj = [NSObject serializeJSONObj:json toClass:typeObject.classObj withContainerTypeObject:typeObject];
        if (obj) {
            [mutableArray addObject:obj];
        }
    }
    return [mutableArray copy];
}

- (NSArray *)dwmodel_jsonObjectArrayWithValueType:(ContainerTypeObject *)typeObject {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (id obj in self) {
        id jsonObj = [NSObject deserializeFromObject:obj fromClass:typeObject.classObj withContainerTypeObject:typeObject];
        if (jsonObj) {
            [mutableArray addObject:jsonObj];
        }
    }
    return [mutableArray copy];
}

@end


@implementation NSDictionary (DWModel)

+ (id)dwmodel_modelDictionaryWithJSON:(id)json withValueType:(ContainerTypeObject *)typeObject {
    NSDictionary *dict = nil;
    NSData *data = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dict = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        data = [json dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        data = json;
    }
    if (data && !dict) {
        dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        id obj = [self dwmodel_modelDictionaryWithJSONDictionary:dict withValueType:typeObject];
        return obj;
    }
    return nil;
}

+ (id)dwmodel_modelDictionaryWithJSONDictionary:(NSDictionary *)jsonDictionary withValueType:(ContainerTypeObject *)typeObject {
    NSParameterAssert(typeObject);
    if (!typeObject) {
        return nil;
    }
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
    [jsonDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, id  _Nonnull jsonObj, BOOL * _Nonnull stop) {
        id obj = [NSObject serializeJSONObj:jsonObj toClass:typeObject.classObj withContainerTypeObject:typeObject];
        if (obj) {
            mutableDictionary[key] = obj;
        }
    }];
    return [mutableDictionary copy];
}

+ (id)dwmodel_modelDictionaryWithJSON:(id)json withKeyToValueType:(NSDictionary<NSString *, ContainerTypeObject *> *)keyToValueType {
    NSDictionary *dict = nil;
    NSData *data = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dict = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        data = [json dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        data = json;
    }
    if (data && !dict) {
        dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        id obj = [self dwmodel_modelDictionaryWithJSONDictionary:dict withKeyToValueType:keyToValueType];
        return obj;
    }
    return nil;
}

+ (id)dwmodel_modelDictionaryWithJSONDictionary:(NSDictionary *)jsonDictionary withKeyToValueType:(NSDictionary<NSString *, ContainerTypeObject *> *)keyToValueType {
    NSParameterAssert(keyToValueType);
    if (!keyToValueType) {
        return nil;
    }
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
    [jsonDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, id  _Nonnull jsonObj, BOOL * _Nonnull stop) {
        ContainerTypeObject *typeObject = keyToValueType[key];
        id obj = [NSObject serializeJSONObj:jsonObj toClass:typeObject.classObj withContainerTypeObject:typeObject];
        if (obj) {
            mutableDictionary[key] = obj;
        }
    }];
    return [mutableDictionary copy];
}



- (NSDictionary *)dwmodel_jsonObjectDictionaryWithValueType:(ContainerTypeObject *)typeObject {
    NSParameterAssert(typeObject);
    if (!typeObject) {
        return nil;
    }
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
    [self enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id jsonObj = [NSObject deserializeFromObject:obj fromClass:typeObject.classObj withContainerTypeObject:typeObject];
        if (jsonObj) {
            mutableDictionary[key] = jsonObj;
        }
    }];
    return [mutableDictionary copy];
}

- (NSDictionary *)dwmodel_jsonObjectDictionaryWithKeyToValueType:(NSDictionary<NSString *, ContainerTypeObject *> *)keyToValueType {
    NSParameterAssert(keyToValueType);
    if (!keyToValueType) {
        return nil;
    }
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
    [self enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        ContainerTypeObject *typeObject = keyToValueType[key];
        id jsonObj = [NSObject deserializeFromObject:obj fromClass:typeObject.classObj withContainerTypeObject:typeObject];
        if (jsonObj) {
            mutableDictionary[key] = jsonObj;
        }
    }];
    return [mutableDictionary copy];
}

@end
