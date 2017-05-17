//
//  DWGCDViewController.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/5/17.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DWGCDViewController.h"
#import <SDWebImage/SDWebImageDownloader.h>

typedef void(^DWAsyncCompleteBlock)(NSDictionary *responseDict);

@interface DWGCDViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation DWGCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *imageUrlStr = @[@"https://p1.dodoca.com/org/2/df/894/db2c/b3b8f04268d6c199ab38eb.png",
                             @"https://p1.dodoca.com/org/1/a1/3d9/fe5b/4c6effc7b69de4487b9bc8.jpg",
                             @"https://p1.dodoca.com/org/7/30/165/c5ca/57d118ff80b79a98028c36.jpg",
                             @"https://p1.dodoca.com/org/f/38/957/97b9/86ebd09619e44e257935a6.jpg"];
    kWeakSelf(weakSelf);
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_indicatorView];
    _indicatorView.center = CGPointMake(kScreenWidth/2, (kScreenHeight-kNavigationBarHeight)/2-50);
    _indicatorView.bounds = CGRectMake(0, 0, 60, 60);
    _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    _indicatorView.backgroundColor = [UIColor grayColor];
    _indicatorView.layer.cornerRadius = 5;
    _indicatorView.layer.masksToBounds = YES;
    _indicatorView.alpha = 0.7;
    [_indicatorView startAnimating];
    
//    [self notify_downloadImages:imageUrlStr completeBlock:^(NSDictionary *dict) {
//        [weakSelf setupUI:dict.allValues];
//    }];
//    
    [self wait_downloadImages:imageUrlStr completeBlock:^(NSDictionary *responseDict) {
        [weakSelf setupUI:responseDict.allValues];
    }];
//
//    [self apply_downloadImages:imageUrlStr completeBlock:^(NSDictionary *responseDict) {
//        [weakSelf setupUI:responseDict.allValues];
//    }];
}

- (void)setupUI:(NSArray *)images {
    [_indicatorView stopAnimating];
    [_indicatorView removeFromSuperview];
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat height = 100;
    CGFloat width = kScreenWidth;
    for (int index = 0; index < images.count; index++) {
        UIImage *image = images[index];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        imageView.image = image;
        [self.view addSubview:imageView];
        y = imageView.maxY;
    }
}

/**
 * dispatch_group_enter(<#threadName#>) and dispatch_group_leave(<#threadName#>) 两个方法成对出现；
 * 标志着当前代码块加入 <#threadName#> 
 * void
 * dispatch_group_enter(dispatch_group_t group)
 *
 * dispatch_group_notify(dispatch_group_t group, dispatch_queue_t queue, dispatch_block_t block)() 以异步的方式工作，
 * 当 group 中的任务结束的时候，执行block()中代码
 */
- (void)notify_downloadImages:(NSArray *)imagesUrlStr completeBlock:(DWAsyncCompleteBlock)completeBlock {
    // 处理并发任务的建议使用这个方法
    __block NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    dispatch_group_t dispathGroup = dispatch_group_create();
    for (NSInteger index = 0; index<imagesUrlStr.count; index++) {
        dispatch_group_enter(dispathGroup); // 手动通知任务已经开始
        NSURL *url = [NSURL URLWithString:imagesUrlStr[index]];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageDownloaderIgnoreCachedResponse progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            mDict[@(index)] = image;
            dispatch_group_leave(dispathGroup);  // 手动通知任务已经结束
        }];
    }
    dispatch_group_notify(dispathGroup, dispatch_get_main_queue(), ^{
        NSLog(@"dispatch group notify download success image count %ld",mDict.allValues.count);
        if (completeBlock) {
            completeBlock(mDict);
        }
    });
}

- (void)wait_downloadImages:(NSArray *)imagesUrlStr completeBlock:(DWAsyncCompleteBlock)completeBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        __block NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        dispatch_group_t dispathGroup = dispatch_group_create();
        for (NSInteger index = 0; index<imagesUrlStr.count; index++) {
            dispatch_group_enter(dispathGroup);
            NSURL *url = [NSURL URLWithString:imagesUrlStr[index]];
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageDownloaderIgnoreCachedResponse progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                mDict[@(index)] = image;
                dispatch_group_leave(dispathGroup);
            }];
        }
        // 阻塞当前线程，直到任务完成
        dispatch_group_wait(dispathGroup, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"dispath group wait download success image count %ld",mDict.allValues.count);
            if (completeBlock) {
                completeBlock(mDict);
            }
        });
    });
}

/*
 * 使用应考虑创建并行线程的开销，如果不是很长迭代的集合的话，应该使用for 循环比较合适。
 */
- (void)apply_downloadImages:(NSArray *)imagesUrlStr completeBlock:(DWAsyncCompleteBlock)completeBlock {
    __block NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    dispatch_group_t dispathGroup = dispatch_group_create();
    dispatch_apply(imagesUrlStr.count, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(size_t i) {
        dispatch_group_enter(dispathGroup); // 手动通知任务已经开始
        NSURL *url = [NSURL URLWithString:imagesUrlStr[i]];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageDownloaderIgnoreCachedResponse progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            mDict[@(i)] = image;
            dispatch_group_leave(dispathGroup);  // 手动通知任务已经结束
        }];
    });
    dispatch_group_notify(dispathGroup, dispatch_get_main_queue(), ^{
        NSLog(@"dispatch group notify download success image count %ld",mDict.allValues.count);
        if (completeBlock) {
            completeBlock(mDict);
        }
    });
}

@end
