//
//  JstyleNewsChangeMobileViewController.m
//  JstyleNews
//
//  Created by 数字跃动 on 2018/1/17.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsChangeMobileViewController.h"
#import "JstyleNewsChangeMobileDetailViewController.h"

@interface JstyleNewsChangeMobileViewController ()

@property (nonatomic, weak) UILabel *phoneLabel;


@end

@implementation JstyleNewsChangeMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"改绑手机号";
    
    [self setupUI];
}

- (void)setupUI {
    
    UIView *numView = [[UIView alloc] initWithFrame:CGRectMake(30, 83.5 + YG_StatusAndNavightion_H, kScreenWidth - 30*2, 31)];
    [self.view addSubview:numView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick)];
    [numView addGestureRecognizer:tap];
    
    UILabel *label = [UILabel labelWithColor:JSColor(@"#9E9E9E") fontSize:13 text:@"手机号"];
    label.userInteractionEnabled = YES;
    [numView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(0);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:JSImage(@"我的－返回")];
    imageView.userInteractionEnabled = YES;
    [numView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.equalTo(label);
    }];
    
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    phone = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
    UILabel *phoneLabel = [UILabel labelWithColor:ISNightMode?kDarkNineColor:kDarkTwoColor fontSize:13 text:phone alignment:NSTextAlignmentRight];
    self.phoneLabel = phoneLabel;
    phoneLabel.userInteractionEnabled = YES;
    [numView addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.right.equalTo(imageView.mas_left).offset(-5);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = ISNightMode?kDarkNineColor:JSColor(@"#E6E6E6");
    [numView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(0.5);
    }];
}

- (void)tapGestureClick {
    JstyleNewsChangeMobileDetailViewController *detailVC = [JstyleNewsChangeMobileDetailViewController new];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}

@end
