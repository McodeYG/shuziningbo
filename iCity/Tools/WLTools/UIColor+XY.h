//
//  UIColor+XY.h
//  Exquisite
//
//  Created by 数字宁波 on 16/3/16.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromHEX(hexValue) [UIColor colorFromHex:hexValue]

@interface UIColor (XY)

/**
 *  根据自己的颜色,返回黑色或者白色
 */
- (instancetype)blackOrWhiteContrastingColor;

/**
 *  返回一个十六进制表示的颜色: @"FF0000" or @"#FF0000"
 */
+ (instancetype)colorFromHexString:(NSString *)hexString;

/**
 *  返回一个十六进制表示的颜色: 0xFF0000
 */
+ (instancetype)colorFromHex:(int)hex;

/**
 *  返回颜色的十六进制string
 */
- (NSString *)hexString;

/**
 * 返回一个rgba四个数的数组
 */
- (NSArray *)rgbaArray;


//myg
+ (instancetype)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha;

@end

