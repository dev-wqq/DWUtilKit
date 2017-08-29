//
//  DWSectionCellViewController.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/8/28.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DWSectionCellViewController.h"
#import "DWTableViewCell.h"

@interface DWSectionCellItem : NSObject

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, copy) NSString *title;
- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon;
@end

@interface  DWSectionTableViewCell : DWTableViewCell

@property (nonatomic, strong) UIImageView *imageViewIcon;
@property (nonatomic, strong) UILabel *titleLable;

@end

@interface DWSectionCellViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *dictionary;

@end

@implementation DWSectionCellViewController

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dictionary.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = _dictionary[@(section)];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DWSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    cell.dwHideTopSeparatorLine = NO;
    cell.dwLastEdgeInsets = UIEdgeInsetsZero;
    NSArray *arr = _dictionary[@(indexPath.section)];
    DWSectionCellItem *item = arr[indexPath.row];
    cell.imageViewIcon.image = item.icon;
    cell.titleLable.text = item.title;
    [cell.titleLable sizeToFit];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

#pragma mark - Construct UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupData];
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
    [self.tableView registerClass:[DWSectionTableViewCell class] forCellReuseIdentifier:@"cellId"];
}

- (void)setupData {
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    NSMutableArray *mArr = [NSMutableArray array];
    NSInteger index = 0;
    [mArr addObject:[[DWSectionCellItem alloc] initWithTitle:@"看一看" icon:[UIImage imageNamed:@"add_image_normal"]]];
    mDict[@(index)] = mArr;
    
    index++;
    mArr = [NSMutableArray array];
    [mArr addObject:[[DWSectionCellItem alloc] initWithTitle:@"看一看" icon:[UIImage imageNamed:@"add_image_normal"]]];
    [mArr addObject:[[DWSectionCellItem alloc] initWithTitle:@"看一看" icon:[UIImage imageNamed:@"add_image_normal"]]];
    mDict[@(index)] = mArr;
    
    index++;
    mArr = [NSMutableArray array];
    [mArr addObject:[[DWSectionCellItem alloc] initWithTitle:@"看一看" icon:[UIImage imageNamed:@"add_image_normal"]]];
    [mArr addObject:[[DWSectionCellItem alloc] initWithTitle:@"看一看" icon:[UIImage imageNamed:@"add_image_normal"]]];
    [mArr addObject:[[DWSectionCellItem alloc] initWithTitle:@"看一看" icon:[UIImage imageNamed:@"add_image_normal"]]];
    mDict[@(index)] = mArr;
    
    index++;
    mArr = [NSMutableArray array];
    [mArr addObject:[[DWSectionCellItem alloc] initWithTitle:@"看一看" icon:[UIImage imageNamed:@"add_image_normal"]]];
    [mArr addObject:[[DWSectionCellItem alloc] initWithTitle:@"看一看" icon:[UIImage imageNamed:@"add_image_normal"]]];
    [mArr addObject:[[DWSectionCellItem alloc] initWithTitle:@"看一看" icon:[UIImage imageNamed:@"add_image_normal"]]];
    [mArr addObject:[[DWSectionCellItem alloc] initWithTitle:@"看一看" icon:[UIImage imageNamed:@"add_image_normal"]]];
    mDict[@(index)] = mArr;
    
    _dictionary = [mDict copy];
}

@end

@implementation DWSectionCellItem

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon {
    if (self = [super init]) {
        _title = title;
        _icon = icon;
    }
    return self;
}

@end

@implementation DWSectionTableViewCell

- (void)setupUI {
    self.imageViewIcon = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imageViewIcon];
    
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.titleLable];
    self.titleLable.font = [UIFont systemFontOfSize:14];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.imageViewIcon.image.size;
    self.imageViewIcon.frame = CGRectMake(10, YCenterInContainer(size.height, self.contentView.height), size.width, size.height);
    self.titleLable.frame = CGRectMake(self.imageViewIcon.maxX+5, YCenterInContainer(self.titleLable.height, self.contentView.height), self.titleLable.width, self.titleLable.height);
}

@end
