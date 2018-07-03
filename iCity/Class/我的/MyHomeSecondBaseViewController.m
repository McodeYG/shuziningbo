//
//  MyHomeSecondBaseViewController.m
//  iCity
//
//  Created by mayonggang on 2018/6/27.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "MyHomeSecondBaseViewController.h"

@interface MyHomeSecondBaseViewController ()

@end

@implementation MyHomeSecondBaseViewController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UIColor * textColor = ISNightMode?kDarkCCCColor:JSColor(@"#000000");
    
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:textColor,
                                                NSFontAttributeName:[UIFont systemFontOfSize:18]  };
    [self.navigationController.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNightModeBackColor] forBarMetrics:UIBarMetricsDefault];
    
    self.view.backgroundColor = kNightModeBackColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}

@end
