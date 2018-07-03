//
//  JstyleNewsUserHasLoginedBeforeViewController.m
//  JstyleNews
//
//  Created by 王磊 on 2018/2/12.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsUserHasLoginedBeforeViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface JstyleNewsUserHasLoginedBeforeViewController ()

@property (nonatomic, strong) LAContext *context;

@end

@implementation JstyleNewsUserHasLoginedBeforeViewController

- (LAContext *)context {
    if (_context == nil) {
        _context = [LAContext new];
    }
    return _context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    
    self.view.backgroundColor = kWhiteColor;
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:ISNightMode?JSImage(@"登录关闭夜"):JSImage(@"登录关闭") forState:(UIControlStateNormal)];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    closeBtn.sd_layout
    .leftSpaceToView(self.view, 25)
    .topSpaceToView(self.view, YG_StatusAndNavightion_H)
    .widthIs(30)
    .heightIs(30);
    
    UIImageView *posterImageView = [[UIImageView alloc] init];
    posterImageView.layer.cornerRadius = 88 / 2.0;
    posterImageView.layer.masksToBounds = YES;
    [self.view addSubview:posterImageView];
    [posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(88);
        make.centerX.offset(0);
        make.centerY.offset(-145);
    }];
    
    [posterImageView setImageWithURL:[NSURL URLWithString:self.poster] options:YYWebImageOptionProgressive];
    
    UILabel *nickNameLabel = [UILabel labelWithColor:kDarkNineColor fontSize:15 text:self.nickname alignment:NSTextAlignmentCenter];
    [self.view addSubview:nickNameLabel];
    [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(posterImageView.mas_bottom).offset(15);
    }];
    
    UIButton *loginBtn = [UIButton buttonWithTitle:@"这是我,直接登录" normalTextColor:kWhiteColor selectedTextColor:kWhiteColor titleFontSize:15 target:self action:@selector(loginBtnClick:)];
    [loginBtn setBackgroundColor:JSColor(@"#222222")];
    loginBtn.layer.cornerRadius = 20;
    loginBtn.layer.masksToBounds = YES;
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(63);
        make.right.offset(-63);
        make.height.offset(40);
        make.top.equalTo(nickNameLabel.mas_bottom).offset(IS_iPhoneX?82:65);
    }];
    
    UIButton *norMeBtn = [UIButton buttonWithTitle:@"这不是我,重新登录" normalTextColor:JSColor(@"#222222") selectedTextColor:kDarkNineColor titleFontSize:15 target:self action:@selector(closeBtnClick)];
    [norMeBtn setBackgroundColor:kWhiteColor];
    norMeBtn.layer.cornerRadius = 20;
    norMeBtn.layer.borderColor = JSColor(@"#222222").CGColor;
    norMeBtn.layer.borderWidth = 0.5;
    norMeBtn.layer.masksToBounds = YES;
    [self.view addSubview:norMeBtn];
    [norMeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(63);
        make.right.offset(-63);
        make.height.offset(40);
        make.top.equalTo(loginBtn.mas_bottom).offset(30);
    }];
}

- (void)loginBtnClick:(UIButton *)sender {
    
    NSError *error;
    
    BOOL canAuthentication = [self.context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error];
    
    if (canAuthentication) {
        
        [self.context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"验证您的身份" reply:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
                NSLog(@"成功,直接登录");
                if (self.goLoginBlock) {
                    self.goLoginBlock(success);
                }
                [self dismissViewControllerAnimated:YES completion:nil];
                
            } else {
                NSLog(@"%@",error);
            }
        }];
    } else {
        ZTShowAlertMessage(@"暂时无法通过生物验证您的身份哦");
    }
}

- (void)closeBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.context invalidate];
}

- (void)dealloc {
    [self.context invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
