//
//  UIButton+Instancetype.h
//  JstyleNews
//
//  Created by 数字跃动 on 2017/10/25.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Instancetype)

+ (UIButton *)buttonWithTitle:(NSString *)title normalTextColor:(UIColor *)normalColor selectedTextColor:(UIColor *)selectedColor titleFontSize:(CGFloat)fontSize target:(id)target action:(SEL)action;

+ (UIButton *)buttonWithNormalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage target:(id)target action:(SEL)action;

@end
