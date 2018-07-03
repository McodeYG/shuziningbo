//
//  JstyleNewsApplicationManager.h
//  JstyleNews
//
//  Created by 王磊 on 2017/10/24.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    JstyleNewsApplicationFontSizeSmall = 10,
    JstyleNewsApplicationFontSizeMiddle = 13,
    JstyleNewsApplicationFontSizeLarge = 15,
    JstyleNewsApplicationFontSizeVeryLarge = 18
} JstyleNewsApplicationFontSize;

@interface JstyleNewsApplicationManager : NSObject

@property (nonatomic, assign) JstyleNewsApplicationFontSize fontSize;
@property (nonatomic, assign) BOOL isOnlyPlayVideoWifi;

///当前主题名字
@property (nonatomic, copy) NSString *currentTheme;

@property (nonatomic, strong) UIColor *color;

+ (instancetype)shareManager;

@end
