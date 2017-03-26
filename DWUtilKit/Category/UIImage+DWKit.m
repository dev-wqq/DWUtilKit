//
//  UIImage+DWKit.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/21.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "UIImage+DWKit.h"
#import "UIView+DWKit.h"
#import <Accelerate/Accelerate.h>
#import "DWUtilities.h"

#ifndef DW_SWAP // swap two value
#define DW_SWAP(_a_, _b_)  do { __typeof__(_a_) _tmp_ = (_a_); (_a_) = (_b_); (_b_) = _tmp_; } while (0)
#endif

@implementation UIImage (DWKit)

+ (UIImage *)dw_imageWithColor:(UIColor *)color size:(CGSize)size {
    if (size.width == 0 || size.height == 0) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [color setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)dw_imageWithColor:(UIColor *)color size:(CGSize)size borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)radius {
    if (size.width == 0 || size.height == 0) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [color setFill];
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(borderWidth/2, borderWidth/2, borderWidth/2, borderWidth/2));
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:radius];
    [path setLineWidth:borderWidth];
    [borderColor setStroke];
    [path fill];
    [path stroke];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)dw_imageWithColor:(UIColor *)color size:(CGSize)size lineWidth:(CGFloat)lineWidth dashLineColor:(UIColor *)dashLineColor cornerRadius:(CGFloat)radius {
    if (size.width == 0 || size.height == 0) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [color setFill];
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(lineWidth/2, lineWidth/2, lineWidth/2, lineWidth/2));
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:radius];
    CGFloat dash[2] = {2, 2};
    [path setLineDash:dash count:2 phase:2];
    [path setLineWidth:lineWidth];
    [path setLineCapStyle:kCGLineCapRound];
    [dashLineColor setStroke];
    [path fill];
    [path stroke];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)dw_resizeImage:(UIImage *)image contentMode:(UIViewContentMode)contentMode size:(CGSize)size {
    if (size.width == 0 || size.height == 0) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGRect frame = [UIView dw_frameOfContentWithContentSize:image.size containerSize:size contentMode:contentMode];
    [image drawInRect:frame];
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resImage;
}

+ (UIImage *)dw_gradientImageWithSize:(CGSize)size colors:(NSArray *)colors axisX:(BOOL)axisX {
    if (size.width == 0 || size.height == 0) {
        return nil;
    }
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
    CGGradientRef gradient = CGGradientCreateWithColorComponents (myColorspace, components, locations, num_locations);
    CGColorSpaceRelease(myColorspace);
    free(locations);
    free(components);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint startPoint = CGPointMake(0.0, 0.0);
    CGPoint endPoint = CGPointMake(0.0, size.height);
    if (axisX) {
        endPoint = CGPointMake(size.width, 0.0);
    } else {
        endPoint = CGPointMake(0.0, size.height);
    }
    CGContextDrawLinearGradient (context, gradient, startPoint, endPoint, 0);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGGradientRelease(gradient);
    return image;
}

+ (UIImage *)dw_imageWithQRCodeString:(NSString *)qrCodeString size:(CGSize)size {
    if (size.width == 0 || size.height == 0) {
        return nil;
    }
    NSData *stringData = [qrCodeString dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *ciImage = qrFilter.outputImage;
    // Render the CIImage into a CGImage
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:ciImage fromRect:ciImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // We don't want to interpolate (since we've got a pixel-correct image)
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    return scaledImage;
}

+ (UIImage *)dw_imageWithSize:(CGSize)size drawBlock:(void (^)(CGContextRef contextRef))drawBlock {
    if (size.width == 0 || size.height == 0 || !drawBlock) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    if (!contextRef) {
        return nil;
    }
    drawBlock(contextRef);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (UIImage *)dw_imageWithSize:(CGSize)size cornerRadius:(CGFloat)radius {
    return [self dw_imageWithSize:size cornerRadius:radius contentMode:UIViewContentModeScaleToFill];
}

- (UIImage *)dw_imageWithSize:(CGSize)size cornerRadius:(CGFloat)radius contentMode:(UIViewContentMode)contentMode {
    return [self dw_imageWithSize:size cornerRadius:radius contentMode:contentMode borderWidth:0 borderColor:nil];
}

- (UIImage *)dw_imageWithSize:(CGSize)size cornerRadius:(CGFloat)radius contentMode:(UIViewContentMode)contentMode borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    if (size.width == 0 || size.height == 0) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:radius];
    [path addClip];

    CGRect frame = [UIView dw_frameOfContentWithContentSize:self.size containerSize:size contentMode:contentMode];
    [self drawInRect:frame];
    
    if (borderColor && borderWidth > 0) {
        path.lineWidth = borderWidth*2;
        [borderColor set];
        [path stroke];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 http://stackoverflow.com/questions/3745126/must-i-multiply-the-scale-with-the-point-values-for-retina-display-in-this-case
 CGImageGetWidth([image CGImage]) == image.size.width * image.scale
 CGImageGetHeight([image CGImage]) == image.size.height * image.scale
 */
- (UIImage *)dw_imageWithRotate:(CGFloat)radians fitSize:(BOOL)fitSize {
    size_t width = (size_t)CGImageGetWidth(self.CGImage);
    size_t height = (size_t)CGImageGetHeight(self.CGImage);
    CGRect newRect = CGRectApplyAffineTransform(CGRectMake(0., 0., width, height),
                                                fitSize ? CGAffineTransformMakeRotation(radians) : CGAffineTransformIdentity);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 (size_t)newRect.size.width,
                                                 (size_t)newRect.size.height,
                                                 8,
                                                 (size_t)newRect.size.width * 4,
                                                 colorSpace,
                                                 kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    if (!context) return nil;
    
    CGContextSetShouldAntialias(context, true);
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    CGContextTranslateCTM(context, +(newRect.size.width * 0.5), +(newRect.size.height * 0.5));
    CGContextRotateCTM(context, radians);
    
    CGContextDrawImage(context, CGRectMake(-(width * 0.5), -(height * 0.5), width, height), self.CGImage);
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imgRef);
    CGContextRelease(context);
    return img;
}

- (UIImage *)dw_imageWithRotateLeft90 {
    return [self dw_imageWithRotate:DWDegreesToRadians(90) fitSize:YES];
}

- (UIImage *)dw_imageWithRotateRight90 {
    return [self dw_imageWithRotate:DWDegreesToRadians(-90) fitSize:YES];
}

- (UIImage *)dw_imageWithRotate180 {
    return [self dw_imageWithRotate:DWDegreesToRadians(180) fitSize:NO];
}

- (UIImage *)_dw_flipHorizontal:(BOOL)horizontal vertical:(BOOL)vertical {
    if (!self.CGImage) return nil;
    size_t width = (size_t)CGImageGetWidth(self.CGImage);
    size_t height = (size_t)CGImageGetHeight(self.CGImage);
    size_t bytesPerRow = width * 4;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    if (!context) return nil;
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage);
    UInt8 *data = (UInt8 *)CGBitmapContextGetData(context);
    if (!data) {
        CGContextRelease(context);
        return nil;
    }
    vImage_Buffer src = { data, height, width, bytesPerRow };
    vImage_Buffer dest = { data, height, width, bytesPerRow };
    if (vertical) {
        vImageVerticalReflect_ARGB8888(&src, &dest, kvImageBackgroundColorFill);
    }
    if (horizontal) {
        vImageHorizontalReflect_ARGB8888(&src, &dest, kvImageBackgroundColorFill);
    }
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imgRef);
    return img;
}

- (UIImage *)dw_imageWithFlitVertical {
    return [self _dw_flipHorizontal:NO vertical:YES];
}

- (UIImage *)dw_imageWithFlitHorizontal {
    return [self _dw_flipHorizontal:YES vertical:NO];
}

#pragma mark - image effects

- (UIImage *)dw_imageWithTintColor:(UIColor *)tintColor {
    return [self dw_imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *)dw_imageWithGradientTintColor:(UIColor *)tintColor {
    return [self dw_imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *)dw_imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode {
    // https://onevcat.com/2013/04/using-blending-in-ios/
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    [tintColor set];
    CGRect frame = CGRectMake(0, 0, self.size.width, self.size.height);
    // fills the specified rectangle(矩形) with the current color.
    UIRectFill(frame);
    [self drawInRect:frame blendMode:blendMode alpha:1];
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:frame blendMode:kCGBlendModeDestinationIn alpha:1];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)dw_imageWithGrayscale {
    return [self dw_imageWithBlurRadius:0 tintColor:nil tintMode:0 saturation:0 maskImage:nil];
}

- (UIImage *)dw_imageWithBlurSoft {
    return [self dw_imageWithBlurRadius:60 tintColor:[UIColor colorWithWhite:0.84 alpha:0.36] tintMode:kCGBlendModeNormal saturation:1.8 maskImage:nil];
}

- (UIImage *)dw_imageWithBlurLight {
    return [self dw_imageWithBlurRadius:60 tintColor:[UIColor colorWithWhite:1.0 alpha:0.3] tintMode:kCGBlendModeNormal saturation:1.8 maskImage:nil];
}

- (UIImage *)dw_imageWithBlurExtraLight {
    return [self dw_imageWithBlurRadius:40 tintColor:[UIColor colorWithWhite:0.97 alpha:0.82] tintMode:kCGBlendModeNormal saturation:1.8 maskImage:nil];
}

- (UIImage *)imageWithBlurDark {
    return [self dw_imageWithBlurRadius:40 tintColor:[UIColor colorWithWhite:0.11 alpha:0.73] tintMode:kCGBlendModeNormal saturation:1.8 maskImage:nil];
}

- (UIImage *)dw_imageWithBlurTintColor:(UIColor *)tintColor {
    const CGFloat EffectColorAlpha = 0.6;
    UIColor *effectColor = tintColor;
    size_t componentCount = CGColorGetNumberOfComponents(tintColor.CGColor);
    if (componentCount == 2) {
        CGFloat b;
        if ([tintColor getWhite:&b alpha:NULL]) {
            effectColor = [UIColor colorWithWhite:b alpha:EffectColorAlpha];
        }
    } else {
        CGFloat r, g, b;
        if ([tintColor getRed:&r green:&g blue:&b alpha:NULL]) {
            effectColor = [UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
        }
    }
    return [self dw_imageWithBlurRadius:20 tintColor:effectColor tintMode:kCGBlendModeNormal saturation:-1.0 maskImage:nil];
}

- (UIImage *)dw_imageWithBlurRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor tintMode:(CGBlendMode)tintBlendMode saturation:(CGFloat)saturation maskImage:(UIImage *)maskImage {
    if (self.size.width < 1 || self.size.height < 1) {
        NSLog(@"UIImage+DWKit error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage) {
        NSLog(@"UIImage+DWKit error: inputImage must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        NSLog(@"UIImage+DWKit error: effectMaskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    
    // iOS7 and above can use new func.
    BOOL hasNewFunc = (long)vImageBuffer_InitWithCGImage != 0 && (long)vImageCreateCGImageFromBuffer != 0;
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturation = fabs(saturation - 1.0) > __FLT_EPSILON__;
    
    CGSize size = self.size;
    CGRect rect = { CGPointZero, size };
    CGFloat scale = self.scale;
    CGImageRef imageRef = self.CGImage;
    BOOL opaque = NO;
    
    if (!hasBlur && !hasSaturation) {
        return [self _dw_mergeImageRef:imageRef tintColor:tintColor tintBlendMode:tintBlendMode maskImage:maskImage opaque:opaque];
    }
    
    vImage_Buffer effect = { 0 }, scratch = { 0 };
    vImage_Buffer *input = NULL, *output = NULL;
    
    vImage_CGImageFormat format = {
        .bitsPerComponent = 8,
        .bitsPerPixel = 32,
        .colorSpace = NULL,
        .bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little, //requests a BGRA buffer.
        .version = 0,
        .decode = NULL,
        .renderingIntent = kCGRenderingIntentDefault
    };
    
    if (hasNewFunc) {
        vImage_Error err;
        err = vImageBuffer_InitWithCGImage(&effect, &format, NULL, imageRef, kvImagePrintDiagnosticsToConsole);
        if (err != kvImageNoError) {
            NSLog(@"UIImage+DWKit error: vImageBuffer_InitWithCGImage returned error code %zi for inputImage: %@", err, self);
            return nil;
        }
        err = vImageBuffer_Init(&scratch, effect.height, effect.width, format.bitsPerPixel, kvImageNoFlags);
        if (err != kvImageNoError) {
            NSLog(@"UIImage+DWKit error: vImageBuffer_Init returned error code %zi for inputImage: %@", err, self);
            return nil;
        }
    } else {
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
        CGContextRef effectCtx = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectCtx, 1.0, -1.0);
        CGContextTranslateCTM(effectCtx, 0, -size.height);
        CGContextDrawImage(effectCtx, rect, imageRef);
        effect.data     = CGBitmapContextGetData(effectCtx);
        effect.width    = CGBitmapContextGetWidth(effectCtx);
        effect.height   = CGBitmapContextGetHeight(effectCtx);
        effect.rowBytes = CGBitmapContextGetBytesPerRow(effectCtx);
        
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
        CGContextRef scratchCtx = UIGraphicsGetCurrentContext();
        scratch.data     = CGBitmapContextGetData(scratchCtx);
        scratch.width    = CGBitmapContextGetWidth(scratchCtx);
        scratch.height   = CGBitmapContextGetHeight(scratchCtx);
        scratch.rowBytes = CGBitmapContextGetBytesPerRow(scratchCtx);
    }
    
    input = &effect;
    output = &scratch;
    
    if (hasBlur) {
        // A description of how to compute the box kernel width from the Gaussian
        // radius (aka standard deviation) appears in the SVG spec:
        // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
        //
        // For larger values of 's' (s >= 2.0), an approximation can be used: Three
        // successive box-blurs build a piece-wise quadratic convolution kernel, which
        // approximates the Gaussian kernel to within roughly 3%.
        //
        // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
        //
        // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
        //
        CGFloat inputRadius = blurRadius * scale;
        if (inputRadius - 2.0 < __FLT_EPSILON__) inputRadius = 2.0;
        uint32_t radius = floor((inputRadius * 3.0 * sqrt(2 * M_PI) / 4 + 0.5) / 2);
        radius |= 1; // force radius to be odd so that the three box-blur methodology works.
        int iterations;
        if (blurRadius * scale < 0.5) iterations = 1;
        else if (blurRadius * scale < 1.5) iterations = 2;
        else iterations = 3;
        NSInteger tempSize = vImageBoxConvolve_ARGB8888(input, output, NULL, 0, 0, radius, radius, NULL, kvImageGetTempBufferSize | kvImageEdgeExtend);
        void *temp = malloc(tempSize);
        for (int i = 0; i < iterations; i++) {
            vImageBoxConvolve_ARGB8888(input, output, temp, 0, 0, radius, radius, NULL, kvImageEdgeExtend);
            DW_SWAP(input, output);
        }
        free(temp);
    }
    
    
    if (hasSaturation) {
        // These values appear in the W3C Filter Effects spec:
        // https://dvcs.w3.org/hg/FXTF/raw-file/default/filters/Publish.html#grayscaleEquivalent
        CGFloat s = saturation;
        CGFloat matrixFloat[] = {
            0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
            0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
            0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
            0,                    0,                    0,                    1,
        };
        const int32_t divisor = 256;
        NSUInteger matrixSize = sizeof(matrixFloat) / sizeof(matrixFloat[0]);
        int16_t matrix[matrixSize];
        for (NSUInteger i = 0; i < matrixSize; ++i) {
            matrix[i] = (int16_t)roundf(matrixFloat[i] * divisor);
        }
        vImageMatrixMultiply_ARGB8888(input, output, matrix, divisor, NULL, NULL, kvImageNoFlags);
        DW_SWAP(input, output);
    }
    
    UIImage *outputImage = nil;
    if (hasNewFunc) {
        CGImageRef effectCGImage = NULL;
        effectCGImage = vImageCreateCGImageFromBuffer(input, &format, &_dw_cleanupBuffer, NULL, kvImageNoAllocate, NULL);
        if (effectCGImage == NULL) {
            effectCGImage = vImageCreateCGImageFromBuffer(input, &format, NULL, NULL, kvImageNoFlags, NULL);
            free(input->data);
        }
        free(output->data);
        outputImage = [self _dw_mergeImageRef:effectCGImage tintColor:tintColor tintBlendMode:tintBlendMode maskImage:maskImage opaque:opaque];
        CGImageRelease(effectCGImage);
    } else {
        CGImageRef effectCGImage;
        UIImage *effectImage;
        if (input != &effect) effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if (input == &effect) effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        effectCGImage = effectImage.CGImage;
        outputImage = [self _dw_mergeImageRef:effectCGImage tintColor:tintColor tintBlendMode:tintBlendMode maskImage:maskImage opaque:opaque];
    }
    return outputImage;
}

// Helper function to handle deferred cleanup of a buffer.
static void _dw_cleanupBuffer(void *userData, void *buf_data) {
    free(buf_data);
}

// Helper function to add tint and mask.
- (UIImage *)_dw_mergeImageRef:(CGImageRef)effectCGImage tintColor:(UIColor *)tintColor tintBlendMode:(CGBlendMode)tintBlendMode maskImage:(UIImage *)maskImage opaque:(BOOL)opaque {
    BOOL hasTint = tintColor != nil && CGColorGetAlpha(tintColor.CGColor) > __FLT_EPSILON__;
    BOOL hasMask = maskImage != nil;
    CGSize size = self.size;
    CGRect rect = { CGPointZero, size };
    CGFloat scale = self.scale;
    
    if (!hasTint && !hasMask) {
        return [UIImage imageWithCGImage:effectCGImage];
    }
    
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0, -size.height);
    if (hasMask) {
        CGContextDrawImage(context, rect, self.CGImage);
        CGContextSaveGState(context);
        CGContextClipToMask(context, rect, maskImage.CGImage);
    }
    CGContextDrawImage(context, rect, effectCGImage);
    if (hasTint) {
        CGContextSaveGState(context);
        CGContextSetBlendMode(context, tintBlendMode);
        CGContextSetFillColorWithColor(context, tintColor.CGColor);
        CGContextFillRect(context, rect);
        CGContextRestoreGState(context);
    }
    if (hasMask) {
        CGContextRestoreGState(context);
    }
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}

+ (NSInteger)dw_iOSOrientationToExifOrientation:(UIImageOrientation)imageOrientation {
    switch (imageOrientation) {
        case UIImageOrientationUp:
            return 1;
        case UIImageOrientationDown:
            return 3;
        case UIImageOrientationLeft:
            return 8;
        case UIImageOrientationRight:
            return 6;
        case UIImageOrientationUpMirrored:
            return 2;
        case UIImageOrientationDownMirrored:
            return 4;
        case UIImageOrientationLeftMirrored:
            return 5;
        case UIImageOrientationRightMirrored:
            return 7;
    }
    return -1;
}

+ (UIImageOrientation)dw_exifOrientationTagToiOSOrientation:(NSInteger)exifOrientationTag {
    switch (exifOrientationTag) {
        case 1:
            return UIImageOrientationUp;
        case 2:
            return UIImageOrientationUpMirrored;
        case 3:
            return UIImageOrientationDown;
        case 4:
            return UIImageOrientationDownMirrored;
        case 5:
            return UIImageOrientationLeftMirrored;
        case 6:
            return UIImageOrientationRight;
        case 7:
            return UIImageOrientationRightMirrored;
        case 8:
            return UIImageOrientationLeft;
    }
    return exifOrientationTag;
}

@end

@implementation UIImage (DWFixOrientation)

- (UIImage *)dw_fixOrientation {
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImage *)dw_fixOrientationMethod2 {
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

@end
