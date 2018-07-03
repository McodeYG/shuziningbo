//
//  JstyleNewsForgetPwdViewController.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/21.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsForgetPwdViewController.h"
#import "NSString+MD5.h"

@interface JstyleNewsForgetPwdViewController ()

@property (nonatomic, strong) UITextField *mobileField;

@property (nonatomic, strong) UITextField *codeField;

@property (nonatomic, strong) UIButton *getCodeBtn;

@property (nonatomic, strong) UITextField *pwdField;

@property (nonatomic, strong) UIButton *secureEntryBtn;

@property (nonatomic, strong) UIButton *commitBtn;

@end

@implementation JstyleNewsForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    [self setUpViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if (ISNightMode) {
        [[UIApplication sharedApplication].keyWindow addSubview:[NightModeManager defaultManager].nightView];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [_mobileField resignFirstResponder];
    [_codeField resignFirstResponder];
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
    .topSpaceToView(self.view, YG_StatusAndNavightion_H + 70)
    .heightIs(54);
    
    UIView *singleLine1 = [[UIView alloc] init];
    singleLine1.backgroundColor = ISNightMode?kDarkNineColor:kSingleLineColor;
    [self.view addSubview:singleLine1];
    singleLine1.sd_layout
    .leftSpaceToView(self.view, 30)
    .rightSpaceToView(self.view, 30)
    .topSpaceToView(_mobileField, 0)
    .heightIs(0.5);
    
    _getCodeBtn = [[UIButton alloc] init];
    _getCodeBtn.titleLabel.font = JSFont(12);
    [_getCodeBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    [_getCodeBtn setTitleColor:kLightBlueColor forState:(UIControlStateNormal)];
    [_getCodeBtn addTarget:self action:@selector(getCodeBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_getCodeBtn];
    _getCodeBtn.sd_layout
    .rightSpaceToView(self.view, 30)
    .topSpaceToView(singleLine1, 20)
    .widthIs(70)
    .heightIs(14);
    
    _codeField = [[UITextField alloc] init];
    _codeField.font = JSFont(13);
    _codeField.keyboardType = UIKeyboardTypeNumberPad;
    _codeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _codeField.attributedPlaceholder = [@"请输入验证码" attributedColorStringWithTextColor:kDarkNineColor font:JSFont(13)];
    _codeField.textColor = ISNightMode?kDarkNineColor:kDarkTwoColor;
    _codeField.tintColor = kLightBlueColor;
    [_codeField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_codeField];
    _codeField.sd_layout
    .leftSpaceToView(self.view, 30)
    .rightSpaceToView(_getCodeBtn, 10)
    .topSpaceToView(singleLine1, 0)
    .heightIs(54);
    
    UIView *singleLine2 = [[UIView alloc] init];
    singleLine2.backgroundColor = ISNightMode?kDarkNineColor:kSingleLineColor;
    [self.view addSubview:singleLine2];
    singleLine2.sd_layout
    .leftSpaceToView(self.view, 30)
    .rightSpaceToView(self.view, 30)
    .topSpaceToView(_codeField, 0)
    .heightIs(0.5);
    
    _secureEntryBtn = [[UIButton alloc] init];
    [_secureEntryBtn setImage:ISNightMode?JSImage(@"密码暗文夜"):JSImage(@"密码暗文") forState:(UIControlStateNormal)];
    [_secureEntryBtn setImage:ISNightMode?JSImage(@"密码明文夜"):JSImage(@"密码明文") forState:(UIControlStateSelected)];
    [_secureEntryBtn addTarget:self action:@selector(secureEntryBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_secureEntryBtn];
    _secureEntryBtn.sd_layout
    .rightSpaceToView(self.view, 30)
    .topSpaceToView(singleLine2, 20)
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
    .topSpaceToView(singleLine2, 0)
    .heightIs(54);
    
    UIView *singleLine3 = [[UIView alloc] init];
    singleLine3.backgroundColor = ISNightMode?kDarkNineColor:kSingleLineColor;
    [self.view addSubview:singleLine3];
    singleLine3.sd_layout
    .leftSpaceToView(self.view, 30)
    .rightSpaceToView(self.view, 30)
    .topSpaceToView(_pwdField, 0)
    .heightIs(0.5);
    
    _commitBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _commitBtn.backgroundColor = ISNightMode?JSColor(@"#373737"):kDarkThreeColor;
    _commitBtn.titleLabel.font = JSFont(15);
    _commitBtn.layer.cornerRadius = 24;
    _commitBtn.layer.shadowColor = (ISNightMode?JSColor(@"#CE5050"):kPinkColor).CGColor;
    _commitBtn.layer.shadowOffset = CGSizeMake(- 2, 10);
    _commitBtn.layer.shadowRadius = 10;
    [_commitBtn setTitle:@"完成" forState:(UIControlStateNormal)];
    [_commitBtn setTitleColor:ISNightMode?kDarkNineColor:kWhiteColor forState:(UIControlStateNormal)];
    [_commitBtn addTarget:self action:@selector(commitBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_commitBtn];
    _commitBtn.sd_layout
    .leftSpaceToView(self.view, 38)
    .rightSpaceToView(self.view, 38)
    .topSpaceToView(singleLine3, 50)
    .heightIs(48);
}

- (void)textFieldTextChange:(UITextField *)textField
{
    if ((_mobileField.text.length > 0) && (_codeField.text.length > 0) && (_pwdField.text.length > 0)) {
        _commitBtn.backgroundColor = ISNightMode?JSColor(@"#CE5050"):kPinkColor;
        _commitBtn.layer.shadowOpacity = 0.3;
    }else{
        _commitBtn.backgroundColor = ISNightMode?JSColor(@"#373737"):kDarkThreeColor;
        _commitBtn.layer.shadowOpacity = 0.0;
    }
}

/**获取验证码*/
- (void)getCodeBtnClicked:(UIButton *)sender
{
    if (![[JstyleToolManager sharedManager] isMobileNumber:_mobileField.text]) {
        ZTShowAlertMessage(@"手机号格式不正确");
        return;
    }
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSDictionary *parameters = @{@"mobile":_mobileField.text,
                                 @"type":@"2"};
    [[JstyleNewsNetworkManager shareManager] POSTURL:GET_CODE_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            [self godeNumberMinus];
        }
        ZTShowAlertMessage(responseObject[@"data"]);
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

/**验证码倒计时*/
- (void)godeNumberMinus
{
    __block int timeout = 120; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                [_getCodeBtn setTitleColor:kLightBlueColor forState:(UIControlStateNormal)];
                _getCodeBtn.userInteractionEnabled = YES;
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"倒计时%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                _getCodeBtn.titleLabel.text = strTime;
                [_getCodeBtn setTitle:strTime forState:UIControlStateNormal];
                [_getCodeBtn setTitleColor:kDarkNineColor forState:(UIControlStateNormal)];
                _getCodeBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)commitBtnClicked:(UIButton *)sender
{
    if (![[JstyleToolManager sharedManager] isMobileNumber:_mobileField.text]) {
        ZTShowAlertMessage(@"手机号格式不正确");
        return;
    }
    if (!_codeField.text || [_codeField.text isEqualToString:@""]){
        ZTShowAlertMessage(@"请输入验证码");
        return;
    }
    if (![[JstyleToolManager sharedManager] isValidatePassword:_pwdField.text]) {
        ZTShowAlertMessage(@"密码为6-20位数字和字母组合");
        return;
    }
    [self postPhoneAndCodeAndPwd];
}

/**
 * 发送找回请求
 */
- (void)postPhoneAndCodeAndPwd
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *pwd = [NSString getMD5StringFromString:[NSString getMD5StringFromString:_pwdField.text]];
    NSDictionary *parameters = @{@"mobile":_mobileField.text,
                                 @"code":_codeField.text,
                                 @"password":pwd,
                                 @"type":@"2"};
    [[JstyleNewsNetworkManager shareManager] POSTURL:FIND_PWD_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            _findPwdBlock(_mobileField.text, _pwdField.text);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        [SVProgressHUD dismiss];
        ZTShowAlertMessage(responseObject[@"data"]);
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_mobileField resignFirstResponder];
    [_codeField resignFirstResponder];
    [_pwdField resignFirstResponder];
}

- (void)leftBarButtonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
