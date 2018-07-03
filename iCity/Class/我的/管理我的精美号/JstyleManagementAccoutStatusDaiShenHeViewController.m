//
//  JstyleManagementAccoutStatusDaiShenHeViewController.m
//  Exquisite
//
//  Created by 数字跃动 on 2017/10/20.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleManagementAccoutStatusDaiShenHeViewController.h"

@interface JstyleManagementAccoutStatusDaiShenHeViewController ()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation JstyleManagementAccoutStatusDaiShenHeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"iCity号";//待审核状态
    self.view.backgroundColor = kWhiteColor;
    
    [self setUpViews];
}

- (void)setUpViews
{
    _backImageView = [[UIImageView alloc] init];
    _backImageView.image = [UIImage imageNamed:@"iCity号待审核"];
    _backImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_backImageView];
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(145+64);
    }];
    
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.text = self.statusString;
    _statusLabel.textColor = kDarkSixColor;
    _statusLabel.font = [UIFont fontWithName:@"PingFang SC" size:14];
    [_statusLabel sizeToFit];
    [self.view addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backImageView.mas_bottom).offset(33);
        make.centerX.offset(0);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
