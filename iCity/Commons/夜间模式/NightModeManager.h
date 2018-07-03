//
//  NightModeManager.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/1/25.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const Night;
extern NSString *const Day;
static NSString * const NightModeManagerNotification = @"NightModeManagerNotification";

@interface NightModeManager : NSObject

@property (readonly, copy, nonatomic) NSString *currentNightName;

+ (instancetype)defaultManager;
/**夜间--Night 日间--Day*/
- (void)setNightModeName:(NSString *)modeName;

- (BOOL)isNightMode;

@property (nonatomic, strong) UIView *nightView;

@property (nonatomic, strong) UIView *tabbarBackView;

- (void)showNightView;
- (void)removeNighView;

@end
