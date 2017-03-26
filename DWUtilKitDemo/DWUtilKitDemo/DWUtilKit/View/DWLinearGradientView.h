//
//  DWLinearGradientView.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/9.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DWLinerGradientViewAxis) {
    DWLinerGradientViewAxisX,  // 沿x轴
    DWLinerGradientViewAxisY,  // 沿y轴
};

@interface DWLinearGradientView : UIView

- (id)initWithFrame:(CGRect)frame colors:(NSArray *)colors axis:(DWLinerGradientViewAxis)axis;

@end
