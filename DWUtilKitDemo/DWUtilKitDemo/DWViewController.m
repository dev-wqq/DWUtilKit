//
//  DWViewController.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/12/7.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DWViewController.h"

@interface DWViewController ()

@end

@implementation DWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)dealloc {
    [self subDealloc];
    NSLog(@"dealloc %@", NSStringFromClass(self.class));
}


- (void)subDealloc {
    
}

@end
