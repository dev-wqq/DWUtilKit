//
//  DWDramImageViewController.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/8/29.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DWDramImageViewController.h"

@interface DWDramImageViewController ()

@property (nonatomic, strong) UIImageView *imageViewOriginal;
@property (nonatomic, strong) UIImageView *imageViewDraw;

@end

@implementation DWDramImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    _imageViewOriginal = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"draw_test"]];
    [self.view addSubview:_imageViewOriginal];
    _imageViewOriginal.origin = CGPointMake(ceil(XCenterInContainer(_imageViewOriginal.image.size.width, kScreenWidth)), 40);
    _imageViewOriginal.backgroundColor = [UIColor whiteColor];
    
    _imageViewDraw = [[UIImageView alloc] initWithFrame:CGRectMake(XCenterInContainer(150, kScreenWidth), _imageViewOriginal.maxY + 50, 150, 130)];
    [self.view addSubview:_imageViewDraw];
    _imageViewDraw.image = [self graphicsImage:[UIImage imageNamed:@"draw_test"] size:_imageViewDraw.size];
}

/**
 图像的性能优化
 Color Blended Layers(混合图层->检测图像的混合模式)
 Color Misaligned Images(拉伸图像->检测图片有没有被拉伸)
 */
- (UIImage *)graphicsImage:(UIImage *)image size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    CGRect rect = [UIView dw_frameOfContentWithContentSize:image.size containerSize:size contentMode:UIViewContentModeScaleAspectFit];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [path addClip];
    
    [image drawInRect:rect];
    
    [[UIColor redColor] setStroke];
    [path setLineWidth:5];
    [path stroke];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
    
}


@end
