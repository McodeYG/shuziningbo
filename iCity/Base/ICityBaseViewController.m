//
//  ICityBaseViewController.m
//  iCity
//
//  Created by 王磊 on 2018/4/25.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityBaseViewController.h"
#import "JstyleNewsSearchViewController.h"

@interface ICityBaseViewController ()

@end

@implementation ICityBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * imgName = [NSString stringWithFormat:@"推荐-搜索放大镜%@",[ThemeTool blackOrWhite]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:JSImage(imgName) style:UIBarButtonItemStylePlain target:self action:@selector(searchItemClick)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSDictionary *titleColor = @{
                                                NSForegroundColorAttributeName:kThemeeModeTitleColor,
                                                NSFontAttributeName:[UIFont systemFontOfSize:18]
                                                };
    [self.navigationController.navigationBar setTitleTextAttributes:titleColor];
    
        
    NSString *currentThemeName  = [ThemeTool themeString];
    UIImage * img = [UIImage imageNamed:[NSString stringWithFormat:@"bg_%@",currentThemeName]];
    UIImage * nvgationImg = [ThemeTool scaleToSize:img size:CGSizeMake(kScreenWidth, YG_StatusAndNavightion_H)];
    [self.navigationController.navigationBar setBackgroundImage:nvgationImg forBarMetrics:UIBarMetricsDefault];
    
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSDictionary *titleColor = @{
                                NSForegroundColorAttributeName:JSColor(@"#000000"),
                                NSFontAttributeName:[UIFont systemFontOfSize:18]
                                };
    [self.navigationController.navigationBar setTitleTextAttributes:titleColor];
    NSString *currentThemeName  = [ThemeTool themeString];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"bg_%@",currentThemeName]] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

- (void)searchItemClick {
    JstyleNewsSearchViewController *jstyleNewsSearchVC = [JstyleNewsSearchViewController new];
    [self.navigationController pushViewController:jstyleNewsSearchVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
