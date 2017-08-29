//
//  DWTableViewCell.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/8/28.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DWTableViewCell.h"

@interface DWTableViewCell ()

@property (nonatomic, strong) UIView *dwTapSeparatorLine;

@end

@implementation DWTableViewCell

@synthesize dwTableView = _dwTableView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _dwLastEdgeInsets = UIEdgeInsetsZero;
        _dwHideTopSeparatorLine = NO;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UITableView *tableView = self.dwTableView;
    
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:self.center];
    if (!indexPath) {
        return;
    }
    
    // first cell display top separator line
    if (!_dwHideTopSeparatorLine && indexPath.row == 0) {
        self.dwTapSeparatorLine.backgroundColor = tableView.separatorColor;
        self.dwTapSeparatorLine.frame = CGRectMake(0, 0, self.contentView.width, CGFloatFromPixel(1));
    } else {
        [_dwTapSeparatorLine removeFromSuperview];
        _dwTapSeparatorLine = nil;
    }
    
    if (tableView.separatorStyle == UITableViewCellSeparatorStyleNone) {
        return;
    }
    
    // cell display bottom separator line
    BOOL lastCell = NO;
    if ([tableView.dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        NSInteger rows = [tableView.dataSource tableView:tableView numberOfRowsInSection:indexPath.section];
        lastCell = indexPath.row == rows - 1;
    }
    
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:lastCell ? _dwLastEdgeInsets : tableView.separatorInset];
    }
    if ([self respondsToSelector:@selector(preservesSuperviewLayoutMargins)]) {
        self.preservesSuperviewLayoutMargins = NO;
    }
    if ([self respondsToSelector:@selector(setLayoutManager:)]) {
        [self setLayoutMargins:lastCell ? _dwLastEdgeInsets : tableView.separatorInset];
    }
}

#pragma mark - Getters Method

- (UITableView *)dwTableView {
    if (!_dwTableView) {
        id view = [self superview];
        while (view && [view isKindOfClass:[UITableView class]] == NO) {
            view = [view superview];
        }
        _dwTableView = (UITableView *)view;
    }
    return _dwTableView;
}

- (UIView *)dwTapSeparatorLine {
    if (!_dwTapSeparatorLine) {
        _dwTapSeparatorLine = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_dwTapSeparatorLine];
    }
    return _dwTapSeparatorLine;
}


@end
