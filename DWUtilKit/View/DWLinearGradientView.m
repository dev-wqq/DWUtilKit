//
//  DWLinearGradientView.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/9.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DWLinearGradientView.h"

@implementation DWLinearGradientView {
    DWLinerGradientViewAxis axis;
    CGGradientRef gradient;
}

- (id)initWithFrame:(CGRect)frame colors:(NSArray *)colors axis:(DWLinerGradientViewAxis)ppaxis {
    self = [super initWithFrame:frame];
    if (self) {
        axis = ppaxis;
        NSAssert([colors count] > 1, @"at least two colors");
        CGColorSpaceRef myColorspace;
        size_t num_locations = (size_t)colors.count;
        CGFloat *locations = (CGFloat *)malloc(sizeof(CGFloat) * num_locations);
        CGFloat *components = (CGFloat *)malloc(sizeof(CGFloat) * 4 * num_locations);
        for (NSUInteger i = 0; i < colors.count; ++i) {
            if (i == 0) {
                *(locations+i) = 0;
            } else {
                *(locations+i) = *(locations+i-1) + 1.0/(num_locations-1);
            }
            CGFloat *pos = components + 4 * i;
            UIColor *color = colors[i];
            BOOL res = [color getRed:pos green:pos+1 blue:pos+2 alpha:pos+3];
            NSAssert(res, @"fetch color from UIColor error");
        }
        myColorspace = CGColorSpaceCreateDeviceRGB();
        gradient = CGGradientCreateWithColorComponents (myColorspace, components, locations, num_locations);
        CGColorSpaceRelease(myColorspace);
        free(locations);
        free(components);
    }
    return self;
}

- (void)dealloc {
    if (gradient) {
        CGGradientRelease(gradient);
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (!gradient) {
        return;
    }
    CGSize size = self.bounds.size;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint startPoint = CGPointMake(0.0, 0.0);
    CGPoint endPoint = CGPointMake(0.0, size.height);
    if (axis == DWLinerGradientViewAxisX) {
        endPoint = CGPointMake(size.width, 0.0);
    } else {
        endPoint = CGPointMake(0.0, size.height);
    }
    CGContextDrawLinearGradient (context, gradient, startPoint, endPoint, 0);
}

@end
