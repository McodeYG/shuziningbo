//
//  UILabel+Addition.h
//  BeeQuick
//
//  Created by 齐卫鹏 on 17/06/2017.
//  Copyright © 2017 Weipeng Qi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Addition)

/**
 创建一个label
 
 @param textColor 文字颜色
 @param fontSize 字体大小的数值
 @param text 文字
 */
+ (UILabel *)makeLabelWithTextColor:(UIColor *)textColor andTextFont:(CGFloat)fontSize andContentText:(NSString *)text;

@end
