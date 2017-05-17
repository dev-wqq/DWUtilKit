//
//  DWProgressViewController.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/5/16.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DWProgressViewController.h"

@interface DWProgressViewController ()

@property (nonatomic, strong) NSProgress *progress;

@end

@implementation DWProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initView];
}

- (void)initView {
    self.title = @"NSProgress";
    
    _progress = [NSProgress progressWithTotalUnitCount:60];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doTimer:) userInfo:nil repeats:YES];
    [_progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)doTimer:(id)sender {
    if (_progress.completedUnitCount < _progress.totalUnitCount) {
        _progress.completedUnitCount += 1;
    } else {
        
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%lld",_progress.completedUnitCount);
}



@end
