//
//  UIImageView+Layer.m
//  UIImageLayer
//
//  Created by 赵涛 on 16/10/18.
//  Copyright © 2016年 赵涛. All rights reserved.
//

#import "UIImageView+Layer.h"

@implementation UIImageView (Layer)

+ (UIImageView *)layerCornerRadiusWithImageView:(UIImageView *)imageView
{
    //开始对imageView进行画图
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 0.0);
    //使用贝塞尔曲线画出一个圆形图
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:imageView.bounds.size.width] addClip];
    //
    [imageView drawRect:imageView.bounds];
    //
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    //结束画图
    UIGraphicsEndImageContext();
    
    return imageView;
}


+ (UIImageView *)roundCornerRadiusWithImageView:(UIImageView *)imageView

{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:imageView.bounds.size];
    //
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = imageView.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    
    imageView.layer.mask = maskLayer;
    
    return imageView;
}


@end
