//
//  DWDelegateViewController.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/6/20.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DWDelegateViewController.h"

@protocol DWDelegateTemp <NSObject>

- (void)dw_test;
- (void)dw_testAssign;

@end

@interface DWDelegeModel : NSObject <DWDelegateTemp>



@end

@implementation DWDelegeModel

- (void)dw_test {
    NSLog(@"dw_test");
}

- (void)dw_testAssign {
    NSLog(@"dw_test_assign");
}

@end

@interface DWDelegateViewController ()

@property (nonatomic, weak) id<DWDelegateTemp> delegate;
@property (nonatomic, assign) id<DWDelegateTemp> delegateAssign;


@end

@implementation DWDelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // [self testDelegate];
    [self testDelegateMost];
}

- (void)testDelegateMost {

}

/**
 使用weak和assign 修改delegate的区别：
 weak属性的变量是不为其所有对象持有的，并且在该变量被销毁之后，weak修饰的变量的值会自动被赋值为nil;
 assign只是单纯的拷贝所赋值变量的值<值引用>，单纯的指针复制，如果该引用变量被销毁以后，在对其发送消息会crash
 (lldb) po self.delegate
 nil
 (lldb) po self.delegateAssign
 0x0000600000200120
 */
- (void)testDelegate {
    DWDelegeModel *model = [[DWDelegeModel alloc] init];
    self.delegate = model;
    self.delegateAssign = model;
    
    [self.delegate dw_test];
    [self.delegateAssign dw_testAssign];
    model = nil;
    [self.delegate dw_test];
    
    NSLog(@"到 assign");
    [self.delegateAssign dw_testAssign];
}



@end
