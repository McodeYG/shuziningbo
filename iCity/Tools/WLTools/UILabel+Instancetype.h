//
//  UILabel+Instancetype.h
//  JstyleNews
//
//  Created by 数字跃动 on 2017/10/24.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (instance)

+ (UILabel *)labelWithColor:(UIColor *)color fontSize:(CGFloat)fontSize text:(NSString *)text;

+ (UILabel *)labelWithColor:(UIColor *)color fontSize:(CGFloat)fontSize text:(NSString *)text alignment:(NSTextAlignment)alignment;

@end


