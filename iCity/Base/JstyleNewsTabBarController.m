//
//  JstyleNewsTabBarController.m
//  JstyleNews
//
//  Created by 王磊 on 2017/9/13.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsTabBarController.h"
#import "JstyleNewsHomeBaseViewController.h"
#import "JstyleNewsNavigationController.h"
#import "ICityReadingViewController.h"
#import "ICityLifeViewController.h"
#import "ICityCultureViewController.h"
#import "JstyleMyHomeViewController.h"

@interface JstyleNewsTabBarController () <UITabBarControllerDelegate,CYLTabBarControllerDelegate>

@property (nonatomic, strong) NSArray *vcArray;
@property (nonatomic, strong) NSArray *tabBarItemsAttributesArray;
@property(readonly, nonatomic) NSUInteger lastSelectedIndex;
/**马永刚*/
//@property (nonatomic, strong) UIView * mygView;
@end

@implementation JstyleNewsTabBarController

- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers tabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes imageInsets:(UIEdgeInsets)imageInsets titlePositionAdjustment:(UIOffset)titlePositionAdjustment {
    return [super initWithViewControllers:self.vcArray tabBarItemsAttributes:self.tabBarItemsAttributesArray imageInsets:UIEdgeInsetsZero titlePositionAdjustment:UIOffsetMake(0, -3)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self customizeInterface];
    [self applyTheme];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:NightModeManagerNotification object:nil];
    
//    self.mygView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/5, 50)];
//    self.mygView.backgroundColor = [UIColor cyanColor];
//    [self.tabBar addSubview:self.mygView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)applyTheme {
    [self.tabBar setBarTintColor:kNightModeBackColor];
    [self.tabBar setTintColor:kNightModeBackColor];
    self.tabBar.translucent = NO;
//    [[NightModeManager defaultManager].tabbarBackView removeFromSuperview];
//    [NightModeManager defaultManager].tabbarBackView.frame = self.tabBar.bounds;
//    if (ISNightMode) {
//        [[UITabBar appearance] insertSubview:[NightModeManager defaultManager].tabbarBackView atIndex:0];
//    }
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.selectedViewController;
}

- (BOOL)shouldAutorotate{
    NSString * landscapeRight = [[NSUserDefaults standardUserDefaults]objectForKey:@"JstyleLandscapeRight"];
    if (landscapeRight) {
        return self.selectedViewController.shouldAutorotate;
    }
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    NSString * landscapeRight = [[NSUserDefaults standardUserDefaults]objectForKey:@"JstyleLandscapeRight"];
    if (landscapeRight) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

#pragma mark - 控制器数组懒加载
- (NSArray *)vcArray {
    if (_vcArray == nil) {
        JstyleNewsHomeBaseViewController *homeVC = [JstyleNewsHomeBaseViewController new];
        JstyleNewsNavigationController *nav1 = [[JstyleNewsNavigationController alloc] initWithRootViewController:homeVC];
        
        ICityReadingViewController *readingVC = [ICityReadingViewController new];
        JstyleNewsNavigationController *nav2 = [[JstyleNewsNavigationController alloc] initWithRootViewController:readingVC];
        
        ICityCultureViewController *cultureVC = [ICityCultureViewController new];
        JstyleNewsNavigationController *nav3 = [[JstyleNewsNavigationController alloc] initWithRootViewController:cultureVC];
        
        ICityLifeViewController *lifeVC = [ICityLifeViewController new];
        JstyleNewsNavigationController *nav4 = [[JstyleNewsNavigationController alloc] initWithRootViewController:lifeVC];
        
        JstyleMyHomeViewController *myVC = [JstyleMyHomeViewController new];
        JstyleNewsNavigationController *nav5 = [[JstyleNewsNavigationController alloc] initWithRootViewController:myVC];
        
        
        _vcArray = @[nav1, nav2, nav3, nav4, nav5];
    }
    return _vcArray;
}

- (NSArray *)tabBarItemsAttributesArray {
    if (_tabBarItemsAttributesArray == nil) {
        
        
        NSString *currentThemeName = [LEETheme currentThemeTag];

        if ([currentThemeName isEqualToString:ThemeName_Red]) {
            currentThemeName = @"red";
        } else if ([currentThemeName isEqualToString:ThemeName_White]) {
            currentThemeName = @"white";
        } else if ([currentThemeName isEqualToString:ThemeName_Blue]) {
            currentThemeName = @"blue";
        } else if ([currentThemeName isEqualToString:ThemeName_Purple]) {
            currentThemeName = @"purple";
        } else if ([currentThemeName isEqualToString:ThemeName_Brown]) {
            currentThemeName = @"brown";
        }else if ([currentThemeName isEqualToString:ThemeName_Black]) {
            currentThemeName = @"black";
        }else{
//            默认
            currentThemeName = @"black";
        }
        
        
        NSDictionary *dict1 = @{
                                CYLTabBarItemTitle : @"首页",
                                CYLTabBarItemImage : [NSString stringWithFormat:@"tab_%@_recommend_default",currentThemeName],
                                CYLTabBarItemSelectedImage : [NSString stringWithFormat:@"tab_%@_recommend_selected",currentThemeName],
                                };
        NSDictionary *dict2 = @{
                                CYLTabBarItemTitle : @"阅读",
                                CYLTabBarItemImage : [NSString stringWithFormat:@"tab_%@_read_default",currentThemeName],
                                CYLTabBarItemSelectedImage : [NSString stringWithFormat:@"tab_%@_read_selected",currentThemeName],
                                };
        NSDictionary *dict3 = @{
                                CYLTabBarItemTitle : @"文化",
                                CYLTabBarItemImage : [NSString stringWithFormat:@"tab_%@_culture_default",currentThemeName],
                                CYLTabBarItemSelectedImage : [NSString stringWithFormat:@"tab_%@_culture_selected",currentThemeName],
                                };
        NSDictionary *dict4 = @{
                                CYLTabBarItemTitle : @"生活",
                                CYLTabBarItemImage : [NSString stringWithFormat:@"tab_%@_life_default",currentThemeName],
                                CYLTabBarItemSelectedImage : [NSString stringWithFormat:@"tab_%@_life_selected",currentThemeName],
                                };
        NSDictionary *dict5 = @{
                                CYLTabBarItemTitle : @"我的",
                                CYLTabBarItemImage : [NSString stringWithFormat:@"tab_%@_my_default",currentThemeName],
                                CYLTabBarItemSelectedImage : [NSString stringWithFormat:@"tab_%@_my_selected",currentThemeName],
                                };
        _tabBarItemsAttributesArray = @[dict1, dict2, dict3, dict4, dict5];
    }
    return _tabBarItemsAttributesArray;
}

/**
 *  tabBarItem 的选中和不选中文字属性、背景图片
 */
- (void)customizeInterface {
    
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = kDarkSixColor;
    normalAttrs[NSFontAttributeName] = JSFontWithWeight(10.1, UIFontWeightLight);
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = JSFontWithWeight(10.1, UIFontWeightLight);
    NSString *currentThemeName = [LEETheme currentThemeTag];
    if ([currentThemeName isEqualToString:ThemeName_Red]) {
        selectedAttrs[NSForegroundColorAttributeName] = ThemeTabbarColor_Red;
    } else if ([currentThemeName isEqualToString:ThemeName_White]) {
        selectedAttrs[NSForegroundColorAttributeName] = ThemeTabbarColor_White;
    } else if ([currentThemeName isEqualToString:ThemeName_Blue]) {
        selectedAttrs[NSForegroundColorAttributeName] = ThemeTabbarColor_Blue;
    } else if ([currentThemeName isEqualToString:ThemeName_Black]) {
        selectedAttrs[NSForegroundColorAttributeName] = ThemeTabbarColor_Black;
    } else if ([currentThemeName isEqualToString:ThemeName_Purple]) {
        selectedAttrs[NSForegroundColorAttributeName] = ThemeTabbarColor_Purple;
    } else if ([currentThemeName isEqualToString:ThemeName_Brown]) {
        selectedAttrs[NSForegroundColorAttributeName] = ThemeTabbarColor_Brown;
    }else{
        selectedAttrs[NSForegroundColorAttributeName] = kDarkThreeColor;
    }
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
}

#pragma mark - CYLTabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control {
    [self addScaleAnimationOnView:[control cyl_tabImageView] repeatCount:1];
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSUInteger tabIndex = [tabBar.items indexOfObject:item];
    if (tabIndex == self.selectedIndex) {
        [[NSNotificationCenter defaultCenter] postNotificationName:
         @"TabbarButtonClickDidRepeatNotification" object:nil];
    }
    
//    self.mygView.alpha = 1;
//    [UIView animateWithDuration:0.4 animations:^{
//        self.mygView.mj_x = tabIndex*kScreenWidth/5;
//        self.mygView.alpha=0.2;
//    } completion:^(BOOL finished) {
//        self.mygView.alpha=0;
//    }];
}

//缩放动画
- (void)addScaleAnimationOnView:(UIView *)animationView repeatCount:(float)repeatCount {
    //需要实现的帧动画，这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 0.8;
    animation.repeatCount = repeatCount;
    animation.calculationMode = kCAAnimationCubic;
    [animationView.layer addAnimation:animation forKey:nil];
}

@end
