//
//  JstyleNewsBaseViewController.m
//  JstyleNews
//
//  Created by 王磊 on 2017/9/13.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsBaseViewController.h"
#import "JstyleNewsNetworkManager.h"

@interface JstyleNewsBaseViewController ()

@end

@implementation JstyleNewsBaseViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:NightModeManagerNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = kNightModeBackColor;
}

- (void)applyTheme {
    self.view.backgroundColor = kNightModeBackColor;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if ([ThemeTool isWhiteModel]) {
        return UIStatusBarStyleDefault;
    } else  if ([ThemeTool isBlackModel]) {
        return UIStatusBarStyleLightContent;
    } else{
        return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}

@end

