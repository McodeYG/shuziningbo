//
//  UIImage+CircleImage.h
//  JstyleNews
//
//  Created by 数字跃动 on 2017/12/18.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CircleImage)


/**
 裁剪图片为带圆环的圆形

 @param image 原始图片
 @param targetSize 目标尺寸(宽高最好相等)
 @return 裁剪后的圆形图片
 */
+ (UIImage *)scaleToCircleImageWithImage:(UIImage *)image targetSize:(CGSize)targetSize borderColor:(UIColor *)borderColor;



@end
