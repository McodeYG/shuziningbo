//
//  MyHomeBaseViewController.m
//  iCity
//
//  Created by mayonggang on 2018/6/5.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "MyHomeBaseViewController.h"

@interface MyHomeBaseViewController ()

@end

@implementation MyHomeBaseViewController

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

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}



@end
