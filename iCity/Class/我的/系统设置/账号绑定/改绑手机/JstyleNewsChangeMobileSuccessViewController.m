//
//  JstyleNewsChangeMobileSuccessViewController.m
//  JstyleNews
//
//  Created by 数字跃动 on 2018/1/18.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsChangeMobileSuccessViewController.h"

@interface JstyleNewsChangeMobileSuccessViewController ()

@end

@implementation JstyleNewsChangeMobileSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftBarButtonWithImage:ISNightMode?JSImage(@"返回白色"):JSImage(@"图文返回黑") action:@selector(leftItemClick)];
    
    [self setupUI];
}

- (void)setupUI {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:JSImage(@"绑定成功")];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(175 + YG_StatusAndNavightion_H);
    }];
    
    UILabel *label = [UILabel labelWithColor:ISNightMode?kDarkNineColor:kDarkFiveColor fontSize:18 text:@"绑定手机号成功!" alignment:NSTextAlignmentCenter];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(imageView.mas_bottom).offset(32);
    }];
}

- (void)leftItemClick {
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}

@end
