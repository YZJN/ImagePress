//
//  ImageCompressTool.m
//  RepresentaitionDemo
//
//  Created by QITMAC000904 on 2021/1/5.
//

#import "ImageCompressTool.h"
#import <Accelerate/Accelerate.h>
@implementation ImageCompressTool
+(UIImage *)ResizeImageWithImage:(UIImage *)OldImage
                         andSize:(CGSize)Size
                           Scale:(BOOL)Scale
{
    UIGraphicsBeginImageContextWithOptions(Size, NO, 0.0);
    
    CGRect rect = CGRectMake(0,
                             0,
                             Size.width,
                             Size.height);
    if (!Scale) {
        
        CGFloat bili_imageWH = OldImage.size.width/
                               OldImage.size.height;
        CGFloat bili_SizeWH  = Size.width/Size.height;
        
        if (bili_imageWH > bili_SizeWH) {
            
            CGFloat bili_SizeH_imageH = Size.height/
                                        OldImage.size.height;
            CGFloat height = OldImage.size.height*
                             bili_SizeH_imageH;
            CGFloat width = height * bili_imageWH;
            CGFloat x = -(width - Size.width)/2;
            CGFloat y = 0;
            rect = CGRectMake(x,y,
                              width,
                              height);
            
        }else{
            
            CGFloat bili_SizeW_imageW = Size.width/
                                        OldImage.size.width;
            CGFloat width = OldImage.size.width *
                            bili_SizeW_imageW;
            CGFloat height = width / bili_imageWH;
            CGFloat x = 0;
            CGFloat y = -(height - Size.height)/2;
            rect = CGRectMake(x,y,
                              width,
                              height);
        }
    }
    
    [[UIColor clearColor] set];
    UIRectFill(rect);
    
    [OldImage drawInRect:rect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}
/**
 Core Graphics
 */
+ (UIImage *)ResizedImageWithUr:(NSURL *)url size:(CGSize)size {
   
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)url, nil);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, nil);
    if (imageRef) {
        CGContextRef context = CGBitmapContextCreate(
                                                    nil,
                                                    (int)size.width,
                                                    (int)size.height,
                                                    CGImageGetBitsPerComponent(imageRef),
                                                    CGImageGetBytesPerRow(imageRef),
                                                    CGImageGetColorSpace(imageRef),
                                                    CGImageGetBitmapInfo(imageRef));
        CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), imageRef);
        CGImageRef resultImage = CGBitmapContextCreateImage(context);
        return [UIImage imageWithCGImage:resultImage];
        
    }
    return nil;
}

/**
 Core Graphics
 */
+ (UIImage *)ResizedImageWithImage:(UIImage *)image size:(CGSize)size {
    

    CGImageRef imageRef = image.CGImage;
    if (imageRef) {
        CGContextRef context = CGBitmapContextCreate(
                                                    nil,
                                                    (int)size.width,
                                                    (int)size.height,
                                                    CGImageGetBitsPerComponent(imageRef),
                                                    CGImageGetBytesPerRow(imageRef),
                                                    CGImageGetColorSpace(imageRef),
                                                    CGImageGetBitmapInfo(imageRef));
        CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), imageRef);
        CGImageRef resultImage = CGBitmapContextCreateImage(context);
        return [UIImage imageWithCGImage:resultImage];
        
    }
    return nil;
}

/**
利用Image i/o
@param data 图片data
@param size UIImageView尺寸
@param scale 压缩比 0-1放大 拉伸 =1 原图，<1 压缩 //s饰演的结果是这个参数，并不能改变图片的大小
@param orientation 方向 //这个参数可以方便我们对图片作出旋转比如上-》下，镜像；
@return 缩略图
*/
+ (UIImage *)SeacalImageWithData:(NSData *)data withSize:(CGSize)size scale:(CGFloat)scale orientation:(UIImageOrientation)orientation{
CGFloat maxPixeSize = MAX(size.width, size.height);
//读取图像源
CGImageSourceRef sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)data, nil);
NSDictionary *options = @{(__bridge id)kCGImageSourceCreateThumbnailFromImageAlways:(__bridge id)kCFBooleanTrue,(__bridge id)kCGImageSourceThumbnailMaxPixelSize:[NSNumber numberWithFloat:maxPixeSize]};
//创建缩略图，根据字典
/*
options中的
kCGImageSourceThumbnailMaxPixelSize 指定缩略图的最大宽度和高度(以像素为单位)。如果此键未指定，缩略图的宽度和高度为不受限制，缩略图可能和图片本身一样大。如果指定，此键的值必须是CFNumberRef。* /
kCGImageSourceCreateThumbnailFromImageAlways *如果图像源文件中存在缩略图。缩略图将由完整图像创建，受kCGImageSourceThumbnailMaxPixelSize——如果没有最大像素大小指定，则缩略图将为完整图像的大小，可能不是你想要的。这个键的值必须是CFBooleanRef;这个键的默认值是kCFBooleanFalse。
*/
CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(sourceRef, 0, (__bridge CFDictionaryRef)options);
UIImage *resultImage = [UIImage imageWithCGImage:imageRef scale:scale orientation:orientation];
return resultImage;
}

/**
    滤镜处理方式CoreImage
 */
+ (UIImage*)CoreImageChangeImageWithImage:(UIImage *)image size:(CGSize)size scale:(CGFloat)scale{
    CIImage *ciImage = [[CIImage alloc]initWithCGImage:image.CGImage];
    NSDictionary *dict = @{kCIInputScaleKey:@(scale),kCIInputAspectRatioKey:@(1.),kCIInputImageKey:ciImage};
    CIFilter *filter = [CIFilter filterWithName:@"CILanczosScaleTransform" withInputParameters:dict];
    CIContext *ciContext = [[CIContext alloc] initWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CGImageRef ciImageRef = [ciContext createCGImage:filter.outputImage fromRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = [UIImage imageWithCGImage:ciImageRef];
    return newImage;
}


+ (UIImage*)AccelerateChangeImage:(UIImage *)image size:(CGSize)size{
    const size_t width = size.width, height = size.height;
    const size_t bytesPerRow = width * 4;
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, space, bitmapInfo);
    CGColorSpaceRelease(space);
    if (!bmContext) return nil;
    CGContextDrawImage(bmContext, CGRectMake(0, 0, width, height), image.CGImage);
    UInt8 * data = (UInt8*)CGBitmapContextGetData(bmContext);
    if (!data){
        CGContextRelease(bmContext);
        return nil;
    }
    CGImageRef imageRef = CGBitmapContextCreateImage(bmContext);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGContextRelease(bmContext);
    return newImage;
}

@end
