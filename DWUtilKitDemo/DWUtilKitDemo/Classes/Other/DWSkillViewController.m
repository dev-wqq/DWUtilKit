//
//  DWSkillViewController.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/6/27.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DWSkillViewController.h"

@interface DWSkillViewController ()

@end

@implementation DWSkillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self switchRootViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 动画切换window的根视图
- (void)switchRootViewController {
    [UIView transitionWithView:[UIApplication sharedApplication].keyWindow
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        [UIApplication sharedApplication].keyWindow.rootViewController = [UIViewController new];
                        [UIView setAnimationsEnabled:oldState];
                    } completion:nil];
}




@end
