//
//  ImageShowVC.h
//  RepresentaitionDemo
//
//  Created by QITMAC000904 on 2021/1/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageShowVC : UIViewController
/**
 *  展示新图的IMGV
 */
@property(nonatomic, strong)UIImageView *newImgView;

/**
 *  新图片的尺寸，为了Demo效果更明显，将目标分辨率设大一些
 */
@property(nonatomic)CGSize newIMGSize;

/**
 *  原图，此原图挺大的
 */
@property(nonatomic,strong)UIImage *oldIMG;
@end

NS_ASSUME_NONNULL_END
