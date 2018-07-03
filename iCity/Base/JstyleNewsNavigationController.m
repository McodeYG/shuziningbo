//
//  JstyleNewsNavigationController.m
//  JstyleNews
//
//  Created by 王磊 on 2017/9/13.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsNavigationController.h"
#import "JstyleNewsVideoDetailViewController.h"


@interface JstyleNewsNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

//防止多次push同一VC
@property (nonatomic, assign) BOOL isPushing;

@end

@implementation JstyleNewsNavigationController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    __weak typeof(self) weakSelf = self;
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
        
        
//        id target = self.interactivePopGestureRecognizer.delegate;
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
//
//        pan.delegate = self;
//        [self.view addGestureRecognizer:pan];
//        self.interactivePopGestureRecognizer.enabled = NO;
        
    }

    
    [self applyTheme];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:NightModeManagerNotification object:nil];
}

// 什么时候调用：每次触发手势之前都会询问下代理，是否触发。
// 作用：拦截手势触发
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
//    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
//    if (self.childViewControllers.count == 1) {
//        // 表示用户在根控制器界面，就不需要触发滑动手势，
//        return NO;
//    }else if([self.topViewController isKindOfClass:[JstyleNewsVideoDetailViewController class]]) {
//        self.interactivePopGestureRecognizer.enabled = NO;
//        return NO;
//    }else {
//        return YES;
//    }
//
//}


- (void)applyTheme {
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName : JSFontWithWeight(18, UIFontWeightRegular), NSForegroundColorAttributeName : ISNightMode?kWhiteColor:kDarkOneColor};
//    [self.navigationBar setNavigationBarBackgroundColor:kNightModeBackColor];//我的界面点击顶部会变白
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if (self.viewControllers.count > 0) {
        //隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
        view.backgroundColor = [UIColor clearColor];
        
        UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
        firstButton.frame = CGRectMake(0, 0, 40, 44);
        [firstButton setImage:(ISNightMode?JSImage(@"返回白色"):JSImage(@"图文返回黑")) forState:UIControlStateNormal];
        [firstButton addTarget:self action:@selector(leftBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
        firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 5*kScreenWidth/375.0, 0, 0)];
        
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
        
        viewController.navigationItem.leftBarButtonItem = leftBarButtonItem;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    
}

- (void)leftBarButtonAction
{
    [self popViewControllerAnimated:YES];
}

#pragma mark -- 屏幕旋转问题
- (BOOL)shouldAutorotate{
    NSString * landscapeRight = [[NSUserDefaults standardUserDefaults]objectForKey:@"JstyleLandscapeRight"];
    if (landscapeRight) {
        return self.topViewController.shouldAutorotate;
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

@end
