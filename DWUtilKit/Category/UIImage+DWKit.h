//
//  UIImage+DWKit.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/21.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DWKit)

/**
 *  @return image with color and size.
 *  if size.height or size.width is equal to zero return nil.
 */
+ (UIImage *)dw_imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  @return image with color、size、borderWidth、borderColor、radius. 
 *  if size.height or size.width is equal to zero return nil.
 */
+ (UIImage *)dw_imageWithColor:(UIColor *)color size:(CGSize)size borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)radius;

/**
 *  @return image with color、size、lineWidth、dashLineColor、radius.
 *  if size.height or size.width is equal to zero return nil.
 */
+ (UIImage *)dw_imageWithColor:(UIColor *)color size:(CGSize)size lineWidth:(CGFloat)lineWidth dashLineColor:(UIColor *)dashLineColor cornerRadius:(CGFloat)radius;

/**
 *  @return resize image with size and contentMode.
 *  if size.height or size.width is equal to zero return nil.
 */
+ (UIImage *)dw_resizeImage:(UIImage *)image contentMode:(UIViewContentMode)contentMode size:(CGSize)size;

/**
 *  @return a gradient image, at least two colors, through axisX to set the direction.
 *  if size.height or size.width is equal to zero return nil.
 */
+ (UIImage *)dw_gradientImageWithSize:(CGSize)size colors:(NSArray *)colors axisX:(BOOL)axisX;

/**
 *  @return a image with qr string.
 *  if size.height or size.width is equal to zero return nil.
 */
+ (UIImage *)dw_imageWithQRCodeString:(NSString *)qrCodeString size:(CGSize)size;

/**
 *  @return a image with custom draw code.
 *  if drawBlock not implementation or size.height or size.width is equal to zero return nil.
 */
+ (UIImage *)dw_imageWithSize:(CGSize)size drawBlock:(void (^)(CGContextRef contextRef))drawBlock;

/**
 *  @return a round corner image.
 *  if size.height or size.width is equal to zero return nil.
 */
- (UIImage *)dw_imageWithSize:(CGSize)size cornerRadius:(CGFloat)radius;
- (UIImage *)dw_imageWithSize:(CGSize)size cornerRadius:(CGFloat)radius contentMode:(UIViewContentMode)contentMode;
- (UIImage *)dw_imageWithSize:(CGSize)size cornerRadius:(CGFloat)radius contentMode:(UIViewContentMode)contentMode borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 @return a new rotated image (relative to the center).
 @param radians   Rotated radians in counterclockwise.⟲
 @param fitSize   YES: new image's size is extend to fit all content.
                  NO: image's size will not change, content may be clipped.
 */
- (UIImage *)dw_imageWithRotate:(CGFloat)radians fitSize:(BOOL)fitSize;

/**
 *  @return a new image rotated counterclockwise by a quarter‑turn (90°). ⤺
 *  The width and height will be exchanged.
 */
- (UIImage *)dw_imageWithRotateLeft90;

/**
 *  @return a new image rotated clockwise by a quarter‑turn (90°). ⤼
 *  The width and height will be exchanged.
 */
- (UIImage *)dw_imageWithRotateRight90;

/**
 *  @return a new image rotated 180°. ↻
 */
- (UIImage *)dw_imageWithRotate180;

/**
 *  @return a vertically flit image. ⥯
 */
- (UIImage *)dw_imageWithFlitVertical;

/**
 *  @return a horizontally flit image. ⇋
 */
- (UIImage *)dw_imageWithFlitHorizontal;

#pragma mark - image effects

/**
 *  @return tint the image, call dw_imageWithTintColor:blendMode: (blendMode is equal to kCGBlendModeDestinationIn 能保留透明度信息)
 */
- (UIImage *)dw_imageWithTintColor:(UIColor *)tintColor;

/**
 *  @return tint the image, call dw_imageWithTintColor:blendMode: (blendMode is equal to kCGBlendModeOverlay 能保留灰度信息)
 */
- (UIImage *)dw_imageWithGradientTintColor:(UIColor *)tintColor;

/**
 *  if blend is not equal to kCGBlendModeDestinationIn, will again draw blend is equal to kCGBlendModeDestinationIn (为了设置色彩颜色的时候，既能保留灰度，也能保留透明度)
    R表示结果，S表示包含alpha的原色，D表示包含alpha的目标色，Ra，Sa和Da分别是三个的alpha。
 */
- (UIImage *)dw_imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;

/**
 *  @return a grayscaled image
 */
- (UIImage *)dw_imageWithGrayscale;

/**
 Applies a blur effect to this image. Suitable for blur any content.
 */
- (UIImage *)dw_imageWithBlurSoft;

/**
 Applies a blur effect to this image. Suitable for blur any content except pure white.
 (same as iOS Control Panel)
 */
- (UIImage *)dw_imageWithBlurLight;

/**
 Applies a blur effect to this image. Suitable for displaying black text.
 (same as iOS Navigation Bar White)
 */
- (UIImage *)dw_imageWithBlurExtraLight;

/**
 Applies a blur effect to this image. Suitable for displaying white text.
 (same as iOS Notification Center)
 */
- (UIImage *)imageWithBlurDark;

/**
 Applies a blur and tint color to this image.
 
 @param tintColor The tint color.
 */
- (UIImage *)dw_imageWithBlurTintColor:(UIColor *)tintColor;

/**
 Applies a blur, tint color, and saturation adjustment to this image,
 optionally within the area specified by @a maskImage.
 
 @param blurRadius     The radius of the blur in points, 0 means no blur effect.
 
 @param tintColor      An optional UIColor object that is uniformly blended with
                       the result of the blur and saturation operations. The
                       alpha channel of this color determines how strong the
                       tint is. nil means no tint.
 
 @param tintBlendMode  The @a tintColor blend mode. Default is kCGBlendModeNormal (0).
 
 @param saturation     A value of 1.0 produces no change in the resulting image.
                       Values less than 1.0 will desaturation the resulting image
                       while values greater than 1.0 will have the opposite effect.
                       0 means gray scale.
 
 @param maskImage      If specified, @a inputImage is only modified in the area(s)
                       defined by this mask.  This must be an image mask or it
                       must meet the requirements of the mask parameter of
                       CGContextClipToMask.
 
 @return               image with effect, or nil if an error occurs (e.g. no
                       enough memory).
 */
- (UIImage *)dw_imageWithBlurRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor tintMode:(CGBlendMode)tintBlendMode saturation:(CGFloat)saturation maskImage:(UIImage *)maskImage;

#pragma mark - exif orientation tag

/**
   1        2       3      4         5           6           7            8
 888888  888888      88  88      8888888888  88                  88  8888888888
 88          88      88  88      88  88      88  88          88  88      88  88
 8888      8888    8888  8888    88          8888888888  8888888888          88
 88          88      88  88
 88          88  888888  888888
 1、up  2、upMirrored 3、down 4、downMirrored 5、leftMirrored 6、right 7、rightMirrored 8、left
 reference: http://sylvana.net/jpegcrop/exif_orientation.html  mirrored(镜像)
 */
+ (NSInteger)dw_iOSOrientationToExifOrientation:(UIImageOrientation)imageOrientation;
+ (UIImageOrientation)dw_exifOrientationTagToiOSOrientation:(NSInteger)exifOrientationTag;

@end


@interface UIImage (DWFixOrientation)

/**
 http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
 http://stackoverflow.com/questions/7838699/save-uiimage-load-it-in-wrong-orientation/10632187#10632187
 orientation保存在图片的metadata中
 因为PNG并没有orientation的信息，或者上传的图片可能丢失了orientation的信息，这里的两个方法都将图片转换成了UIImageOrientationUp
 所以即使丢失了信息，UIImageOrientationUp也是默认的展示方式，不会出现显示问题
 */
- (UIImage *)dw_fixOrientation;
- (UIImage *)dw_fixOrientationMethod2;

@end


