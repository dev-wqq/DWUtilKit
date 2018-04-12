//
//  ViewController.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/9.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "ObjcViewController.h"
#import "DWUtilities.h"
#import "DWRichTextEditViewController.h"
#import "DWSendSMSViewController.h"
#import "DWGCDViewController.h"
#import "DWDebugViewController.h"
#import "DWDelegateViewController.h"
#import "DWAnimationViewController.h"
#import "NSString+DWKit.h"
#import "DWPermissionUtil.h"
#import "DWSkillViewController.h"
#import "DWSectionCellViewController.h"
#import "DWDramImageViewController.h"
#import "DWCollectionViewController.h"
#import "DWUtilities.h"
#import "DWWebViewController.h"
#import "DWRuntimeViewController.h"
#import "DWTestViewController.h"
#import "DWKVOViewController.h"
#import "DWSingletonViewController.h"
#import "DWAlgorithmViewController.h"

@interface DWItemModel : NSObject

@property (nonatomic, copy) NSString *classDes;
@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) NSString *name;
@end

@interface ObjcViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *mDataSource;

@end

@implementation ObjcViewController

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellId"];
    }
    
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
    vc.hidesBottomBarWhenPushed = YES;
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Construct UI

__weak id reference = nil;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
//    NSLog(@"vc = %@ , 地址 = %p", self, &self);
//    id cls = [DWRuntimeTest2 class];
//     NSLog(@"DWRuntimeTest2 = %@ 地址 = %p", cls, &cls);
//
//    void *obj = &cls;
//    NSLog(@"Void *obj = %@ 地址 = %p", obj,&obj);
//
//    [(__bridge id)obj say];
//
//    DWRuntimeTest2 *sark = [[DWRuntimeTest2 alloc]init];
//    NSLog(@"DWRuntimeTest2 instance = %@ 地址 = %p",sark,&sark);
//    [sark say];
}

- (void)initView {
    self.title = @"objc";

    NSLog(@"%s,%s,%d,",__FILE__,__FUNCTION__,__LINE__);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,   kScreenHeight-kNavigationBarHeight-kTabBarHeight)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    
    [self addClass:NSStringFromClass([DWSingletonViewController class])
               des:@"如何写好一个单例（非共享单例）"];
    [self addClass:NSStringFromClass([DWRuntimeViewController class])
               des:@"消息传递和消息转发"];
    [self addClass:NSStringFromClass([DWKVOViewController class])
               des:@"KVO 自动/手动实现，依赖键"];
    [self addClass:NSStringFromClass([DWGCDViewController class])
               des:@"GCD并发, A、B先执行然后在执行C"];
    [self addClass:NSStringFromClass([DWAlgorithmViewController class])
               des:@"常见算法的实现：冒泡、快速、二分查找、链表翻转、栈、普通二叉树^前中后、栈、BFS、DFS"];
    [self addClass:NSStringFromClass([DWSectionCellViewController class])
               des:@"优雅处理first cell顶部分割线和last cell分割线边距"];
    [self addClass:NSStringFromClass([DWDramImageViewController class])
               des:@"图像的性能优化"];
    [self addClass:NSStringFromClass([DWDelegateViewController class])
               des:@"weak和assign的区别"];
//    [self addClass:NSStringFromClass([DWSendSMSViewController class])
//               des:@"短信发送"];
//    [self addClass:NSStringFromClass([DWDebugViewController class])
//               des:@"debug"];
//    [self addClass:NSStringFromClass([DWAnimationViewController class])
//               des:@"dotzoon"];
//    [self addClass:NSStringFromClass([DWSkillViewController class])
//               des:@"开发技巧"];
//    [self addClass:NSStringFromClass([DWCollectionViewController class])
//               des:@"collection View"];
//    [self addClass:NSStringFromClass([DWWebViewController class])
//               des:@"web"];
//    [self addClass:NSStringFromClass([DWTestViewController class])
//                des:@"test string"];
//    [self addClass:NSStringFromClass([DWRichTextEditViewController class])
//               des:@"富文本编辑器"];
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
