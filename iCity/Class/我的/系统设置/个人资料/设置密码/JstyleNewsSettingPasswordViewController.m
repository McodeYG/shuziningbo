//
//  JstyleNewsSettingPasswordViewController.m
//  JstyleNews
//
//  Created by 数字跃动 on 2017/12/26.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsSettingPasswordViewController.h"
#import "NSString+MD5.h"

@interface JstyleNewsSettingPasswordViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *phoneNumTextField;
@property (nonatomic, strong) UITextField *validCodeTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *passwordAgainTextField;

@property (nonatomic, weak) UIButton *validCodeBtn;


@end

@implementation JstyleNewsSettingPasswordViewController

- (UITextField *)phoneNumTextField {
    if (_phoneNumTextField == nil) {
        _phoneNumTextField = [[UITextField alloc] init];
        _phoneNumTextField = [self settingTextFieldWithTextField:_phoneNumTextField placeholder:@"请输入手机号" isSecureTextEntry:NO returnKeyType:UIReturnKeyNext];
        _phoneNumTextField.textColor = ISNightMode?kDarkNineColor:kDarkThreeColor;
        _phoneNumTextField.keyboardType = UIKeyboardTypePhonePad;
    }
    return _phoneNumTextField;
}

- (UITextField *)validCodeTextField {
    if (_validCodeTextField == nil) {
        _validCodeTextField = [[UITextField alloc] init];
        _validCodeTextField = [self settingTextFieldWithTextField:_validCodeTextField placeholder:@"请输入验证码" isSecureTextEntry:NO returnKeyType:UIReturnKeyNext];
        _validCodeTextField.textColor = ISNightMode?kDarkNineColor:kDarkThreeColor;
        _validCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _validCodeTextField;
}

- (UITextField *)passwordAgainTextField {
    if (_passwordAgainTextField == nil) {
        _passwordAgainTextField = [[UITextField alloc] init];
        _passwordAgainTextField = [self settingTextFieldWithTextField:_passwordAgainTextField placeholder:@"请再次输入密码" isSecureTextEntry:YES returnKeyType:UIReturnKeyDone];
        _passwordAgainTextField.textColor = ISNightMode?kDarkNineColor:kDarkThreeColor;
    }
    return _passwordAgainTextField;
}

- (UITextField *)passwordTextField {
    if (_passwordTextField == nil) {
        _passwordTextField = [[UITextField alloc] init];
        _passwordTextField = [self settingTextFieldWithTextField:_passwordTextField placeholder:@"请输入密码" isSecureTextEntry:YES returnKeyType:UIReturnKeyNext];
        _passwordTextField.textColor = ISNightMode?kDarkNineColor:kDarkThreeColor;
    }
    return _passwordTextField;
}

///封装设置textField
- (UITextField *)settingTextFieldWithTextField:(UITextField *)textField placeholder:(NSString *)placeholder isSecureTextEntry:(BOOL)isSecureTextEntry returnKeyType:(UIReturnKeyType)returnKeyType {
    
    textField = [[UITextField alloc] init];
    textField.delegate = self;
    textField.borderStyle = UITextBorderStyleNone;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang SC" size:13],NSForegroundColorAttributeName:JSColor(@"#9E9E9E")}];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.secureTextEntry = isSecureTextEntry;
    textField.returnKeyType = returnKeyType;
    return textField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置密码";
    
    [self setupUI];
    [self addTapGesture];
}

- (void)setupUI {
    
    [self.view addSubview:self.phoneNumTextField];
    [self.phoneNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.top.offset(131+YG_StatusAndNavightion_H);
        make.height.offset(18);
    }];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = ISNightMode?kDarkNineColor:JSColor(@"#E6E6E6");
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.phoneNumTextField);
        make.top.equalTo(self.phoneNumTextField.mas_bottom).offset(14);
        make.height.offset(0.5);
    }];
    
    [self.view addSubview:self.validCodeTextField];
    [self.validCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(line1);
        make.top.equalTo(line1.mas_bottom).offset(17);
        make.height.offset(18);
    }];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = ISNightMode?kDarkNineColor:JSColor(@"#E6E6E6");
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.validCodeTextField);
        make.top.equalTo(self.validCodeTextField.mas_bottom).offset(14);
        make.height.offset(0.5);
    }];
    
    UIButton *validCodeBtn = [UIButton buttonWithTitle:@"获取验证码" normalTextColor:JSColor(@"#7293BF") selectedTextColor:JSColor(@"#7293BF") titleFontSize:12 target:self action:@selector(validCodeBtnClick:)];
    self.validCodeBtn = validCodeBtn;
    [validCodeBtn sizeToFit];
    [self.validCodeTextField addSubview:validCodeBtn];
    [validCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-5);
        make.centerY.offset(0);
    }];
    
    [self.view addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(line2);
        make.top.equalTo(line2.mas_bottom).offset(17);
        make.height.offset(18);
    }];
    
    UIView *line3 = [[UIView alloc] init];
    line3.backgroundColor = ISNightMode?kDarkNineColor:JSColor(@"#E6E6E6");
    [self.view addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.passwordTextField);
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(14);
        make.height.offset(0.5);
    }];
    
    [self.view addSubview:self.passwordAgainTextField];
    [self.passwordAgainTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(line3);
        make.top.equalTo(line3.mas_bottom).offset(17);
        make.height.offset(18);
    }];
    
    UIView *line4 = [[UIView alloc] init];
    line4.backgroundColor = ISNightMode?kDarkNineColor:JSColor(@"#E6E6E6");
    [self.view addSubview:line4];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.passwordAgainTextField);
        make.top.equalTo(self.passwordAgainTextField.mas_bottom).offset(14);
        make.height.offset(0.5);
    }];
    
    UIButton *doneBtn = [UIButton buttonWithTitle:@"完成" normalTextColor:kWhiteColor selectedTextColor:kWhiteColor titleFontSize:15 target:self action:@selector(doneBtnClick)];
    doneBtn.layer.cornerRadius = 48 / 2.0;
    doneBtn.layer.masksToBounds = YES;
    [doneBtn setBackgroundColor:JSColor(@"#373737")];
    [self.view addSubview:doneBtn];
    [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(38);
        make.right.offset(-38);
        make.height.offset(48);
        make.top.equalTo(line4.mas_bottom).offset(50);
    }];
    
}

- (void)addTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick)];
    [self.view addGestureRecognizer:tap];
}

- (void)tapGestureClick {
    [self.view endEditing:YES];
}

- (void)doneBtnClick {
    [self.view endEditing:YES];
    
    if (![self.passwordTextField.text isEqualToString:self.passwordAgainTextField.text]) {
        ZTShowAlertMessage(@"两次密码输入不一致");
        return;
    }
    
    [self uploadPassword];
}


/**获取验证码*/
- (void)validCodeBtnClick:(UIButton *)sender {
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSDictionary *parameters = @{@"mobile":self.phoneNumTextField.text,
                                 @"type":@"8"};
    
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
                [self.validCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self.validCodeBtn setTitleColor:kLightBlueColor forState:(UIControlStateNormal)];
                self.validCodeBtn.userInteractionEnabled = YES;
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"倒计时%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.validCodeBtn.titleLabel.text = strTime;
                [self.validCodeBtn setTitle:strTime forState:UIControlStateNormal];
                [self.validCodeBtn setTitleColor:kDarkNineColor forState:(UIControlStateNormal)];
                self.validCodeBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.phoneNumTextField) {
        return YES;
    } else if (textField == self.validCodeTextField) {
        return YES;
    } else if (textField == self.passwordTextField) {
        if (![[JstyleToolManager sharedManager] isValidatePassword:self.passwordTextField.text]) {
            ZTShowAlertMessage(@"密码格式不正确,请重新输入");
            return NO;
        } else {
            [self.passwordTextField resignFirstResponder];
            [self.passwordAgainTextField becomeFirstResponder];
            return YES;
        }
    } else {
        if (![[JstyleToolManager sharedManager] isValidatePassword:self.passwordAgainTextField.text]) {
            ZTShowAlertMessage(@"密码格式不正确,请重新输入");
            return NO;
        } else {
            [self.passwordAgainTextField resignFirstResponder];
            return YES;
        }
    }
}

- (void)uploadPassword {
    
    [SVProgressHUD showWithStatus:@"请稍后"];
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    NSDictionary *paramaters = @{
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"mobile":self.phoneNumTextField.text,
                                 @"password":[NSString getMD5StringFromString:[NSString getMD5StringFromString:self.passwordAgainTextField.text]],
                                 @"code":self.validCodeTextField.text
                                 };
    [manager POSTURL:JSYTLE_SET_PWD_URL parameters:paramaters success:^(id responseObject) {
        
        NSDictionary *dictionary = responseObject;
        
        [SVProgressHUD showWithStatus:dictionary[@"data"]];
        __weak typeof(self)weakSelf = self;
        if ([dictionary[@"code"] isEqualToString:@"1"]) {
            
            [SVProgressHUD dismissWithDelay:1 completion:^{
                [[NSUserDefaults standardUserDefaults] setObject:@"password" forKey:@"password"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            
        } else {
            [SVProgressHUD dismissWithDelay:1];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD dismissWithDelay:1];
    }];
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}

@end
