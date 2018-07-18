//
//  JstyleNewsChangePassworldViewController.m
//  JstyleNews
//
//  Created by 数字跃动 on 2017/12/25.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsChangePassworldViewController.h"
#import "NSString+MD5.h"

@interface JstyleNewsChangePassworldViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *oldPassworldTextField;
@property (nonatomic, strong) UITextField *newPassworldTextField;
@property (nonatomic, strong) UITextField *newPassworldAgainTextField;
@property (nonatomic, weak) UIButton *doneBtn;


@end

@implementation JstyleNewsChangePassworldViewController

- (UITextField *)oldPassworldTextField {
    if (_oldPassworldTextField == nil) {
        _oldPassworldTextField = [[UITextField alloc] init];
        _oldPassworldTextField.delegate = self;
        _oldPassworldTextField.borderStyle = UITextBorderStyleNone;
        _oldPassworldTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入原密码" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang SC" size:13],NSForegroundColorAttributeName:JSColor(@"#9E9E9E")}];
        _oldPassworldTextField.textColor = ISNightMode?kDarkNineColor:kDarkThreeColor;
        _oldPassworldTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _oldPassworldTextField.secureTextEntry = YES;
        _oldPassworldTextField.returnKeyType = UIReturnKeyNext;
        _oldPassworldTextField.keyboardAppearance = ISNightMode?UIKeyboardAppearanceDark:UIKeyboardAppearanceDefault;
        [_oldPassworldTextField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _oldPassworldTextField;
}

- (UITextField *)newPassworldTextField {
    if (_newPassworldTextField == nil) {
        _newPassworldTextField = [[UITextField alloc] init];
        _newPassworldTextField.delegate = self;
        _newPassworldTextField.borderStyle = UITextBorderStyleNone;
        _newPassworldTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码(6~20位)" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang SC" size:13],NSForegroundColorAttributeName:JSColor(@"#9E9E9E")}];
        _newPassworldTextField.textColor = ISNightMode?kDarkNineColor:kDarkThreeColor;
        _newPassworldTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _newPassworldTextField.secureTextEntry = YES;
        _newPassworldTextField.returnKeyType = UIReturnKeyNext;
        _newPassworldTextField.keyboardAppearance = ISNightMode?UIKeyboardAppearanceDark:UIKeyboardAppearanceDefault;
        [_newPassworldTextField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _newPassworldTextField;
}

- (UITextField *)newPassworldAgainTextField {
    if (_newPassworldAgainTextField == nil) {
        _newPassworldAgainTextField = [[UITextField alloc] init];
        _newPassworldAgainTextField.delegate = self;
        _newPassworldAgainTextField.borderStyle = UITextBorderStyleNone;
        _newPassworldAgainTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请再次输入密码(6~20位)" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang SC" size:13],NSForegroundColorAttributeName:JSColor(@"#9E9E9E")}];
        _newPassworldAgainTextField.textColor = ISNightMode?kDarkNineColor:kDarkThreeColor;
        _newPassworldAgainTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _newPassworldAgainTextField.secureTextEntry = YES;
        _newPassworldAgainTextField.returnKeyType = UIReturnKeyDone;
        _newPassworldAgainTextField.keyboardAppearance = ISNightMode?UIKeyboardAppearanceDark:UIKeyboardAppearanceDefault;
        [_newPassworldAgainTextField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _newPassworldAgainTextField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigation];
    
    [self setupUI];
}

- (void)setupNavigation {
    
    self.navigationItem.title = @"修改密码";
}

- (void)setupUI {
    
    [self.view addSubview:self.oldPassworldTextField];
    [self.oldPassworldTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.top.offset(131+YG_StatusAndNavightion_H);
        make.height.offset(18);
    }];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = ISNightMode?kDarkNineColor:JSColor(@"#E6E6E6");
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.oldPassworldTextField);
        make.top.equalTo(self.oldPassworldTextField.mas_bottom).offset(14);
        make.height.offset(0.5);
    }];
    
    [self.view addSubview:self.newPassworldTextField];
    [self.newPassworldTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(line1);
        make.top.equalTo(line1.mas_bottom).offset(17);
        make.height.offset(18);
    }];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = ISNightMode?kDarkNineColor:JSColor(@"#E6E6E6");
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.newPassworldTextField);
        make.top.equalTo(self.newPassworldTextField.mas_bottom).offset(14);
        make.height.offset(0.5);
    }];
    
    [self.view addSubview:self.newPassworldAgainTextField];
    [self.newPassworldAgainTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(line2);
        make.top.equalTo(line2.mas_bottom).offset(17);
        make.height.offset(18);
    }];
    
    UIView *line3 = [[UIView alloc] init];
    line3.backgroundColor = ISNightMode?kDarkNineColor:JSColor(@"#E6E6E6");
    [self.view addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.newPassworldAgainTextField);
        make.top.equalTo(self.newPassworldAgainTextField.mas_bottom).offset(14);
        make.height.offset(0.5);
    }];
    
    UIButton *doneBtn = [UIButton buttonWithTitle:@"完成" normalTextColor:kWhiteColor selectedTextColor:kWhiteColor titleFontSize:15 target:self action:@selector(doneBtnClick)];
    self.doneBtn = doneBtn;
    doneBtn.layer.cornerRadius = 48 / 2.0;
    doneBtn.layer.shadowColor = kPinkColor.CGColor;
    doneBtn.layer.shadowOffset = CGSizeMake(- 2, 10);
    doneBtn.layer.shadowRadius = 10;
    [doneBtn setBackgroundColor:JSColor(@"#373737")];
    [self.view addSubview:doneBtn];
    [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(38);
        make.right.offset(-38);
        make.height.offset(48);
        make.top.equalTo(line3.mas_bottom).offset(50);
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)doneBtnClick {
    [self.view endEditing:YES];
    

    if ([self.oldPassworldTextField.text isEqualToString:self.newPassworldTextField.text]) {
        ZTShowAlertMessage(@"两次密码输入不能一致");
        return;
    }
    
    if (![self.newPassworldTextField.text isEqualToString:self.newPassworldAgainTextField.text]) {
        ZTShowAlertMessage(@"两次密码输入不一致");
        return;
    }
    if (self.newPassworldTextField.text.length<6) {
        ZTShowAlertMessage(@"密码不能低于六位！");
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在验证"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    [self updatePassworld];
    
}

- (void)updatePassworld {
    
    JstyleToolManager *tool = [JstyleToolManager sharedManager];
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    NSDictionary *paramaters = @{
                                 @"uid":[tool getUserId],
                                 @"oldpwd":[NSString getMD5StringFromString:[NSString getMD5StringFromString:self.oldPassworldTextField.text]],
                                 @"newpwd":[NSString getMD5StringFromString:[NSString getMD5StringFromString:self.newPassworldAgainTextField.text]]
                                 };
    [manager GETURL:CHANGE_PWD_URL parameters:paramaters success:^(id responseObject) {
       
        NSDictionary *dictionary = responseObject;
        
        __weak typeof(self)weakSelf = self;
        if ([dictionary[@"code"] isEqualToString:@"1"]) {
            
            [SVProgressHUD showWithStatus:dictionary[@"data"]];
            [SVProgressHUD dismissWithDelay:1 completion:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            [SVProgressHUD showWithStatus:dictionary[@"data"]];
            [SVProgressHUD dismissWithDelay:1];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - UITextfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.oldPassworldTextField) {
        if (![[JstyleToolManager sharedManager] isValidatePassword:self.oldPassworldTextField.text]) {
            ZTShowAlertMessage(@"密码格式不正确,请重新输入");
            return NO;
        } else {
            [self.oldPassworldTextField resignFirstResponder];
            [self.newPassworldTextField becomeFirstResponder];
            return YES;
        }
    } else if (textField == self.newPassworldTextField) {
        if (![[JstyleToolManager sharedManager] isValidatePassword:self.newPassworldTextField.text]) {
            ZTShowAlertMessage(@"密码格式不正确,请重新输入");
            return NO;
        } else {
            [self.newPassworldTextField resignFirstResponder];
            [self.newPassworldAgainTextField becomeFirstResponder];
            return YES;
        }
    } else {
        if (![[JstyleToolManager sharedManager] isValidatePassword:self.newPassworldAgainTextField.text]) {
            ZTShowAlertMessage(@"密码格式不正确,请重新输入");
            return NO;
        } else {
            [self.newPassworldAgainTextField resignFirstResponder];
            return YES;
        }
    }
}

- (void)textFieldTextChange:(UITextField *)textField
{
    if ((self.oldPassworldTextField.text.length > 0) && (self.newPassworldTextField.text.length > 0) &&  (self.newPassworldAgainTextField.text.length > 0)) {
        self.doneBtn.backgroundColor = kPinkColor;
        self.doneBtn.layer.shadowOpacity = 0.3;
    }else{
        self.doneBtn.backgroundColor = kDarkThreeColor;
        self.doneBtn.layer.shadowOpacity = 0.0;
    }
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}

@end
