//
//  UILabel+Instancetype.m
//  JstyleNews
//
//  Created by 数字跃动 on 2017/10/24.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "UILabel+Instancetype.h"

@implementation UILabel (Instancetype)

+ (UILabel *)labelWithColor:(UIColor *)color fontSize:(CGFloat)fontSize text:(NSString *)text {
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = [UIFont fontWithName:@"PingFang SC" size:fontSize];
    label.text = text;
    return label;
}

+ (UILabel *)labelWithColor:(UIColor *)color fontSize:(CGFloat)fontSize text:(NSString *)text alignment:(NSTextAlignment)alignment {
    
    UILabel *label = [self labelWithColor:color fontSize:fontSize text:text];
    label.textAlignment = alignment;
    return label;
}

@end

