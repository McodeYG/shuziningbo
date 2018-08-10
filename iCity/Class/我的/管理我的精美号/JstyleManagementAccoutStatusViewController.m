//
//  JstyleManagementAccoutStatusViewController.m
//  Exquisite
//
//  Created by 数字宁波 on 2017/10/19.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleManagementAccoutStatusViewController.h"
#import "JstyleAuthenticateAccountViewController.h"

@interface JstyleManagementAccoutStatusViewController ()

@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation JstyleManagementAccoutStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"iCity号";//未通过
    self.view.backgroundColor = kWhiteColor;
    
    [self addLeftBarButtonWithImage:[UIImage imageNamed:@"return"] action:@selector(leftBarButtonAction)];
    [self setUpViews];
}

- (void)leftBarButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpViews
{
    _backImageView = [[UIImageView alloc] init];
    _backImageView.image = [UIImage imageNamed:@"iCity号未通过"];
    _backImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_backImageView];
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(145+64);
    }];
    
    NSString *str = @"您的账号审核未通过,请前去修改";
    UILabel *stringLabel = [[UILabel alloc] init];
    stringLabel.textColor = kDarkSixColor;
    stringLabel.font = [UIFont fontWithName:@"PingFang SC" size:14];
    stringLabel.attributedText = [str attributedStringWithTextColor:[UIColor colorFromHex:0xEA2332] range:NSMakeRange(10, 5) textFont:14];;
    [stringLabel sizeToFit];
    [self.view addSubview:stringLabel];
    [stringLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.backImageView.mas_bottom).offset(35);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    stringLabel.userInteractionEnabled = YES;
    [stringLabel addGestureRecognizer:tap];
    
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.text = self.statusString;
    _statusLabel.textColor = kDarkSixColor;
    _statusLabel.font = [UIFont fontWithName:@"PingFang SC" size:14];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    [_statusLabel sizeToFit];
    [self.view addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(50);
        make.right.offset(-50);
        make.top.equalTo(stringLabel.mas_bottom).offset(15);
    }];
    
}

- (void)tapGesture:(UITapGestureRecognizer *)tap {
    JstyleAuthenticateAccountViewController *accountVC = [JstyleAuthenticateAccountViewController new];
    accountVC.isChangeUserInformation = YES;
    [self.navigationController pushViewController:accountVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
