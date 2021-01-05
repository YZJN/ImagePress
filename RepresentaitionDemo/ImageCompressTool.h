//
//  ImageCompressTool.h
//  RepresentaitionDemo
//
//  Created by QITMAC000904 on 2021/1/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
NS_ASSUME_NONNULL_BEGIN

@interface ImageCompressTool : NSObject
/**
 //------只缩不压
//优点：可以大幅降低容量大小
//缺点：影响清晰度
//若Scale为YES，则原图会根据Size进行拉伸-会变形
//若Scale为NO，则原图会根据Size进行填充-不会变形
 */
+(UIImage *)ResizeImageWithImage:(UIImage *)OldImage
                         andSize:(CGSize)Size
                           Scale:(BOOL)Scale;


/**
 Core Graphics
 */
+ (UIImage *)ResizedImageWithUr:(NSURL *)url size:(CGSize)size;
+ (UIImage *)ResizedImageWithImage:(UIImage *)image size:(CGSize)size;
/**
利用Image i/o
@param data 图片data
@param size UIImageView尺寸
@param scale 压缩比 0-1放大 拉伸 =1 原图，<1 压缩 //s饰演的结果是这个参数，并不能改变图片的大小
@param orientation 方向 //这个参数可以方便我们对图片作出旋转比如上-》下，镜像；
@return 缩略图
*/
+ (UIImage *)SeacalImageWithData:(NSData *)data withSize:(CGSize)size scale:(CGFloat)scale orientation:(UIImageOrientation)orientation;

/**
 滤镜处理方式
 */
+ (UIImage*)CoreImageChangeImageWithImage:(UIImage *)image size:(CGSize)size scale:(CGFloat)scale;

/** vImage*/
+ (UIImage*)AccelerateChangeImage:(UIImage *)image size:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
