//
//  UIImage+GaoSiImage.h
//  Exquisite
//
//  Created by 数字宁波 on 16/5/3.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GaoSiImage)
/**毛玻璃效果*/
+ (UIImage *)blurImage:(UIImage *)image withBlurRadius:(CGFloat)blurRadius;
/**毛玻璃效果*/
+ (UIImage *)blurImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

@end
