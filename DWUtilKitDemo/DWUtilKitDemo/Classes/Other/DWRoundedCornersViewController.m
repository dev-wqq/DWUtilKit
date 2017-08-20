//
//  DWRoundedCornersViewController.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/6/21.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DWRoundedCornersViewController.h"

@interface DWRoundedCornersTableViewCell : UITableViewCell

@end

@interface DWRoundedCornersViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DWRoundedCornersViewController

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DWRoundedCornersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[DWRoundedCornersTableViewCell class] forCellReuseIdentifier:@"cellId"];
}

- (void)drawFromLayerWithView:(UIView *)view {
    
}


- (void)drawFromBezierPathAndGraphicsWithView:(UIView *)view {

}


- (void)drawFromBezierPathAndShapeLayerWithView:(UIView *)view {

}

@end

@implementation DWRoundedCornersTableViewCell


@end
