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
#import "DWProgressViewController.h"
#import "DWSendSMSViewController.h"
#import "DWGCDViewController.h"
#import "DWDebugViewController.h"
#import "DWPathViewController.h"
#import "DWDelegateViewController.h"
#import "DWAnimationViewController.h"
#import "DWTableViewController.h"
#import "NSString+DWKit.h"
#import "DWPermissionUtil.h"
#import "DWSkillViewController.h"

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
    vc.hidesBottomBarWhenPushed = YES;
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - DWDelegateTemp 

- (void)dw_text {
    NSLog(@"dw_text");
}

- (void)dw_textOne {
    NSLog(@"dw_text_one");
}


#pragma mark - Construct UI

__weak id reference = nil;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
//    @autoreleasepool {
//        NSString *str = [NSString stringWithFormat:@"test autorelease"];
//        reference = str;
//    }
//    [[NSArray array] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    
//    }];
//    NSLog(@"%s:%@",__FUNCTION__,reference);
    [DWPermissionUtil dw_photoLibraryAccess:^(DWAuthorizationStatus status) {
        NSLog(@"status %ld",status);
    } completionHandler:^(BOOL granted) {
        if (granted) {
            NSLog(@"granted YES");
        } else {
            NSLog(@"granted NO");
        }
    }];
}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    NSLog(@"%s:%@",__FUNCTION__,reference);
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    NSLog(@"%s:%@",__FUNCTION__,reference);
//}

- (void)initView {
    NSString *str = nil;

    self.title = @"objc";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,   kScreenHeight-kNavigationBarHeight-kTabBarHeight)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    [self addClass:NSStringFromClass([DWRichTextEditViewController class]) des:@"富文本编辑器"];
    [self addClass:NSStringFromClass([DWProgressViewController class]) des:@"NSProgress"];
    [self addClass:NSStringFromClass([DWSendSMSViewController class]) des:@"短信发送"];
    [self addClass:NSStringFromClass([DWGCDViewController class]) des:@"GCD并发"];
    [self addClass:NSStringFromClass([DWDebugViewController class]) des:@"debug"];
    [self addClass:NSStringFromClass([DWPathViewController class]) des:@"path"];
    [self addClass:NSStringFromClass([DWDelegateViewController class]) des:@"delegate"];
    [self addClass:NSStringFromClass([DWAnimationViewController class]) des:@"dotzoon"];
    [self addClass:NSStringFromClass([DWTableViewController class]) des:@"tableView"];
    [self addClass:NSStringFromClass([DWSkillViewController class]) des:@"tableView"];
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
//
//- (UIImage *)previewImage {
//    if (_previewImage) {
//        return _previewImage;
//    }
//    __block UIImage *resultImage;
//    if (_usePhotoKit) {
//        PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
//        imageRequestOptions.synchronous = YES;
//        [[[QMUIAssetsManager sharedInstance] phCachingImageManager] requestImageForAsset:_phAsset
//                                                                              targetSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)
//                                                                             contentMode:PHImageContentModeAspectFill
//                                                                                 options:imageRequestOptions
//                                                                           resultHandler:^(UIImage *result, NSDictionary *info) {
//                                                                               resultImage = result;
//                                                                           }];
//    } else {
//        CGImageRef fullScreenImageRef = [_alAssetRepresentation fullScreenImage];
//        resultImage = [UIImage imageWithCGImage:fullScreenImageRef];
//    }
//    _previewImage = resultImage;
//    return resultImage;
//}
//

//- (UIImage *)originImage {
//    if (_originImage) {
//        return _originImage;
//    }
//    __block UIImage *resultImage;
//    if (_usePhotoKit) {
//        PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
//        phImageRequestOptions.synchronous = YES;
//        [[[QMUIAssetsManager sharedInstance] phCachingImageManager] requestImageForAsset:_phAsset
//                                                                              targetSize:PHImageManagerMaximumSize
//                                                                             contentMode:PHImageContentModeDefault
//                                                                                 options:phImageRequestOptions
//                                                                           resultHandler:^(UIImage *result, NSDictionary *info) {
//                                                                               resultImage = result;
//                                                                           }];
//    } else {
//        CGImageRef fullResolutionImageRef = [_alAssetRepresentation fullResolutionImage];
//        // 通过 fullResolutionImage 获取到的的高清图实际上并不带上在照片应用中使用“编辑”处理的效果，需要额外在 AlAssetRepresentation 中获取这些信息
//        NSString *adjustment = [[_alAssetRepresentation metadata] objectForKey:@"AdjustmentXMP"];
//        if (adjustment) {
//            // 如果有在照片应用中使用“编辑”效果，则需要获取这些编辑后的滤镜，手工叠加到原图中
//            NSData *xmpData = [adjustment dataUsingEncoding:NSUTF8StringEncoding];
//            CIImage *tempImage = [CIImage imageWithCGImage:fullResolutionImageRef];
//
//            NSError *error;
//            NSArray *filterArray = [CIFilter filterArrayFromSerializedXMP:xmpData
//                                                         inputImageExtent:tempImage.extent
//                                                                    error:&error];
//            CIContext *context = [CIContext contextWithOptions:nil];
//            if (filterArray && !error) {
//                for (CIFilter *filter in filterArray) {
//                    [filter setValue:tempImage forKey:kCIInputImageKey];
//                    tempImage = [filter outputImage];
//                }
//                fullResolutionImageRef = [context createCGImage:tempImage fromRect:[tempImage extent]];
//            }
//        }
//        // 生成最终返回的 UIImage，同时把图片的 orientation 也补充上去
//        resultImage = [UIImage imageWithCGImage:fullResolutionImageRef scale:[_alAssetRepresentation scale] orientation:(UIImageOrientation)[_alAssetRepresentation orientation]];
//    }
//    _originImage = resultImage;
//    return resultImage;
//}
//

//- (UIImage *)thumbnailWithSize:(CGSize)size {
//    if (_thumbnailImage) {
//        return _thumbnailImage;
//    }
//    __block UIImage *resultImage;
//    if (_usePhotoKit) {
//        PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
//        phImageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
//        // 在 PHImageManager 中，targetSize 等 size 都是使用 px 作为单位，因此需要对targetSize 中对传入的 Size 进行处理，宽高各自乘以 ScreenScale，从而得到正确的图片
//        [[[QMUIAssetsManager sharedInstance] phCachingImageManager] requestImageForAsset:_phAsset
//                                                                              targetSize:CGSizeMake(size.width * ScreenScale, size.height * ScreenScale)
//                                                                             contentMode:PHImageContentModeAspectFill options:phImageRequestOptions
//                                                                           resultHandler:^(UIImage *result, NSDictionary *info) {
//                                                                               resultImage = result;
//                                                                           }];
//    } else {
//        CGImageRef thumbnailImageRef = [_alAsset thumbnail];
//        if (thumbnailImageRef) {
//            resultImage = [UIImage imageWithCGImage:thumbnailImageRef];
//        }
//    }
//    _thumbnailImage = resultImage;
//    return resultImage;
//}
//

@end

@implementation DWItemModel

@end
