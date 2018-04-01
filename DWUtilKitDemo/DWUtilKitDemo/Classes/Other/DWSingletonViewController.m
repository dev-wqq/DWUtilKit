//
//  DWSingletonViewController.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2018/3/23.
//  Copyright © 2018年 duxing. All rights reserved.
//

#import "DWSingletonViewController.h"

@interface DWSingletonManager: NSObject <NSCopying>

+ (instancetype)sharedInstance;

- (void)reset;

@end

static DWSingletonManager *_sharedInstance;
static dispatch_once_t _onceToken;

@implementation DWSingletonManager

+ (instancetype)sharedInstance {
    if (_sharedInstance) return _sharedInstance;
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    dispatch_once(&_onceToken, ^{
        _sharedInstance = [super allocWithZone:zone];
        // Initialization property
    });
    return _sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _sharedInstance;
}

- (void)reset {
    _onceToken = 0;
    _sharedInstance = nil;
}
@end

@interface DWSingletonViewController ()

@property (nonatomic, copy) NSString *test1;
@property (nonatomic, copy) NSString *test2;

@property (nonatomic, strong) NSMutableString *mTest1;
@property (nonatomic, copy)   NSMutableString *mTest2;

@end

#define DWTestLog(var) NSLog(@"%@ class name:%@, p-->%p",var,NSStringFromClass([var class]),var);

@interface DWTestArrModel: NSObject

@end

@implementation DWTestArrModel

@end

@implementation DWSingletonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DWSingletonManager *obj1 = [DWSingletonManager sharedInstance];
    NSLog(@"obj1:%p",obj1);
    
    [self stringCopyVSMutableCopy];
}

// 浅拷贝和深拷贝理解
- (void)stringCopyVSMutableCopy {
    // https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/Collections/Articles/Copying.html
    /** 浅拷贝就是指拷贝容器，容器里的内容还是引用的原来的对象，深拷贝就是容器里的对象也会被拷贝
        是否开启新的内存地址
        是否影响内存地址的引用计数
     */
    NSString *test = [NSString stringWithFormat:@"测试demo"];
    NSString *test1 = test.copy;
    NSString *test2 = test.mutableCopy;
    NSLog(@"%@ test：%p, test1：%p, test2：%p",NSStringFromClass([test class]),test,test1,test2);
    
    NSMutableString *mtest = [[NSMutableString alloc] initWithString:@"测试demo"];
    NSMutableString *mtest1 = mtest.copy;
    NSMutableString *mtest2 = mtest.mutableCopy;
    NSLog(@"%@ mtest：%p, mtest1：%p, mtest2：%p",NSStringFromClass([mtest class]), mtest, mtest1, mtest2);
    NSLog(@"mutableString->copy: %@",NSStringFromClass([mtest1 class]));
//    [mtest1 appendString:@"123"];
}

- (void)stringManager {
    /**
     __NSCFString           NSString的子类   存储在堆上
     __NSCFConstantString   编译常量         存储在字符串常量区
     NSTaggedPointerString  64位系统针对NSString,NSNumber的优化，8位能存储下的内容使用这个优化技术
     */
    NSString *a = @"test";
    //Using 'initWithString:' with a literal is redundant
    NSString *b = @"test";
    //Using 'stringWithString:' with a literal is redundant
    NSString *c = @"test";
    NSString *d = [[NSString alloc] initWithFormat:@"test"];
    NSString *e = [NSString stringWithFormat:@"test"];
    NSString *f = [NSString stringWithFormat:@"12345678"];
    NSString *g = [NSString stringWithFormat:@"123456789"];
    NSString *h = [NSString stringWithFormat:@"1234567890"];
    
    DWTestLog(a);
    DWTestLog(b);
    DWTestLog(c);
    DWTestLog(d);
    DWTestLog(e);
    DWTestLog(f);
    DWTestLog(g);
    DWTestLog(h);
}


@end
