//
//  UIImage+Extension.h
//  Exquisite
//
//  Created by 数字宁波 on 2017/4/6.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 *  返回原型图片
 */
- (instancetype)circleImage;

/**
 *  返回原型图片
 */
+ (instancetype)circleImage:(NSString *)image;

/**
 *  根据颜色返回图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
