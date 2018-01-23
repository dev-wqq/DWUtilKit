//
//  DWTestViewController.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/12/21.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DWTestViewController.h"

@interface DWTestViewController ()

@property (nonatomic, strong) NSString *string1;
@property (nonatomic, assign) NSString *string2;

@end

@implementation DWTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    // http://www.infoq.com/cn/articles/deep-understanding-of-tagged-pointer/
    // code 1
    self.string1 = [[NSString alloc] initWithUTF8String:"string1"];
    NSLog(@"string1 === %p",self.string1);
    self.string2 = self.string1;
    NSLog(@"string2 === %p",self.string2);
    
    self.string1 = nil;
    NSLog(@"string1 === %p",self.string1);
    NSLog(@"string2 === %@",self.string2);
    
    NSLog(@"\\\\\\\\\\\\\\\\\\\\\\\\\\\\");
    // code 2
    self.string1 = [[NSString alloc] initWithUTF8String:"string123"];
    NSLog(@"string1 === %p",self.string1);
    self.string2 = self.string1;
    NSLog(@"string2 === %p",self.string2);
    
    self.string1 = nil;
    NSLog(@"string1 === %p",self.string1);
    NSLog(@"string2 === %@",self.string2);
    
    NSLog(@"\\\\\\\\\\\\\\\\\\\\\\\\\\\\");
    // code 2
    self.string1 = [[NSString alloc] initWithUTF8String:"string1234"];
    NSLog(@"string1 === %p",self.string1);
    self.string2 = self.string1;
    NSLog(@"string2 === %p",self.string2);
    
    self.string1 = nil;
    NSLog(@"string1 === %p",self.string1);
    NSLog(@"string2 === %@",self.string2);
}

    

@end
