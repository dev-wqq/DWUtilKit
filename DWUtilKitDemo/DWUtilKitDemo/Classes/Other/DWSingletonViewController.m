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

@end

#define DWTestLog(var) NSLog(@"%@ class name:%@, p-->%p",var,NSStringFromClass([var class]),var);

@implementation DWSingletonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DWSingletonManager *obj1 = [DWSingletonManager sharedInstance];
    NSLog(@"obj1:%p",obj1);

    /**
     __NSCFString           NSString的子类   存储在堆上
     __NSCFConstantString   编译常量         存储在字符串常量区
     NSTaggedPointerString  64位系统针对NSString,NSNumber的优化，8位能存储下的内容使用这个优化技术
     */
    NSString *a = @"test";
    //Using 'initWithString:' with a literal is redundant
    NSString *b = [[NSString alloc] initWithString:@"test"];
    //Using 'stringWithString:' with a literal is redundant
    NSString *c = [NSString stringWithString:@"test"];
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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[DWSingletonManager sharedInstance] reset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    NSLog(@"test");
    return [super allocWithZone:zone];
}

@end
