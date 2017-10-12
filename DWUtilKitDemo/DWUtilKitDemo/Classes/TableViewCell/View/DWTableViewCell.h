//
//  DWTableViewCell.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/8/28.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWTableViewCell : UITableViewCell

/**
 cell register tableView.
 */
@property (nonatomic, strong, readonly) UITableView *dwTableView;

/**
 default NO
 仅仅针对UITableViewStylePlain有用，UITableViewStyleGrouped系统已经内置顶部分割线。
 */
@property (nonatomic, assign) BOOL dwHideFisrtCellTopSeparatorLine;

/**
 default NO,
 仅仅针对UITableViewStylePlain有用，UITableViewStyleGrouped系统已经内置顶部分割线。
 
 当我们把TableView的Style设置为UITableViewStylePlain在两种case下系统会自动隐藏底部分割线：
 case 1: section > 1:
    - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
 
 case 2: section footer height > 0:
    - (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
 
 自己多次实践现在就发现这两个case.
 */
@property (nonatomic, assign) BOOL dwHideLastCellBottomSeparatorLine;

/**
 default UIEdgeInsetsZero,
 
 仅仅针对UITableViewStylePlain section = 1 dnd section footer height = 0 有用.
 */
@property (nonatomic ,assign) UIEdgeInsets dwLastCellEdgeInset;

/**
 override setup UI.
 */
- (void)setupUI;


@end
