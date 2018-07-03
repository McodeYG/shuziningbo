//
//  ThemeTool.h
//  iCity
//
//  Created by mayonggang on 2018/6/5.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeTool : NSObject
//获取主题
+ (NSString *)themeString;
//调整导航栏背景图片
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
//导航栏字体颜色
+ (UIColor *)themeTitleColor;

//首页logo、铃铛、放大镜
+(NSString *)blackOrWhite;

//是不是白色主题
+(BOOL)isWhiteModel;
+(BOOL)isBlackModel;

@end
