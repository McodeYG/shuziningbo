//
//  UIImage+CircleImage.m
//  JstyleNews
//
//  Created by 数字跃动 on 2017/12/18.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "UIImage+CircleImage.h"

@implementation UIImage (CircleImage)

///裁剪slider头像图片
+ (UIImage *)scaleToCircleImageWithImage:(UIImage *)image targetSize:(CGSize)targetSize  borderColor:(UIColor *)borderColor{
    UIImage *targerImage = [self image:image fortargetSize:targetSize];
    targerImage = [self yuanWithImage:targerImage size:targetSize];
    targerImage = [self yuanHuanWithImage:targerImage borderColor:borderColor];
    return targerImage;
}

///不变形裁剪图片
+ (UIImage*)image:(UIImage*)image fortargetSize: (CGSize)targetSize{
    
    UIImage *sourceImage = image;
    CGSize imageSize = sourceImage.size;//图片的size
    CGFloat imageWidth = imageSize.width;//图片宽度
    CGFloat imageHeight = imageSize.height;//图片高度
    NSInteger judge;//声明一个判断属性
    
    //判断是否需要调整尺寸(这个地方的判断标准又个人决定,在此我是判断高大于宽),因为图片是800*480,所以也可以变成480*800
    if( ( imageHeight - imageWidth)>0) {
        
        //在这里我将目标尺寸修改成480*800
        CGFloat tempW = targetSize.width;
        CGFloat tempH = targetSize.height;
        targetSize.height= tempW;
        targetSize.width= tempH;
    }
    CGFloat targetWidth = targetSize.width;//获取最终的目标宽度尺寸
    CGFloat targetHeight = targetSize.height;//获取最终的目标高度尺寸
    CGFloat scaleFactor ;//先声明拉伸的系数
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);//这个是图片剪切的起点位置
    
    //第一个判断,图片大小宽跟高都小于目标尺寸,直接返回image
    if( imageHeight < targetHeight && imageWidth < targetWidth) {
        return image;
    }
    
    if (CGSizeEqualToSize(imageSize,targetSize) == NO) {
        CGFloat widthFactor = targetWidth / imageWidth;//这里是目标宽度除以图片宽度
        CGFloat heightFactor = targetHeight / imageHeight; //这里是目标高度除以图片高度
        //分四种情况,
        //第一种,widthFactor,heightFactor都小于1,也就是图片宽度跟高度都比目标图片大,要缩小
        if(widthFactor <1&& heightFactor<1){
            //第一种,需要判断要缩小哪一个尺寸,这里看拉伸尺度,我们的scale在小于1的情况下,谁越小,等下就用原图的宽度高度✖️那一个系数(这里不懂的话,代个数想一下,例如目标800*480  原图1600*800  系数就采用宽度系数widthFactor = 1/2  )
            if(widthFactor > heightFactor){
                judge =1;//右部分空白
                scaleFactor = heightFactor; //修改最后的拉伸系数是高度系数(也就是最后要*这个值)
            } else {
                judge =2;//下部分空白
                scaleFactor = widthFactor;
            }
        } else if (widthFactor >1&& heightFactor <1){
            //第二种,宽度不够比例,高度缩小一点点(widthFactor大于一,说明目标宽度比原图片宽度大,此时只要拉伸高度系数)
            judge =3;//下部分空白
            //采用高度拉伸比例
            scaleFactor = imageWidth / targetWidth;// 计算高度缩小系数
        } else if (heightFactor>1&&widthFactor<1) {
            //第三种,高度不够比例,宽度缩小一点点(heightFactor大于一,说明目标高度比原图片高度大,此时只要拉伸宽度系数)
            judge =4;//下边空白
            //采用高度拉伸比例
            scaleFactor = imageHeight / targetWidth;
        } else {
            //第四种,此时宽度高度都小于目标尺寸,不必要处理放大(如果有处理放大的,在这里写).
            
        }
        
        scaledWidth= imageWidth * scaleFactor;
        scaledHeight = imageHeight * scaleFactor;
    }
    
    if (judge == 1){
        //右部分空白
        targetWidth = scaledWidth;//此时把原来目标剪切的宽度改小,例如原来可能是800,现在改成780
    } else if (judge == 2){
        //下部分空白
        targetHeight = scaledHeight;
    } else if (judge == 3) {
        //第三种,高度不够比例,宽度缩小一点点
        targetWidth = scaledWidth;
    } else {
        //第三种,高度不够比例,宽度缩小一点点
        targetHeight = scaledHeight;
    }
    
    UIGraphicsBeginImageContext(targetSize);//开始剪切
    CGRect thumbnailRect =CGRectZero;//剪切起点(0,0)
    thumbnailRect.origin= thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height= scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();//截图拿到图片
    return newImage;
}

/**
 *  在圆形外面加一个圆环
 */
+ (UIImage *)yuanHuanWithImage:(UIImage *)image borderColor:(UIColor *)borderColor{
    
    //图片的宽度
    CGFloat imageWH = image.size.width;
    //设置圆环的宽度
    CGFloat border = 1;
    //大圆形的宽度高度
    CGFloat ovalWH = imageWH + 2 * border;
    
    //1、开启位图上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(ovalWH, ovalWH), NO, 0);
    
    //2、画大圆
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, ovalWH, ovalWH)];
    [borderColor set];
    [path fill];
    
    //3、设置裁剪区（小圆）
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(border, border, imageWH, imageWH)];
    
    [clipPath addClip];
    
    //4、绘制图片
    [image drawAtPoint:CGPointMake(border, border)];
    
    //5、获取图片
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //6、关闭上下文
    UIGraphicsEndImageContext();
    
    return clipImage;
}

/**
 *  裁剪一个原型图片
 */
+ (UIImage *)yuanWithImage:(UIImage *)image size:(CGSize)imageSize{
    
    //1.开启位图上下文，跟图片尺寸大小一样
    //NO:不透明  0：scale不缩放
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    //2.设置图形裁剪区域，正切图片
    //2.1创建一个圆形路径
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, imageSize.width, imageSize.width)];
    //2.2把路径设置裁剪区
    [path addClip];
    //3.绘制图片
    [image drawAtPoint:CGPointMake(0, 0)];
    //4.从上下文中获取图片
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    //5.关闭上下文
    UIGraphicsEndImageContext();
    
    return clipImage;
}

@end
