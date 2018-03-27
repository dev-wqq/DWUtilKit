//
//  DWAlgorithmViewController.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2018/3/27.
//  Copyright © 2018年 duxing. All rights reserved.
//

#import "DWAlgorithmViewController.h"

@interface DWAlgorithmViewController ()

@end

@implementation DWAlgorithmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *arr = @[@"9",@"3",@"1",@"2",@"6",@"4"];
    
    NSArray *tempArr = [self bubbleSortWithArr:arr];
    NSLog(@"bubble sort:\n%@->%@",arr,tempArr);
    
    tempArr = [self quickSortWithArr:arr];
    NSLog(@"quick sort:\n%@->%@",arr,tempArr);
}

#pragma mark - 冒泡排序
// http://www.cnblogs.com/melon-h/archive/2012/09/20/2694941.html
- (NSArray *)bubbleSortWithArr:(NSArray *)sortArr {
    if (sortArr.count <= 1) return sortArr;
    NSMutableArray *tempArr = sortArr.mutableCopy;
    for (int i = 0; i < tempArr.count; i++) {
        BOOL didSwap = NO;
        for (int j = 0; j < tempArr.count-i-1; j++) {
            NSString *ai = (NSString *)tempArr[j];
            NSString *aj = (NSString *)tempArr[j+1];
            if (ai.doubleValue > aj.doubleValue) {
                [tempArr exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                didSwap = YES;
            }
        }
        if (!didSwap) {
            return tempArr;
        }
    }
    return tempArr;
}

#pragma mark - 快速排序
- (NSArray *)quickSortWithArr:(NSArray *)sortArr {
    if (sortArr.count <= 1) return sortArr;
    
    NSMutableArray *mSortArr = sortArr.mutableCopy;
    [self quickSortWithArr:mSortArr left:0 right:mSortArr.count-1];
    return mSortArr;
}

- (void)quickSortWithArr:(NSMutableArray *)mSortArr
                    left:(NSInteger)left
                   right:(NSInteger)right {
    // 如果数组长度为0
    if (mSortArr.count <= 1) return;
    // 健壮性的处理
    if (left >= right || left >= mSortArr.count || right >= mSortArr.count) {
        return;
    }
    NSInteger i = left;
    NSInteger j = right;
    
    // 设置成为基数
    NSInteger pivot = [mSortArr[i] integerValue];
    
    while (i != j) {
        // 如果比基数大继续查找
        while (i < j && pivot <= [mSortArr[j] integerValue]) {
            j--;
        }
        
        // 如果比基数小继续查找
        while (i < j && pivot >= [mSortArr[i] integerValue]) {
            i++;
        }
        
        if (i < j) {
            [mSortArr exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
    }
    
    // 将基数放在正确的位置
    if (i != left) {
        [mSortArr exchangeObjectAtIndex:left withObjectAtIndex:i];
    }
    
    [self quickSortWithArr:mSortArr left:left right:i-1];
    [self quickSortWithArr:mSortArr left:i+1 right:right];
}


@end
