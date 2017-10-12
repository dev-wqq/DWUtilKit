//
//  DWEdgeInsetViewController.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/8/29.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DWEdgeInsetViewController.h"
#import "DWEdgeInsetTableViewCell.h"

@interface DWEdgeInsetViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DWEdgeInsetViewController

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - Construct UI

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}
- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.001)];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableView.allowsSelection = NO;
    [self.tableView registerClass:[DWEdgeInsetTableViewCell class] forCellReuseIdentifier:@"cellId"];
}

@end
