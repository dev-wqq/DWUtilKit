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
 default NO, diplay tableView first Cell top separator line.
 */
@property (nonatomic, assign) BOOL dwHideTopSeparatorLine;

/**
 default UIEdgeInsetsZero, set tableView last cell bottom separator lint edge insets.
 */
@property (nonatomic, assign) UIEdgeInsets dwLastEdgeInsets;

/**
 override setup UI.
 */
- (void)setupUI;


@end
