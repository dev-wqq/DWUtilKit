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
    
    NSArray *binary = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    NSString *key = @"7";
    NSInteger index = [self binarySearch1:binary key:key];
    NSLog(@"binary search method 1 index:%ld",index);
    
    index = [self binarySearch2:binary low:0 high:binary.count-1 key:key];
    NSLog(@"binary search method 2 index:%ld",index);
    
    key = @"20";
    index = [self binarySearch1:binary key:key];
    NSLog(@"binary search method 1 index:%ld",index);
    
    index = [self binarySearch2:binary low:0 high:binary.count-1 key:key];
    NSLog(@"binary search method 2 index:%ld",index);
    
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

#pragma mark - 二分查找

// 非递归二分查找
- (NSInteger)binarySearch1:(NSArray<NSString *> *)sortArr key:(NSString *)key {
    NSInteger low   = 0;
    NSInteger hight = sortArr.count - 1;
    NSInteger middle = 0;
    while (low <= hight && low < sortArr.count && hight < sortArr.count) {
        middle = (low + hight)/2;
        NSString *temp = sortArr[middle];
        if (temp.integerValue > key.integerValue) {
            hight = middle - 1;
        } else if (temp.integerValue < key.integerValue) {
            low = middle + 1;
        } else {
            return middle;
        }
    }
    return -1;
}

// 递归二分查找
- (NSInteger)binarySearch2:(NSArray<NSString *> *)sortArr
                       low:(NSInteger)low
                      high:(NSInteger)high
                       key:(NSString *)key {
    if (sortArr.count == 0) {
        return -1;
    }
    if (low >= sortArr.count || high >= sortArr.count || low > high) {
        return -1;
    }
    
    NSInteger middle = (low + high)/2;
    NSString *temp = sortArr[middle];
    if (temp.integerValue > key.integerValue) {
        return [self binarySearch2:sortArr low:low high:middle-1 key:key];
    } else if (temp.integerValue < key.integerValue) {
        return [self binarySearch2:sortArr low:middle+1 high:high key:key];
    } else {
        return middle;
    }
}

#pragma mark - 链表反转

@end
