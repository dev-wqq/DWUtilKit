//
//  DWRichTextEditSelectColorView.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/4/30.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DWRichTextEditSelectColorView.h"
#import "UIColor+DWKit.h"

@interface DWRichTextEditSelectColorConfig : NSObject

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) BOOL selected;

@end

@implementation DWRichTextEditSelectColorConfig

@end

@interface DWRichTextEditSelectColorColllectViewCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *button;

@end

#pragma mark -

@implementation DWRichTextEditSelectColorColllectViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_button];
    _button.layer.cornerRadius = 14;
    _button.layer.masksToBounds = YES;
    _button.layer.shouldRasterize = YES;
    _button.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _button.frame = self.bounds;
}

@end

#pragma mark -

@interface DWRichTextEditSelectColorView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
/**
 section max count, default = 6.
 */
@property (nonatomic, assign) NSInteger dw_sectionMaxCount;
/**
 default #363636
 */
@property (nonatomic, strong) UIColor *dw_bgColor;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *viewBackground;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, copy) DWSelectBlock selectedBlock;
@property (nonatomic, assign) CGPoint point;

@end

@implementation DWRichTextEditSelectColorView

- (UIColor *)dw_selectedColor {
    if (_selectIndexPath && _selectIndexPath.row < _colors.count) {
        UIColor *color = _colors[_selectIndexPath.row];
        return color;
    }
    return nil;
}

+ (NSArray<UIColor *> *)dw_richTextColors {
    NSArray *colors = @[@"#2d2d2d",@"#de4118",@"#19a2e5",@"#1cb72e",@"#d82b5d",@"#fbbb1d"];
    NSMutableArray *mColors = [NSMutableArray array];
    for (NSString *colorHexString in colors) {
        UIColor *color = [UIColor dw_opaqueColorWithHexString:colorHexString];
        [mColors addObject:color];
    }
    return mColors;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _colors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DWRichTextEditSelectColorColllectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
    DWRichTextEditSelectColorConfig *model = _dataSource[indexPath.row];
    [cell.button setBackgroundColor:model.color];
    [cell.button setImage:nil forState:UIControlStateNormal];
    [cell.button setImage:nil forState:UIControlStateNormal | UIControlStateHighlighted];
    UIImage *image = [UIImage imageNamed:@"rich_text_edit_color"];
    [cell.button setImage:image forState:UIControlStateSelected];
    [cell.button setImage:image forState:UIControlStateSelected | UIControlStateHighlighted];
    [cell.button addTarget:self action:@selector(doSelected:) forControlEvents:UIControlEventTouchUpInside];
    cell.button.selected = model.selected;
    return cell;
}

#pragma mark - Event Respond

- (void)doSelected:(UIButton *)sender {
    // 获取indexPath
    CGPoint point = [sender convertPoint:sender.center toView:_collectionView];
    NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:point];
    
    DWRichTextEditSelectColorConfig *model = _dataSource[indexPath.row];
    if (model.selected) {
        return;
    }
    NSMutableArray *mArray = [NSMutableArray array];
    // 如果已经有选中的颜色，则改变已选中验证的状态
    if (_selectIndexPath) {
        DWRichTextEditSelectColorConfig *currentModel = _dataSource[_selectIndexPath.row];
        currentModel.selected = NO;
        [mArray addObject:_selectIndexPath];
    }
    model.selected = YES;
    [mArray addObject:indexPath];
    [_collectionView reloadItemsAtIndexPaths:mArray];
    _selectIndexPath = [indexPath copy];
    // 选中操作延迟0.1，让用户能看到选中的颜色
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_selectedBlock) {
            _selectedBlock(self, model.color);
        }
        [self dw_dismiss:YES];
    });
}

- (void)doDismiss:(id)sender {
    [self dw_dismiss:YES];
}

#pragma mark - setup UI

- (void)dw_show:(BOOL)animated inView:(UIView *)superView {
    [superView addSubview:_viewBackground];
    _viewBackground.enabled = NO;
    _viewBackground.frame = superView.bounds;
    
    CGRect frame = [self _dw_customeViewFrame];
    CGPoint arrowPoint = [self convertPoint:self.point fromView:superView];
    self.layer.anchorPoint = CGPointMake((arrowPoint.x-frame.origin.x)/frame.size.width, 1.0);
    self.frame = frame;
    [self layoutIfNeeded];
    if (animated) {
        self.alpha = 0.0;
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
        [superView addSubview:self];
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformMakeScale(1.05, 1.05);
            self.alpha = 1.0;
        } completion:^(BOOL finished) {
            if (finished) {
                [UIView animateWithDuration:0.08 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    _viewBackground.enabled = YES;
                }];
            }
        }];
    } else {
        [superView addSubview:self];
        _viewBackground.enabled = YES;
    }
}

- (void)dw_dismiss:(BOOL)animated {
    if (!animated) {
        self.transform = CGAffineTransformIdentity;
        [_viewBackground removeFromSuperview];
        [self removeFromSuperview];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.transform = CGAffineTransformIdentity;
            [_viewBackground removeFromSuperview];
            [self removeFromSuperview];
        }];
    }
}

- (instancetype)initWithColors:(NSArray *)colors
                       atPoint:(CGPoint)point
                   selectBlock:(DWSelectBlock)selectBlock {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        _colors = colors;
        _point  = point;
        _selectedBlock = [selectBlock copy];
        _dw_sectionMaxCount = 6;
        _dw_bgColor = [UIColor dw_opaqueColorWithHexString:@"#363636"];
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    // init model data
    NSMutableArray *mArray = [NSMutableArray array];
    for (UIColor *color in _colors) {
        DWRichTextEditSelectColorConfig *model = [[DWRichTextEditSelectColorConfig alloc] init];
        model.color = color;
        model.selected = NO;
        [mArray addObject:model];
    }
    _dataSource = [mArray copy];
    
    // init UI
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(28, 28);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.allowsSelection = NO;
    [_collectionView registerClass:[DWRichTextEditSelectColorColllectViewCell class] forCellWithReuseIdentifier:@"cellId"];
    
    _viewBackground = [UIButton buttonWithType:UIButtonTypeCustom];
    _viewBackground.backgroundColor = [UIColor clearColor];
    [_viewBackground addTarget:self action:@selector(doDismiss:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _collectionView.frame = CGRectMake(10, 10, self.width-20, self.height-10-20);
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect pathRect = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(0, 0, 10, 0));
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathRect cornerRadius:4];
    [_dw_bgColor set];
    CGContextAddPath(context, path.CGPath);
    CGContextFillPath(context);
    
    CGFloat width = 10;
    CGPoint point = CGPointMake(_point.x-self.x-width, pathRect.size.height);
    path = [UIBezierPath bezierPath];
    [path moveToPoint:point];
    [path addLineToPoint:CGPointMake(point.x+16, point.y)];
    [path addLineToPoint:CGPointMake(point.x+8, point.y+width)];
    [path closePath];
    [_dw_bgColor set];
    CGContextAddPath(context, path.CGPath);
    CGContextFillPath(context);
}

- (CGRect)_dw_customeViewFrame {
    UICollectionViewFlowLayout *viewLayout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
    CGSize itemSize = viewLayout.itemSize;
    CGFloat marX = viewLayout.minimumInteritemSpacing;
    CGFloat marY = viewLayout.minimumLineSpacing;
    CGFloat width = 0;
    if (_colors.count < _dw_sectionMaxCount) {
        width = (itemSize.width + marX) *_colors.count + marX;
    } else {
        width = (itemSize.width + marX) *_dw_sectionMaxCount + marX;
    }
    
    CGFloat height = 0;
    NSInteger section = _colors.count / _dw_sectionMaxCount;
    NSInteger r = _colors.count % _dw_sectionMaxCount;
    if (r != 0) {
        section +=1 ;
    }
    height = (itemSize.height + marY) * section + marY + 10;
    
    return CGRectMake(12, _point.y-height, width, height);
}

@end
