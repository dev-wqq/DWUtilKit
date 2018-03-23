//
//  DWKVOViewController.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2018/3/12.
//  Copyright © 2018年 duxing. All rights reserved.
//

#import "DWKVOViewController.h"

@interface DWTarget: NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, assign) NSUInteger age;

@end

@implementation DWTarget

- (void)setAge:(NSUInteger)age {
    if (_age == age) {
        return;
    }
    [self willChangeValueForKey:@"age"];
    _age = age;
    [self didChangeValueForKey:@"age"];
}

/**
 实现该方法，那么在重写Age的set方法时候，调用willChangeValueForKey:和didChangeValueForKey:
 观察者会收到通知，不调用的话就不会收到通知
 */
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    if ([key isEqualToString:@"age"]) {
        return NO;
    }
    return [super automaticallyNotifiesObserversForKey:key];
}

/**
 KVO 中的依赖建的使用，当age这个属性改变的时候，name也会收到通知
 */
+ (NSSet<NSString *> *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    if ([key isEqualToString:@"status"]) {
        return [NSSet setWithObject:@"age"];
    }
    return [super keyPathsForValuesAffectingValueForKey:key];
}

@end


@interface DWKVOViewController ()

@property (nonatomic, strong) DWTarget *test;

@end

@implementation DWKVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.test = [[DWTarget alloc] init];
    self.test.name = @"小明";
    /**
     执行方法之前，isa->DWTarget
     执行方法之后，isa->NSKVONotifying_DWTarget
     DWTarget动态派生出NSKVONotifying_DWTarget，重新keyPath的set方法，
     添加willChangeValueForKey:和didChangeValueForKey:来
     */
    [self.test addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self.test addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self.test addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.test.age = arc4random()%50 + 18;
}

- (void)dealloc {
    [self.test removeObserver:self forKeyPath:@"age"];
    [self.test removeObserver:self forKeyPath:@"status"];
    [self.test removeObserver:self forKeyPath:@"name"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"age"]) {
        NSNumber *willValue = change[NSKeyValueChangeNewKey];
        NSNumber *didValue = change[NSKeyValueChangeOldKey];
        NSLog(@"%@ will change value: %@, did change value %@",keyPath,willValue.stringValue,didValue.stringValue);
        return;
    } else if ([keyPath isEqualToString:@"name"] || [keyPath isEqualToString:@"status"]) {
        NSString *willValue = change[NSKeyValueChangeNewKey];
        NSString *didValue = change[NSKeyValueChangeOldKey];
        NSLog(@"%@ will change value: %@, did change value %@",keyPath,willValue,didValue);
        return;
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

@end
