//
//  ModelClass.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/4/6.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "ModelClass.h"

DWEncodingType DWEncodingTypeFromChar(const char *ptype) {
    char type = ptype[0];
    DWEncodingType encodingType = DWEncodingTypeUnknown;
    switch (type) {
        case 'c':// A char
            encodingType = DWEncodingTypeChar;
            break;
        case 'i':// A int
            encodingType = DWEncodingTypeInt;
            break;
        case 's':// A short
            encodingType = DWEncodingTypeShort;
            break;
        case 'l':// A long, l is treated as a 32-bit quantity on 64-bit programs.
            encodingType = DWEncodingTypeLong;
            break;
        case 'q':// A long long
            encodingType = DWEncodingTypeLongLong;
            break;
        case 'C':// An unsigned char
            encodingType = DWEncodingTypeUnsignedChar;
            break;
        case 'I':// An unsigned int
            encodingType = DWEncodingTypeUnsignedInt;
            break;
        case 'S':// An unsigned short
            encodingType = DWEncodingTypeUnsignedShort;
            break;
        case 'L':// An unsigned long
            encodingType = DWEncodingTypeUnsignedLong;
            break;
        case 'Q':// An unsigned long long
            encodingType = DWEncodingTypeUnsignedLongLong;
            break;
        case 'f':// A float
            encodingType = DWEncodingTypeFloat;
            break;
        case 'd':// A double
            encodingType = DWEncodingTypeDouble;
            break;
        case 'B':// A C++ bool or a C99 _Bool, BOOL and bool are all B.
            encodingType = DWEncodingTypeBool;
            break;
        case 'v':// A void
            encodingType = DWEncodingTypeVoid;
            break;
        case '*':// A character string(char *)
            encodingType = DWEncodingTypeCharacterString;
            break;
        case '@':// An object
            encodingType = DWEncodingTypeObject;
            break;
        case '#':// A class object (Class)
            encodingType = DWEncodingTypeClassObject;
            break;
        case ':':// A method selector
            encodingType = DWEncodingTypeMethodSelector;
            break;
        case '[':// An array
            encodingType = DWEncodingTypeArray;
            break;
        case '{':// A structure
            encodingType = DWEncodingTypeStruct;
            break;
        case '(':// A union
            encodingType = DWEncodingTypeUnion;
            break;
        case 'b':// A bit field of num bits
            encodingType = DWEncodingTypebnum;
            break;
        case '^':// A pointer to type
            encodingType = DWEncodingTypePointer;
            break;
        default:
            encodingType = DWEncodingTypeUnknown;
            break;
    }
    return encodingType;
}

DWEncodingType DWEncodingPropertyType(DWEncodingType type) {
    return type & DWEncodingTypePropertyMask;
}

DWObjectType DWObjectTypeFromClass(Class classObj) {
    if (classObj == [NSString class]) {
        return DWObjectTypeNSString;
    } else if (classObj == [NSMutableString class]) {
        return DWObjectTypeNSMutableString;
    } else if (classObj == [NSNumber class]) {
        return DWObjectTypeNSNumber;
    } else if (classObj == [NSDecimalNumber class]) {
        return DWObjectTypeNSDecimalNumber;
    } else if (classObj == [NSNull class]) {
        return DWObjectTypeNSNull;
    } else if (classObj == [NSURL class]) {
        return DWObjectTypeNSURL;
    } else if (classObj == [NSDate class]) {
        return DWObjectTypeNSDate;
    } else if (classObj == [NSArray class]) {
        return DWObjectTypeNSArray;
    } else if (classObj == [NSMutableArray class]) {
        return DWObjectTypeNSMutableArray;
    } else if (classObj == [NSDictionary class]) {
        return DWObjectTypeNSDictionary;
    } else if (classObj == [NSMutableDictionary class]) {
        return DWObjectTypeNSMutableDictionary;
    }
    return DWObjectTypeNotSupport;
}

BOOL isNumberTypeOfEncodingType(DWEncodingType type) {
    type = DWEncodingTypeMask & type;
    if (type >= DWEncodingTypeChar && type <= DWEncodingTypeBool) {
        return YES;
    }
    return NO;
}

BOOL isObjectTypeOfEncodingType(DWEncodingType type) {
    type = DWEncodingTypeMask & type;
    return type == DWEncodingTypeObject;
}

BOOL isContainerTypeForObjectType(DWObjectType type) {
    type = DWEncodingTypeMask & type;
    if (type == DWObjectTypeNSArray ||
        type == DWObjectTypeNSMutableArray ||
        type == DWObjectTypeNSDictionary ||
        type == DWObjectTypeNSMutableDictionary) {
        return YES;
    }
    return NO;
}

@implementation ContainerTypeObject

+ (id)containerTypeObjectWithClass:(Class)classObj {
    ContainerTypeObject *o = [[self alloc] initWithClass:classObj];
    return o;
}

+ (id)arrayContainerTypeObjectWithValueClass:(Class)valueClass {
    ContainerTypeObject *o = [[self alloc] initWithClass:[NSArray class]];
    ContainerTypeObject *value = [[self alloc] initWithClass:valueClass];
    o.valueClassObj = value;
    return o;
}

+ (id)dictionaryContainerTypeObjectWithValueClass:(Class)valueClass {
    ContainerTypeObject *o = [[self alloc] initWithClass:[NSDictionary class]];
    ContainerTypeObject *value = [[self alloc] initWithClass:valueClass];
    o.valueClassObj = value;
    return o;
}

+ (id)dictionaryContainerTypeObjectWithKeyToValueClass:(NSDictionary<NSString *, ContainerTypeObject *> *)valueClass {
    ContainerTypeObject *o = [[self alloc] initWithClass:[NSDictionary class]];
    o.keyToClass = valueClass;
    return o;
}

- (id)initWithClass:(Class)classObj {
    self = [super init];
    if (self) {
        _classObj = classObj;
    }
    return self;
}

@end

@interface DWClass ()

@property (nonatomic, readwrite) DWClass *superClass;
@property (nonatomic, readwrite) NSDictionary<NSString *, DWProperty *> *properties;
@property (nonatomic, readwrite) NSSet<NSString *> *propertyNameBlackList;
@property (nonatomic, readwrite) NSSet<NSString *> *propertyNameCalculateHash;

@property (nonatomic, readwrite) NSDictionary<NSString *, NSString *> *propertyNameToJsonKeyMap;
@property (nonatomic, readwrite) NSDictionary<NSString *, ContainerTypeObject *> *propertyNameToContainerTypeObjectMap;

@end

@implementation DWClass

// TODO:MARK 他们也用className作为key么
+ (DWClass *)classWithClassObject:(Class)classObject {
    static dispatch_once_t onceToken;
    static NSMutableDictionary *mutableDictionary = nil;
    static dispatch_semaphore_t semaphore;
    dispatch_once(&onceToken, ^{
        mutableDictionary = [NSMutableDictionary dictionary];
        semaphore = dispatch_semaphore_create(1);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSString *className = NSStringFromClass(classObject);
    DWClass *classInfo = mutableDictionary[className];
    dispatch_semaphore_signal(semaphore);
    
    if (classInfo) {
        return classInfo;
    } else {
        classInfo = [DWClass classWithRuntime:classObject];
        if (classInfo) {
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            mutableDictionary[className] = classInfo;
            dispatch_semaphore_signal(semaphore);
        }
        return classInfo;
    }
}

+ (BOOL)isSystemClass:(Class)classObject {
    static NSSet *systemClassSets = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemClassSets = [NSSet setWithObjects:
                           [NSString class],
                           [NSMutableString class],
                           [NSNumber class],
                           [NSDecimalNumber class],
                           [NSData class],
                           [NSURL class],
                           [NSDate class],
                           [NSArray class],
                           [NSMutableArray class],
                           [NSDictionary class],
                           [NSMutableDictionary class],
                           nil];
    });
    return [systemClassSets containsObject:classObject];
}

+ (DWClass *)classWithRuntime:(Class)classObject {
    if ([self isSystemClass:classObject]) {
        return nil;
    }
    DWClass *c = [[DWClass alloc] init];
    Class superClass = class_getSuperclass(classObject);
    if (superClass != [NSObject class]) {
        c.superClass = [DWClass classWithClassObject:superClass];
    }
    
    if ([classObject conformsToProtocol:@protocol(DWModel)]) {
        id<DWModel> DWmodel = (id<DWModel>)classObject;
        if ([DWmodel respondsToSelector:@selector(propertyNameToJsonKeyMap)]) {
            c.propertyNameToJsonKeyMap = [DWmodel propertyNameToJsonKeyMap];
        }
        if ([DWmodel respondsToSelector:@selector(propertyNameToContainerTypeObjectMap)]) {
            c.propertyNameToContainerTypeObjectMap = [DWmodel propertyNameToContainerTypeObjectMap];
        }
        if ([DWmodel respondsToSelector:@selector(propertyNameBlackList)]) {
            c.propertyNameBlackList = [DWmodel propertyNameBlackList];
        }
        if ([DWmodel respondsToSelector:@selector(propertyNameCalculateHash)]) {
            c.propertyNameCalculateHash = [DWmodel propertyNameCalculateHash];
        }
    }
#ifdef DEBUG
    else {
        if ([classObject respondsToSelector:@selector(propertyNameToJsonKeyMap)]) {
            NSLog(@"You may forget to conform to DWModel in class:%@", classObject);
        } else if ([classObject respondsToSelector:@selector(propertyNameToContainerTypeObjectMap)]) {
            NSLog(@"You may forget to conform to DWModel in class:%@", classObject);
        } else if ([classObject respondsToSelector:@selector(propertyNameBlackList)]) {
            NSLog(@"You may forget to conform to DWModel in class:%@", classObject);
        } else if ([classObject respondsToSelector:@selector(propertyNameCalculateHash)]) {
            NSLog(@"You may forget to conform to DWModel in class:%@", classObject);
        }
    }
#endif
    
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
    Class currentClass = classObject;
    while (currentClass && currentClass != [NSObject class]) {
        unsigned int propertyCount = 0;
        objc_property_t *propertyList = class_copyPropertyList(currentClass, &propertyCount);
        if (propertyList) {
            for (unsigned int i = 0; i < propertyCount; ++i) {
                objc_property_t property = *(propertyList + i);
                DWProperty *propertyObj = [DWProperty propertyWithRuntime:property];
                NSString *jsonKey = c.propertyNameToJsonKeyMap[propertyObj.propertyName];
                if (jsonKey) {
                    propertyObj.jsonKey = jsonKey;
                } else {
                    propertyObj.jsonKey = propertyObj.propertyName;
                }
                mutableDictionary[propertyObj.jsonKey] = propertyObj;
            }
            free(propertyList);
        }
        currentClass = class_getSuperclass(currentClass);
    }
    c.properties = [mutableDictionary copy];
    
    return c;
}

@end


@interface DWProperty ()

@end

@implementation DWProperty

+ (DWProperty *)propertyWithRuntime:(objc_property_t)objc_property {
    DWProperty *property = [[DWProperty alloc] init];
    const char *propertyName = property_getName(objc_property);
    property.propertyName = [NSString stringWithUTF8String:propertyName];
    
    unsigned int attributeCount = 0;
    objc_property_attribute_t *attributeList = property_copyAttributeList(objc_property, &attributeCount);
    for (unsigned int j = 0; j < attributeCount; ++j) {
        objc_property_attribute_t attribute = *(attributeList + j);
        NSString *attributeName = [NSString stringWithUTF8String:attribute.name];
        if ([attributeName isEqualToString:@"T"]) {
            DWEncodingType encodingType = DWEncodingTypeFromChar(attribute.value);
            property.encodingType = encodingType;
            if (encodingType == DWEncodingTypeObject) {
                NSString *typeName = [NSString stringWithUTF8String:attribute.value];
                NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@\""];
                NSString *objectType = [typeName stringByTrimmingCharactersInSet:set];
                Class propertyClass = NSClassFromString(objectType);
                if (propertyClass) {
                    property.propertyClass = propertyClass;
                }
                property.objectType = DWObjectTypeFromClass(propertyClass);
            }
        } else if ([attributeName isEqualToString:@"R"]) {
            // readonly
            property.encodingType |= DWEncodingTypePropertyReadonly;
        } else if ([attributeName isEqualToString:@"C"]) {
            // copy
            property.encodingType |= DWEncodingTypePropertyCopy;
        } else if ([attributeName isEqualToString:@"&"]) {
            // retain
            property.encodingType |= DWEncodingTypePropertyRetain;
        } else if ([attributeName isEqualToString:@"N"]) {
            // nonatomic
            property.encodingType |= DWEncodingTypePropertyNonatomic;
        } else if ([attributeName isEqualToString:@"G"]) {
            // custom getter
            property.encodingType |= DWEncodingTypePropertyCustomGetter;
            NSString *value = [NSString stringWithUTF8String:attribute.value];
            property.getter = NSSelectorFromString(value);
        } else if ([attributeName isEqualToString:@"S"]) {
            // custom setter
            property.encodingType |= DWEncodingTypePropertyCustomSetter;
            NSString *value = [NSString stringWithUTF8String:attribute.value];
            property.setter = NSSelectorFromString(value);
        } else if ([attributeName isEqualToString:@"D"]) {
            // dynamic
            property.encodingType |= DWEncodingTypePropertyDynamic;
        } else if ([attributeName isEqualToString:@"W"]) {
            // weak
            property.encodingType |= DWEncodingTypePropertyWeak;
        }
    }
    if (attributeList) {
        free(attributeList);
    }
    
    if (!property.getter && [property.propertyName length] > 0) {
        property.getter = NSSelectorFromString(property.propertyName);
    }
    
    if (!property.setter &&
        [property.propertyName length] > 0 &&
        (property.encodingType & DWEncodingTypePropertyReadonly) != DWEncodingTypePropertyReadonly) {
        NSString *first = [[property.propertyName substringToIndex:1] uppercaseString];
        NSString *left = [property.propertyName substringFromIndex:1];
        NSString *setterName = [NSString stringWithFormat:@"set%@%@:", first, left];
        property.setter = NSSelectorFromString(setterName);
    }
    
    return property;
}

@end
