//
//  JstyleNewsChangeMobileDetailViewController.m
//  JstyleNews
//
//  Created by 数字跃动 on 2018/1/17.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsChangeMobileDetailViewController.h"
#import "JstyleNewsChangeMobileLastViewController.h"

@interface JstyleNewsChangeMobileDetailViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *oldMobileTextField;
@property (nonatomic, strong) UITextField *newMobileTextField;
@property (nonatomic, weak) UIButton *nextBtn;


@end

@implementation JstyleNewsChangeMobileDetailViewController

- (UITextField *)oldMobileTextField {
    if (_oldMobileTextField == nil) {
        _oldMobileTextField = [[UITextField alloc] init];
        _oldMobileTextField.delegate = self;
        _oldMobileTextField.borderStyle = UITextBorderStyleNone;
        _oldMobileTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入当前手机号" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang SC" size:13],NSForegroundColorAttributeName:JSColor(@"#9E9E9E")}];
        _oldMobileTextField.textColor = ISNightMode?kDarkNineColor:kDarkThreeColor;
        _oldMobileTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _oldMobileTextField.returnKeyType = UIReturnKeyNext;
        _oldMobileTextField.keyboardAppearance = ISNightMode?UIKeyboardAppearanceDark:UIKeyboardAppearanceDefault;
        _oldMobileTextField.keyboardType = UIKeyboardTypePhonePad;
        [_oldMobileTextField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _oldMobileTextField;
}

- (UITextField *)newMobileTextField {
    if (_newMobileTextField == nil) {
        _newMobileTextField = [[UITextField alloc] init];
        _newMobileTextField.delegate = self;
        _newMobileTextField.borderStyle = UITextBorderStyleNone;
        _newMobileTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入新手机号" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang SC" size:13],NSForegroundColorAttributeName:JSColor(@"#9E9E9E")}];
        _newMobileTextField.textColor = ISNightMode?kDarkNineColor:kDarkThreeColor;
        _newMobileTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _newMobileTextField.returnKeyType = UIReturnKeyNext;
        _newMobileTextField.keyboardAppearance = ISNightMode?UIKeyboardAppearanceDark:UIKeyboardAppearanceDefault;
        _newMobileTextField.keyboardType = UIKeyboardTypePhonePad;
        [_newMobileTextField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _newMobileTextField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"改绑手机号";
    
    [self setupUI];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)setupUI {
    
    UILabel *label = [UILabel labelWithColor:ISNightMode?kDarkNineColor:JSColor(@"#2A2A2A") fontSize:13 text:@"* 更换绑定的手机号之后可以用新的手机号验证登录" alignment:NSTextAlignmentLeft];
    label.attributedText = [@"* 更换绑定的手机号之后可以用新的手机号验证登录" attributedStringWithTextColor:JSColor(@"#EE6767") range:NSMakeRange(0, 1) textFont:15];
    [label sizeToFit];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.top.offset(63.5 + YG_StatusAndNavightion_H);
    }];
    
    [self.view addSubview:self.oldMobileTextField];
    [self.oldMobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label);
        make.right.offset(-30);
        make.top.equalTo(label.mas_bottom).offset(45);
        make.height.offset(18);
    }];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = ISNightMode?kDarkNineColor:JSColor(@"#E6E6E6");
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.oldMobileTextField);
        make.top.equalTo(self.oldMobileTextField.mas_bottom).offset(14);
        make.height.offset(0.5);
    }];
    
    [self.view addSubview:self.newMobileTextField];
    [self.newMobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label);
        make.right.offset(-30);
        make.top.equalTo(line1.mas_bottom).offset(17);
        make.height.offset(18);
    }];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = ISNightMode?kDarkNineColor:JSColor(@"#E6E6E6");
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.newMobileTextField);
        make.top.equalTo(self.newMobileTextField.mas_bottom).offset(14);
        make.height.offset(0.5);
    }];
    
    UIButton *nextBtn = [UIButton buttonWithTitle:@"下一步" normalTextColor:kWhiteColor selectedTextColor:kWhiteColor titleFontSize:16 target:self action:@selector(nextBtnClick:)];
    self.nextBtn = nextBtn;
    [nextBtn setBackgroundColor:kDarkThreeColor];
    nextBtn.layer.cornerRadius = 38 / 2.0;
    nextBtn.layer.shadowColor = kPinkColor.CGColor;
    nextBtn.layer.shadowOffset = CGSizeMake(- 2, 10);
    nextBtn.layer.shadowRadius = 10;
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(line2);
        make.height.offset(38);
        make.top.equalTo(line2).offset(51);
    }];
    
}

- (void)nextBtnClick:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    if (![[JstyleToolManager sharedManager] isMobileNumber:self.newMobileTextField.text] || ![[JstyleToolManager sharedManager] isMobileNumber:self.oldMobileTextField.text]) {
        ZTShowAlertMsgWithAlignment(@"手机号格式不正确", AlertMessageAlignmentBottom);
        return;
    }
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    if (![self.oldMobileTextField.text isEqualToString:phone]) {
        ZTShowAlertMsgWithAlignment(@"原手机号不正确", AlertMessageAlignmentBottom);
        return;
    }
    
    if ([self.oldMobileTextField.text isEqualToString:self.newMobileTextField.text]) {
        ZTShowAlertMsgWithAlignment(@"两个手机号码不能一样", AlertMessageAlignmentBottom);
        return;
    }
    
    //验证手机号
    JstyleNewsChangeMobileLastViewController *lastVC = [JstyleNewsChangeMobileLastViewController new];
    lastVC.oldPhoneString = self.oldMobileTextField.text;
    lastVC.mobileString = self.newMobileTextField.text;
    [self.navigationController pushViewController:lastVC animated:YES];
}

- (void)textFieldTextChange:(UITextField *)textField
{
    if ((self.oldMobileTextField.text.length == 11) && (self.newMobileTextField.text.length == 11)) {
        self.nextBtn.backgroundColor = kPinkColor;
        self.nextBtn.layer.shadowOpacity = 0.3;
    }else{
        self.nextBtn.backgroundColor = kDarkThreeColor;
        self.nextBtn.layer.shadowOpacity = 0.0;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}

@end
