//
//  JstyleNewsApplicationManager.m
//  JstyleNews
//
//  Created by 王磊 on 2017/10/24.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsApplicationManager.h"

@implementation JstyleNewsApplicationManager

+ (instancetype)shareManager {
    
    static id instace;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instace = [self new];
    });
    return instace;
}

- (NSString *)currentTheme {

    if (_currentTheme == nil) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentTheme];
    } else {
        return _currentTheme;
    }
}

@end
