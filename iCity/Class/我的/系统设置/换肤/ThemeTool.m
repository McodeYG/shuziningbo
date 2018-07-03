//
//  ThemeTool.m
//  iCity
//
//  Created by mayonggang on 2018/6/5.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ThemeTool.h"

@implementation ThemeTool



+ (NSString *)themeString {
    
    NSString *currentThemeName = [LEETheme currentThemeTag];
    if ([currentThemeName isEqualToString:ThemeName_Red]) {
        return  currentThemeName = @"red";
    } else if ([currentThemeName isEqualToString:ThemeName_White]) {
        return currentThemeName = @"white";
    } else if ([currentThemeName isEqualToString:ThemeName_Blue]) {
        return currentThemeName = @"blue";
    } else if ([currentThemeName isEqualToString:ThemeName_Purple]) {
        return currentThemeName = @"purple";
    } else if ([currentThemeName isEqualToString:ThemeName_Brown]) {
        return currentThemeName = @"brown";
    }else {
        return currentThemeName = @"black";
    }
}

//调整图片大小
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
//导航栏字体颜色
+ (UIColor *)themeTitleColor {

//    NSString *currentThemeName = [LEETheme currentThemeTag];
//    if ([currentThemeName isEqualToString:ThemeName_Red]) {
//        return  ThemeTabbarColor_Red;
//    } else if ([currentThemeName isEqualToString:ThemeName_White]) {
//        return ThemeTabbarColor_White;
//    } else if ([currentThemeName isEqualToString:ThemeName_Blue]) {
//        return ThemeTabbarColor_Blue;
//    } else if ([currentThemeName isEqualToString:ThemeName_Purple]) {
//        return ThemeTabbarColor_Purple;
//    } else if ([currentThemeName isEqualToString:ThemeName_Brown]) {
//        return ThemeTabbarColor_Brown;
//    }else {
//        return ThemeTabbarColor_Black;
//    }
    return kWhiteColor;
}

//首页logo、铃铛、放大镜
+(NSString *)blackOrWhite {
    NSString *currentThemeName = [LEETheme currentThemeTag];
    
    if ([currentThemeName isEqualToString:ThemeName_White]) {
        currentThemeName = @"_black";
    } else  {
        currentThemeName = @"_white";
    }
    return currentThemeName;
}

//是不是白色主题
+(BOOL)isWhiteModel {
    NSString *currentThemeName = [LEETheme currentThemeTag];
    if ([currentThemeName isEqualToString:ThemeName_White]) {
        return YES;
    } else  {
        return NO;
    }
}
//是不是黑色主题
+(BOOL)isBlackModel {
    NSString *currentThemeName = [LEETheme currentThemeTag];
    if ([currentThemeName isEqualToString:ThemeName_Black]) {
        return YES;
    } else  {
        return NO;
    }
}

@end
