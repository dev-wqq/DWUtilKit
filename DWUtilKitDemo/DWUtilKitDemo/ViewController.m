//
//  ViewController.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/9.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "ViewController.h"
#import "DWUtilities.h"
#import "DWRichTextEditViewController.h"
#import "DWProgressViewController.h"
#import "DWSendSMSViewController.h"
#import "DWGCDViewController.h"

@interface DWItemModel : NSObject

@property (nonatomic, copy) NSString *classDes;
@property (nonatomic, copy) NSString *className;

@end

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *mDataSource;

@end

@implementation ViewController

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    DWItemModel *itemModel = _mDataSource[indexPath.row];
    cell.textLabel.text = itemModel.className;
    cell.detailTextLabel.text = itemModel.classDes;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DWItemModel *model = _mDataSource[indexPath.row];
    UIViewController *vc = [[NSClassFromString(model.className) alloc] init];
    vc.title = model.classDes;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Construct UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
    Class subClass = NSClassFromString(@"__NSDictionaryM");
    if ([subClass isSubclassOfClass:[NSMutableDictionary class]]) {
        NSLog(@"yes");
    } else {
        NSLog(@"NO");
    }
    NSArray *arr = [NSArray array];
    [arr objectAtIndex:2];
//    arr = @[@"1",@"2"];
    
//     -[__NSArray0 objectAtIndex:]
//    [arr objectAtIndex:nil];
    
//    [arr subarrayWithRange:NSMakeRange(0, 10)];
    
//    -[__NSArray0 objectAtIndex:]
//    [arr objectAtIndex:-1];
//    NSString *str = arr[1];
    
    // -[NSArray objectsAtIndexes:]
//    [arr objectsAtIndexes:nil];
    
//    NSMutableArray *array = [NSMutableArray array];
//    [__NSArrayM objectAtIndex:]
//    [array objectAtIndex:1];
    
//    [__NSArrayM insertObject:atIndex:]
//    [array addObject:nil];
//    [array insertObject:@"" atIndex:2];
    
//    -[__NSArrayM removeObjectsInRange:]
//    [array removeObjectAtIndex:10];
    
//    [NSMutableArray removeObjectsAtIndexes:] 
//    [array removeObjectsAtIndexes:[NSIndexSet indexSetWithIndex:1]];
    
//    [__NSArrayM removeObjectsInRange:] 
//    [array removeObjectsInRange:NSMakeRange(0, 1)];
    
//    [array indexOfObject:nil];
//    [__NSArrayM insertObject:atIndex:]
//    [array addObject:@"12"];
    // 越界
//    [array insertObject:@"1" atIndex:2];
    
    // 越界
//    [array subarrayWithRange:NSMakeRange(0, 12)];
//    [__NSArrayM removeObjectsInRange:]
//    [array removeObjectsInRange:NSMakeRange(0, 12)];
//    [array replaceObjectAtIndex:10 withObject:nil];
    
}

- (void)initView {
    self.title = @"Demo";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,   kScreenHeight)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    [self addClass:NSStringFromClass([DWRichTextEditViewController class]) des:@"富文本编辑器"];
    [self addClass:NSStringFromClass([DWProgressViewController class]) des:@"NSProgress"];
    [self addClass:NSStringFromClass([DWSendSMSViewController class]) des:@"短信发送"];
    [self addClass:NSStringFromClass([DWGCDViewController class]) des:@"GCD并发"];
}

- (void)addClass:(NSString *)className des:(NSString *)des {
    if (!_mDataSource) {
        _mDataSource = [NSMutableArray array];
    }
    DWItemModel *itemModel = [[DWItemModel alloc] init];
    itemModel.className = className;
    itemModel.classDes = des;
    [_mDataSource addObject:itemModel];
}

@end

@implementation DWItemModel

@end
