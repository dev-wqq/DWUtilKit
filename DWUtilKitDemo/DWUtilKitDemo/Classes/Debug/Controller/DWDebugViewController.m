//
//  DWDebugViewController.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/5/27.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DWDebugViewController.h"
#import "UIViewController+DWSystemDebug.h"

@interface DWDebugViewController ()

@end

@implementation DWDebugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self dw_showSystemDebuggingInfomationOverlay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
