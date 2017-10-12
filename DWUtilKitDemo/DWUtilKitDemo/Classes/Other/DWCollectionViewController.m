//
//  DWCollectionViewController.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/9/3.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DWCollectionViewController.h"

@interface DWSeparatorlineView : UICollectionReusableView

@end

@interface DWCollectionLineFlowLayout : UICollectionViewFlowLayout

@end

@interface DWCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation DWCollectionViewController

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - Construct UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupData];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor greenColor];
    
    DWCollectionLineFlowLayout *layout = [[DWCollectionLineFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(floorf((kScreenWidth - 1.5-20)/4), 50);
    layout.minimumLineSpacing = 0.5;
    layout.minimumInteritemSpacing = 0.5;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight) collectionViewLayout:layout];
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate   = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
}

- (void)setupData {

}

@end

@implementation DWSeparatorlineView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

@end

@implementation DWCollectionLineFlowLayout

- (void)prepareLayout {
    // Registers my decoration views.
    [self registerClass:[DWSeparatorlineView class] forDecorationViewOfKind:@"Vertical"];
    [self registerClass:[DWSeparatorlineView class] forDecorationViewOfKind:@"Horizontal"];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath {
    // Prepare some variables.
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:indexPath.row+1 inSection:indexPath.section];
    
    UICollectionViewLayoutAttributes *cellAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    UICollectionViewLayoutAttributes *nextCellAttributes = [self layoutAttributesForItemAtIndexPath:nextIndexPath];
    
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
    
    CGRect baseFrame = cellAttributes.frame;
    CGRect nextFrame = nextCellAttributes.frame;
    
    CGFloat strokeWidth = 0.5;
    CGFloat spaceToNextItem = 0;
    if (nextFrame.origin.y == baseFrame.origin.y)
        spaceToNextItem = (nextFrame.origin.x - baseFrame.origin.x - baseFrame.size.width);
    
    if ([decorationViewKind isEqualToString:@"Vertical"]) {
        CGFloat padding = 0;
        
        // Positions the vertical line for this item.
        CGFloat x = baseFrame.origin.x + baseFrame.size.width + (spaceToNextItem - strokeWidth)/2;
        layoutAttributes.frame = CGRectMake(x,
                                            baseFrame.origin.y + padding,
                                            strokeWidth,
                                            baseFrame.size.height - padding*2);
    } else {
        // Positions the horizontal line for this item.
        layoutAttributes.frame = CGRectMake(baseFrame.origin.x,
                                            baseFrame.origin.y + baseFrame.size.height,
                                            baseFrame.size.width + spaceToNextItem,
                                            strokeWidth);
    }
    
    layoutAttributes.zIndex = -1;
    return layoutAttributes;
}
    
    
    
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *baseLayoutAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray * layoutAttributes = [baseLayoutAttributes mutableCopy];
    
    for (UICollectionViewLayoutAttributes *thisLayoutItem in baseLayoutAttributes) {
        if (thisLayoutItem.representedElementCategory == UICollectionElementCategoryCell) {
            // Adds vertical lines when the item isn't the last in a section or in line.
            if (!([self indexPathLastInSection:thisLayoutItem.indexPath] ||
                  [self indexPathLastInLine:thisLayoutItem.indexPath])) {
                UICollectionViewLayoutAttributes *newLayoutItem = [self layoutAttributesForDecorationViewOfKind:@"Vertical" atIndexPath:thisLayoutItem.indexPath];
                [layoutAttributes addObject:newLayoutItem];
            }
            
            // Adds horizontal lines when the item isn't in the last line.
            if (![self indexPathInLastLine:thisLayoutItem.indexPath]) {
                UICollectionViewLayoutAttributes *newHorizontalLayoutItem = [self layoutAttributesForDecorationViewOfKind:@"Horizontal" atIndexPath:thisLayoutItem.indexPath];
                [layoutAttributes addObject:newHorizontalLayoutItem];
            }
        }
    }
    
    return layoutAttributes;
}


- (BOOL)indexPathLastInSection:(NSIndexPath *)indexPath {
    NSInteger lastItem = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:indexPath.section];
    return  lastItem == indexPath.row;
}

- (BOOL)indexPathInLastLine:(NSIndexPath *)indexPath {
    NSInteger lastItemRow = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:indexPath.section]-1;
    NSIndexPath *lastItem = [NSIndexPath indexPathForItem:lastItemRow inSection:indexPath.section];
    UICollectionViewLayoutAttributes *lastItemAttributes = [self layoutAttributesForItemAtIndexPath:lastItem];
    UICollectionViewLayoutAttributes *thisItemAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    
    return lastItemAttributes.frame.origin.y == thisItemAttributes.frame.origin.y;
}

- (BOOL)indexPathLastInLine:(NSIndexPath *)indexPath {
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:indexPath.row+1 inSection:indexPath.section];
    
    UICollectionViewLayoutAttributes *cellAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    UICollectionViewLayoutAttributes *nextCellAttributes = [self layoutAttributesForItemAtIndexPath:nextIndexPath];
    
    if (!nextIndexPath && indexPath) {
        return YES;
    }
    
    return !(cellAttributes.frame.origin.y == nextCellAttributes.frame.origin.y);
}

@end
