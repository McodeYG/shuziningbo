//
//  JstyleNewsLoginViewController.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/20.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsLoginViewController.h"
#import "NSString+MD5.h"
#import "JstyleNewsRegistViewController.h"
#import "JstyleNewsForgetPwdViewController.h"
#import "JstyleNewsBindMobileViewController.h"
#import "WLKeyChain.h"
#import "JstyleNewsUserHasLoginedBeforeViewController.h"

@interface JstyleNewsLoginViewController ()

@property (nonatomic, strong) UITextField *mobileField;

@property (nonatomic, strong) UITextField *pwdField;

@property (nonatomic, strong) UIButton *secureEntryBtn;

@property (nonatomic, strong) UIButton *registBtn;

@property (nonatomic, strong) UIButton *forgetPwdBtn;

@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) NSDictionary *userInfo;

@end

@implementation JstyleNewsLoginViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissVC) name:@"JSTYLENEWSLOGININDISMISSNOTIFICATION" object:nil];
    
    [self setUpViews];
    
    ///用户之前登陆过
    [self userHaveLogined];
}

- (void)userHaveLogined {
    NSString *password = [WLKeyChain keyChainLoad];
    if (password != nil || ![password isEqualToString:@""]) {
        [self getUserInfo];
    }
}

- (void)dismissVC {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mobileField resignFirstResponder];
    [_pwdField resignFirstResponder];
}

- (void)setUpViews
{
    UIButton *closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [closeBtn setImage:ISNightMode?JSImage(@"登录关闭夜"):JSImage(@"登录关闭") forState:(UIControlStateNormal)];
    [closeBtn addTarget:self action:@selector(leftBarButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:closeBtn];
    closeBtn.sd_layout
    .leftSpaceToView(self.view, 25)
    .topSpaceToView(self.view, YG_StatusAndNavightion_H)
    .widthIs(30)
    .heightIs(30);
    
    _mobileField = [[UITextField alloc] init];
    _mobileField.font = JSFont(13);
    _mobileField.keyboardType = UIKeyboardTypeNumberPad;
    _mobileField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _mobileField.attributedPlaceholder = [@"请输入手机号" attributedColorStringWithTextColor:kDarkNineColor font:JSFont(13)];
    _mobileField.textColor = ISNightMode?kDarkNineColor:kDarkTwoColor;
    _mobileField.tintColor = kLightBlueColor;
    [_mobileField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_mobileField];
    _mobileField.sd_layout
    .leftSpaceToView(self.view, 30)
    .rightSpaceToView(self.view, 30)
    .topSpaceToView(closeBtn, 70)
    .heightIs(54);
    
    UIView *singleLine1 = [[UIView alloc] init];
    singleLine1.backgroundColor = ISNightMode?kDarkNineColor:kSingleLineColor;
    [self.view addSubview:singleLine1];
    singleLine1.sd_layout
    .leftSpaceToView(self.view, 30)
    .rightSpaceToView(self.view, 30)
    .topSpaceToView(_mobileField, 0)
    .heightIs(0.5);
    
    _secureEntryBtn = [[UIButton alloc] init];
    [_secureEntryBtn setImage:ISNightMode?JSImage(@"密码暗文夜"):JSImage(@"密码暗文") forState:(UIControlStateNormal)];
    [_secureEntryBtn setImage:ISNightMode?JSImage(@"密码明文夜"):JSImage(@"密码明文") forState:(UIControlStateSelected)];
    [_secureEntryBtn addTarget:self action:@selector(secureEntryBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_secureEntryBtn];
    _secureEntryBtn.sd_layout
    .rightSpaceToView(self.view, 30)
    .topSpaceToView(singleLine1, 20)
    .widthIs(19)
    .heightIs(14);
    
    _pwdField = [[UITextField alloc] init];
    _pwdField.font = JSFont(13);
    _pwdField.secureTextEntry = YES;
    _pwdField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwdField.attributedPlaceholder = [@"请输入密码" attributedColorStringWithTextColor:kDarkNineColor font:JSFont(13)];
    _pwdField.textColor = ISNightMode?kDarkNineColor:kDarkTwoColor;
    _pwdField.tintColor = kLightBlueColor;
    [_pwdField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_pwdField];
    _pwdField.sd_layout
    .leftSpaceToView(self.view, 30)
    .rightSpaceToView(_secureEntryBtn, 0)
    .topSpaceToView(singleLine1, 0)
    .heightIs(54);
    
    UIView *singleLine2 = [[UIView alloc] init];
    singleLine2.backgroundColor = ISNightMode?kDarkNineColor:kSingleLineColor;
    [self.view addSubview:singleLine2];
    singleLine2.sd_layout
    .leftSpaceToView(self.view, 30)
    .rightSpaceToView(self.view, 30)
    .topSpaceToView(_pwdField, 0)
    .heightIs(0.5);
    
    _loginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _loginBtn.backgroundColor = ISNightMode?JSColor(@"#373737"):kDarkThreeColor;
    _loginBtn.titleLabel.font = JSFont(15);
    _loginBtn.layer.cornerRadius = 24;
    _loginBtn.layer.shadowColor = (ISNightMode?JSColor(@"#CE5050"):kPinkColor).CGColor;
    _loginBtn.layer.shadowOffset = CGSizeMake(- 2, 10);
    _loginBtn.layer.shadowRadius = 10;
    [_loginBtn setTitle:@"登录" forState:(UIControlStateNormal)];
    [_loginBtn setTitleColor:ISNightMode?kDarkNineColor:kWhiteColor forState:(UIControlStateNormal)];
    [_loginBtn addTarget:self action:@selector(loginBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_loginBtn];
    _loginBtn.sd_layout
    .leftSpaceToView(self.view, 38)
    .rightSpaceToView(self.view, 38)
    .topSpaceToView(singleLine2, 50)
    .heightIs(48);
    
    _registBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _registBtn.titleLabel.font = JSFont(12);
    [_registBtn setTitle:@"快速注册∕登录" forState:(UIControlStateNormal)];
    [_registBtn setTitleColor:kLightBlueColor forState:(UIControlStateNormal)];
    [_registBtn addTarget:self action:@selector(registBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [_registBtn setEnlargeEdgeWithTop:10 right:0 bottom:10 left:0];
    [self.view addSubview:_registBtn];
    _registBtn.sd_layout
    .leftEqualToView(_loginBtn)
    .topSpaceToView(_loginBtn, 20);
    [_registBtn setupAutoSizeWithHorizontalPadding:0 buttonHeight:15];
    
    _forgetPwdBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _forgetPwdBtn.titleLabel.font = JSFont(12);
    [_forgetPwdBtn setTitle:@"忘记密码" forState:(UIControlStateNormal)];
    [_forgetPwdBtn setTitleColor:kLightBlueColor forState:(UIControlStateNormal)];
    [_forgetPwdBtn addTarget:self action:@selector(forgetPwdBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [_forgetPwdBtn setEnlargeEdgeWithTop:10 right:0 bottom:10 left:0];
    [self.view addSubview:_forgetPwdBtn];
    _forgetPwdBtn.sd_layout
    .rightEqualToView(_loginBtn)
    .topSpaceToView(_loginBtn, 20);
    [_forgetPwdBtn setupAutoSizeWithHorizontalPadding:0 buttonHeight:15];
    
    
    UIButton *wxLoginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [wxLoginBtn setImage:ISNightMode?JSImage(@"微信登录夜"):JSImage(@"微信登录") forState:(UIControlStateNormal)];
    [wxLoginBtn addTarget:self action:@selector(wxLoginBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:wxLoginBtn];
    wxLoginBtn.sd_layout
    .centerXEqualToView(self.view)
    .bottomSpaceToView(self.view, 40)
    .widthIs(33)
    .heightIs(33);
    
    UIButton *qqLoginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [qqLoginBtn setImage:ISNightMode?JSImage(@"QQ登录夜"):JSImage(@"QQ登录") forState:(UIControlStateNormal)];
    [qqLoginBtn addTarget:self action:@selector(qqLoginBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:qqLoginBtn];
    qqLoginBtn.sd_layout
    .rightSpaceToView(wxLoginBtn, 70)
    .bottomSpaceToView(self.view, 40)
    .widthIs(33)
    .heightIs(33);
    
    UIButton *wbLoginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [wbLoginBtn setImage:ISNightMode?JSImage(@"微博登录夜"):JSImage(@"微博登录") forState:(UIControlStateNormal)];
    [wbLoginBtn addTarget:self action:@selector(wbLoginBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:wbLoginBtn];
    wbLoginBtn.sd_layout
    .leftSpaceToView(wxLoginBtn, 70)
    .bottomSpaceToView(self.view, 40)
    .widthIs(33)
    .heightIs(33);
    
    
    
    BOOL weChat = [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]];
    if (weChat) {
        wxLoginBtn.hidden = NO;
    }else {
        wxLoginBtn.hidden = YES;
    }
    BOOL qq = [[UIApplication sharedApplication]canOpenURL: [NSURL URLWithString:@"mqqapi://"]];
    if (qq) {
        qqLoginBtn.hidden = NO;
    }else{
        qqLoginBtn.hidden = YES;
    }
    
    
    if (qq&&weChat) {
        wbLoginBtn.hidden = NO;
    }else{
        wbLoginBtn.hidden = YES;
    }
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"使用社交网络账号登录";
    titleLabel.textColor = kDarkNineColor;
    titleLabel.font = JSFont(14);
    [self.view addSubview:titleLabel];
    titleLabel.sd_layout
    .centerXEqualToView(self.view)
    .bottomSpaceToView(wxLoginBtn, 40)
    .heightIs(14);
    [titleLabel setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
    
    
    UIView *singleLine3 = [[UIView alloc] init];
    singleLine3.backgroundColor = ISNightMode?kDarkNineColor:kSingleLineColor;
    [self.view addSubview:singleLine3];
    singleLine3.sd_layout
    .leftSpaceToView(self.view, 30)
    .rightSpaceToView(titleLabel, 10)
    .centerYEqualToView(titleLabel)
    .heightIs(0.5);
    
    UIView *singleLine4 = [[UIView alloc] init];
    singleLine4.backgroundColor = ISNightMode?kDarkNineColor:kSingleLineColor;
    [self.view addSubview:singleLine4];
    singleLine4.sd_layout
    .leftSpaceToView(titleLabel, 10)
    .rightSpaceToView(self.view, 30)
    .centerYEqualToView(titleLabel)
    .heightIs(0.5);
}

- (void)textFieldTextChange:(UITextField *)textField
{
    if ((_mobileField.text.length > 0) && (_pwdField.text.length > 0)) {
        _loginBtn.backgroundColor = ISNightMode?JSColor(@"#CE5050"):kPinkColor;
        _loginBtn.layer.shadowOpacity = 0.3;
    }else{
        _loginBtn.backgroundColor = ISNightMode?JSColor(@"#373737"):kDarkThreeColor;
        _loginBtn.layer.shadowOpacity = 0.0;
    }
}

- (void)loginBtnClicked:(UIButton *)sender
{
    if (![[JstyleToolManager sharedManager] isMobileNumber:_mobileField.text]) {
        [self.view endEditing:YES];
        ZTShowAlertMsgWithAlignment(@"手机号格式不正确", AlertMessageAlignmentBottom);
        return;
    }
    if (!_pwdField.text || [_pwdField.text isEqualToString:@""]){
        ZTShowAlertMessage(@"请输入密码");
        return;
    }
    [self postMobileAndPwd];
}

- (void)registBtnClicked:(UIButton *)sender
{
    JstyleNewsRegistViewController *jstyleNewsRegistVC = [JstyleNewsRegistViewController new];
    jstyleNewsRegistVC.dismissBlock = ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [self.navigationController presentViewController:jstyleNewsRegistVC animated:YES completion:nil];
}

- (void)forgetPwdBtnClicked:(UIButton *)sender
{
    JstyleNewsForgetPwdViewController *jstyleNewsFPwdVC = [JstyleNewsForgetPwdViewController new];
    jstyleNewsFPwdVC.findPwdBlock = ^(NSString *mobile, NSString *password) {
        self.mobileField.text = mobile;
        self.pwdField.text = password;
    };
    
    [self.navigationController presentViewController:jstyleNewsFPwdVC animated:YES completion:nil];
}

- (void)postMobileAndPwd
{
    [SVProgressHUD showWithStatus:@"登录中..."];
    NSString *pwd = [NSString getMD5StringFromString:[NSString getMD5StringFromString:_pwdField.text]];
    NSDictionary *parameters = @{@"uname":_mobileField.text,
                                 @"password":pwd};
    [[JstyleNewsNetworkManager shareManager] POSTURL:MOBILE_LOGIN_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            
            [WLKeyChain keyChainDelete];
            NSString *userNameAndPassword = [NSString stringWithFormat:@"one,%@,%@,%@",responseObject[@"data"][@"id"],self.mobileField.text,responseObject[@"data"][@"password"]];
            [WLKeyChain keyChainSave:userNameAndPassword];
            
            [[JstyleToolManager sharedManager] saveLoginUserInfoWithDictionary:responseObject[@"data"]];
            [SVProgressHUD dismiss];
            
            //发送请求用户信息通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"JSTYLENEWSGETUSERINFONOTIFICATION" object:nil];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else{
            [SVProgressHUD dismiss];
            ZTShowAlertMessage(responseObject[@"message"]);
        }
    } failure:^(NSError *error) {
        ZTShowAlertMessage(@"登录失败,请检查网络");
        [SVProgressHUD dismiss];
    }];
}

/**
 * qq登录
 */
- (void)qqLoginBtnClicked:(UIButton *)sender
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            ZTShowAlertMessage(@"登录失败");
        }else{
            UMSocialUserInfoResponse *userinfo = result;
            NSLog(@"%@",userinfo.originalResponse);
            [[NSUserDefaults standardUserDefaults]setObject:@"qqLogin" forKey:@"qqLogin"];
            [[NSUserDefaults standardUserDefaults]setObject:userinfo.openid forKey:@"phone"];
            
            NSString *sex = userinfo.originalResponse[@"gender"];
            NSString *address = [userinfo.originalResponse[@"province"] stringByAppendingString:userinfo.originalResponse[@"city"]];
            
            self.userInfo = @{@"openid":userinfo.uid,
                              @"unionid":userinfo.openid,
                              @"type":@"1",
                              @"nickname":userinfo.name,
                              @"avator":userinfo.iconurl,
                              @"sex":sex,
                              @"birth":@"",
                              @"address":address,
                              @"phone_type":@"1",
                              @"uuid":[JstyleToolManager sharedManager].getUDID,
                              @"platform_type":@"2"};
            [self thirdPartLoginWithOpenid:userinfo.uid unionid:userinfo.unionId type:@"1" platform_type:@"2"];
        }
    }];
}

/**
 * 微信登录
 */
- (void)wxLoginBtnClicked:(UIButton *)sender
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            ZTShowAlertMessage(@"登录失败");
        }else{
            UMSocialUserInfoResponse *userinfo = result;
            [[NSUserDefaults standardUserDefaults]setObject:@"wxLogin" forKey:@"wxLogin"];
            [[NSUserDefaults standardUserDefaults]setObject:userinfo.openid forKey:@"phone"];
            NSString *sex = userinfo.originalResponse[@"sex"];
            NSString *address = [userinfo.originalResponse[@"province"] stringByAppendingString:userinfo.originalResponse[@"city"]];
            
            self.userInfo = @{@"openid":userinfo.uid,
                              @"unionid":userinfo.unionId,
                              @"type":@"2",
                              @"nickname":userinfo.name,
                              @"avator":userinfo.iconurl,
                              @"sex":sex,
                              @"birth":@"",
                              @"address":address,
                              @"phone_type":@"1",
                              @"uuid":[JstyleToolManager sharedManager].getUDID,
                              @"platform_type":@"2"};
            [self thirdPartLoginWithOpenid:userinfo.uid unionid:userinfo.unionId type:@"2" platform_type:@"2"];
        }
    }];
}

/**
 * 新浪登录
 */
- (void)wbLoginBtnClicked:(UIButton *)sender
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            ZTShowAlertMessage(@"登录失败");
        }else{
            UMSocialUserInfoResponse *userinfo = result;
            [[NSUserDefaults standardUserDefaults]setObject:@"wbLogin" forKey:@"wbLogin"];
            [[NSUserDefaults standardUserDefaults]setObject:userinfo.uid forKey:@"phone"];
            NSString *sex = userinfo.originalResponse[@"gender"];
            NSString *address = userinfo.originalResponse[@"location"];
            
            self.userInfo = @{@"openid":userinfo.uid,
                              @"unionid":userinfo.unionId,
                              @"type":@"3",
                              @"nickname":userinfo.name,
                              @"avator":userinfo.iconurl,
                              @"sex":sex,
                              @"birth":@"",
                              @"address":address,
                              @"phone_type":@"1",
                              @"uuid":[JstyleToolManager sharedManager].getUDID,
                              @"platform_type":@"2"};
            [self thirdPartLoginWithOpenid:userinfo.uid unionid:userinfo.unionId type:@"3" platform_type:@"2"];
        }
    }];
}



/**
 * 判断第三方是否绑定手机
 @param openid        第三方的openid
 @param unionid       第三方的unionid
 @param type          第三方类型
 @param platform_type App类型
 */
- (void)thirdPartLoginWithOpenid:(NSString *)openid unionid:(NSString *)unionid type:(NSString *)type platform_type:(NSString *)platform_type
{
    NSDictionary *parameters = @{@"openid":[NSString stringWithFormat:@"%@",openid],
                                 @"unionid":[NSString stringWithFormat:@"%@",unionid],
                                 @"type":[NSString stringWithFormat:@"%@",type],
                                 @"platform_type":@"2"};
    [[JstyleNewsNetworkManager shareManager] POSTURL:THIRD_LOGIN_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"is_bind"] integerValue] == 1) {
                ZTShowAlertMessage(@"登录成功");
                NSDictionary *userInfo = responseObject[@"data"][@"userInfo"];
                [WLKeyChain keyChainDelete];
                NSString *userNameAndPassword = [NSString stringWithFormat:@"third,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",
                                                 @"2",//1
                                                 [NSString stringWithFormat:@"%@",userInfo[@"id"]],//2
                                                 [NSString stringWithFormat:@"%@",type],//3
                                                 [NSString stringWithFormat:@"%@",userInfo[@"nick_name"]],//4
                                                 [NSString stringWithFormat:@"%@",userInfo[@"avator"]],//5
                                                 [NSString stringWithFormat:@"%@",unionid],//6
                                                 [NSString stringWithFormat:@"%@",[[JstyleToolManager sharedManager] getUDID]],//7
                                                 [NSString stringWithFormat:@"%@",userInfo[@"sex"]],//8
                                                 @"1",//9
                                                 [NSString stringWithFormat:@"%@",userInfo[@"birth"]],//10
                                                 [NSString stringWithFormat:@"%@",platform_type]];//11
                [WLKeyChain keyChainSave:userNameAndPassword];
                //发送请求用户信息通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"JSTYLENEWSGETUSERINFONOTIFICATION" object:nil];
                [[JstyleToolManager sharedManager] saveLoginUserInfoWithDictionary:responseObject[@"data"][@"userInfo"]];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }else{
                //绑定手机号
                JstyleNewsBindMobileViewController *jstyleNewsBindMobileVC = [JstyleNewsBindMobileViewController new];
                jstyleNewsBindMobileVC.userInfo = self.userInfo;
                [self.navigationController pushViewController:jstyleNewsBindMobileVC animated:YES];
            }
        }else{
            ZTShowAlertMsgWithAlignment(responseObject[@"error"], AlertMessageAlignmentBottom);
        }
    } failure:^(NSError *error) {
        ZTShowAlertMessage(@"登录失败");
    }];
}

///获取用户上次登录信息
- (void)getUserInfo {
    
    NSString *keyChainString = [WLKeyChain keyChainLoad];
    if (keyChainString == nil || [keyChainString isEqualToString:@""]) {
        return;
    }
    NSArray *array = [keyChainString componentsSeparatedByString:@","];
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    //上次第三方登录
    if ([array.firstObject isEqualToString:@"third"]) {
        JstyleNewsUserHasLoginedBeforeViewController *hasLoginVC = [[JstyleNewsUserHasLoginedBeforeViewController alloc] init];
        hasLoginVC.poster = array[5];
        hasLoginVC.nickname = array[4];
        [self presentViewController:hasLoginVC animated:YES completion:nil];
        __weak typeof(self)weakSelf = self;
        hasLoginVC.goLoginBlock = ^(BOOL success) {
            if (success) {
                [weakSelf thirdPartLoginWithOpenid:array[1] unionid:array[6] type:array[3] platform_type:array.lastObject];
            }
        };
        return;
    }
    
    //上次为手机号密码登录
    NSDictionary *paramaters = @{
                                 @"uid":array[1]
                                 };
    [manager GETURL:LOGIN_USERINFO_URL parameters:paramaters success:^(id responseObject) {

        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            NSString *nickname = responseObject[@"data"][@"nick_name"];
            NSString *posterStr = responseObject[@"data"][@"poster"];
            JstyleNewsUserHasLoginedBeforeViewController *hasLoginVC = [[JstyleNewsUserHasLoginedBeforeViewController alloc] init];
            hasLoginVC.nickname = nickname;
            hasLoginVC.poster = posterStr;
            [self presentViewController:hasLoginVC animated:YES completion:nil];
            
            //验证成功,直接登录
            __weak typeof(self)weakSelf = self;
            hasLoginVC.goLoginBlock = ^(BOOL success) {
                if (success) {
                    NSString *keyChainString = [WLKeyChain keyChainLoad];
                    NSString *uname = [keyChainString componentsSeparatedByString:@","][2];
                    NSString *password = [keyChainString componentsSeparatedByString:@","].lastObject;
                    NSDictionary *paramaters = @{
                                                 @"uname":[NSString stringWithFormat:@"%@",uname],
                                                 @"password":[NSString stringWithFormat:@"%@",password]
                                                 };
                    [[JstyleNewsNetworkManager shareManager] POSTURL:MOBILE_LOGIN_URL parameters:paramaters success:^(id responseObject) {
                        if ([responseObject[@"code"] integerValue] == 1) {
                            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                            
                            [[JstyleToolManager sharedManager] saveLoginUserInfoWithDictionary:responseObject[@"data"]];
                            [SVProgressHUD dismiss];
                            
                            //发送请求用户信息通知
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"JSTYLENEWSGETUSERINFONOTIFICATION" object:nil];
                            
                            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                        }else{
                            [SVProgressHUD dismiss];
                            ZTShowAlertMessage(responseObject[@"error"]);
                        }
                    } failure:^(NSError *error) {
                        ZTShowAlertMessage(@"登录失败");
                        [SVProgressHUD dismiss];
                    }];
                }
            };
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_mobileField resignFirstResponder];
    [_pwdField resignFirstResponder];
}

- (void)secureEntryBtnClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        _pwdField.secureTextEntry = NO;
    }else{
        _pwdField.secureTextEntry = YES;
    }
}

- (void)leftBarButtonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
