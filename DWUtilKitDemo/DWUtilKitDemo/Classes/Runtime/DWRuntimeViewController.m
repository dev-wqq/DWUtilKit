//
//  DWRuntimeViewController.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/12/19.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DWRuntimeViewController.h"
#import <objc/message.h>

@interface DWRuntimeModel: NSObject

- (void)sayHello;

@end

@implementation DWRuntimeModel

- (void)sayHello {
    NSLog(@"Hi, Hello");
}

@end

@interface DWRuntimeViewController ()

@end

@implementation DWRuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self message];
    
}

- (void)message {

    DWRuntimeModel *model = [[DWRuntimeModel alloc] init];
    [model sayHello];
    
    /**
     直接发送消息
     objc_msgSend(void) OBJC_AVAILABLE(10.0, 2.0, 9.0, 1.0, 2.0);
     在message.h 中定义的objc_msgSend函数，并没有明确参数列表和返回类型，
     所以我们需要强制转换一下，否则编译不会通过。
     
     使用objc_msgSend来发送消息，需要经过消息分发的过程。
    */
    ((void (*)(id, SEL))objc_msgSend)(model, @selector(sayHello));
    
    /**
     直接调用函数，绕过消息分发机制直接调用函数。
     methodForSelector 可以得到SEL对象的函数的IMP, 这样就可以直接绕过消息分发机制，直接调用函数，
     实际开发中不建议绕过默认的消息分发机制。
     */
    void(*sayHello)(id, SEL);
    sayHello = (void(*)(id, SEL))[model methodForSelector:@selector(sayHello)];
    sayHello(model, @selector(sayHello));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/**
 https://juejin.im/post/58f833458d6d81005875f872
 第一步
 在没有找到方法时，会调用此方法，可用于动态添加方法
 返回yes,表示响应selector 的实现已经被找到并添加到类中，否则返回NO
 */
//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    return YES;
//}

/**
 第二步
 如果第一步的返回NO 或者直接返回YES 而没有添加方法，改方法会被调用
 在这个方法中，我们可以指定一个可以返回一个响应方法的对象
 如果返回self 就会死循环
 */
//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    if (aSelector == @selector(www)) {
//        return self.alternateObject;
//    }
//    return [super forwardingTargetForSelector:aSelector];
//}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}



@end
