//
//  NightModeManager.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/1/25.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "NightModeManager.h"

NSString *const Night               = @"Night";
NSString *const Day                 = @"Day";
NSString *const NightModeName       = @"NightModeName";

@interface NightModeManager ()

@property (readwrite, copy, nonatomic) NSString * currentNightName;

@end

@implementation NightModeManager

+ (instancetype)defaultManager
{
    static NightModeManager *DefaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DefaultManager = [[NightModeManager alloc] init];
    });
    return DefaultManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentNightName = [[NSUserDefaults standardUserDefaults] stringForKey:NightModeName];
        if (!self.currentNightName) {
            self.currentNightName = Day;
        }
    }
    return self;
}

- (void)setNightModeName:(NSString *)modeName
{
    self.currentNightName = modeName;
    [[NSUserDefaults standardUserDefaults] setObject:modeName forKey:NightModeName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:NightModeManagerNotification object:nil];
    [UIView transitionWithView:[UIApplication sharedApplication].keyWindow duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
       [[NightModeManager defaultManager]showNightView];

    } completion:nil];
}
//夜间模式返回YES，日间模式返回NO
- (BOOL)isNightMode
{
    NSString * modelName = [[NSUserDefaults standardUserDefaults] stringForKey:NightModeName];
    if ([modelName isEqualToString:Night]) {
        return YES;
    }else{
        return NO;
    }
}

- (UIView *)nightView
{
    if (!_nightView) {
        CGRect rect = [UIApplication sharedApplication].keyWindow.bounds;
        _nightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.height, rect.size.height)];
        _nightView.backgroundColor = [JSColor(@"#252525") colorWithAlphaComponent:0.5];
        _nightView.userInteractionEnabled = NO;
    }
    return _nightView;
}

- (UIView *)tabbarBackView
{
    if (!_tabbarBackView) {
        _tabbarBackView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        _tabbarBackView.backgroundColor = kNightModeBackColor;
        _tabbarBackView.userInteractionEnabled = NO;
    }
    return _tabbarBackView;
}

- (void)showNightView
{
    [[NightModeManager defaultManager].nightView removeFromSuperview];
    if ([self isNightMode]) {
        [[UIApplication sharedApplication].keyWindow addSubview:[NightModeManager defaultManager].nightView];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:[NightModeManager defaultManager].nightView];
    }
}

- (void)removeNighView
{
    [[NightModeManager defaultManager].nightView removeFromSuperview];
}

@end
