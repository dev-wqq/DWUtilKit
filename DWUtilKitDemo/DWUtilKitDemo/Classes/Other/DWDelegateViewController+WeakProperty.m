//
//  DWDelegateViewController+WeakProperty.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2018/4/12.
//  Copyright © 2018年 duxing. All rights reserved.
//

#import "DWDelegateViewController+WeakProperty.h"
#import <objc/runtime.h>


typedef void(^DWWeakDeallocBlock)();

@interface DWWeakPropertyBlock: NSObject

@property (nonatomic, copy) DWWeakDeallocBlock weakBlock;

- (instancetype)initWithBlock:(DWWeakDeallocBlock)block;

@end

@implementation DWWeakPropertyBlock

- (instancetype)initWithBlock:(DWWeakDeallocBlock)block {
    if (self = [super init]) {
        _weakBlock = block;
    }
    return self;
}

- (void)dealloc {
    if (_weakBlock) {
        _weakBlock();
    }
}

@end

@implementation DWDelegateViewController (WeakProperty)

- (id)weakObject {
    return objc_getAssociatedObject(self, @selector(weakObject));
}

- (void)setWeakObject:(id)weakObject {
    
    DWWeakPropertyBlock *obj = [[DWWeakPropertyBlock alloc] initWithBlock:^{
        objc_setAssociatedObject(self, @selector(weakObject), nil, OBJC_ASSOCIATION_ASSIGN);
    }];
    // 
    objc_setAssociatedObject(weakObject, (__bridge const void *)(obj.weakBlock), weakObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @selector(weakObject), weakObject, OBJC_ASSOCIATION_ASSIGN);
}

@end
