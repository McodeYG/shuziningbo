//
//  JstyleNewsChangeMobileLastViewController.m
//  JstyleNews
//
//  Created by 数字跃动 on 2018/1/17.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsChangeMobileLastViewController.h"
#import "JstyleNewsChangeMobileSuccessViewController.h"

@interface JstyleNewsChangeMobileLastViewController ()

@property (nonatomic, strong) UIButton *getCodeBtn;
@property (nonatomic, strong) UITextField *codeField;
@property (nonatomic, weak) UIButton *doneBtn;


@end

@implementation JstyleNewsChangeMobileLastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"改绑手机号";
    
    [self setupUI];
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
    
    _codeField = [[UITextField alloc] init];
    _codeField.textColor = ISNightMode?kDarkNineColor:kDarkThreeColor;
    _codeField.font = JSFont(13);
    _codeField.keyboardType = UIKeyboardTypeNumberPad;
    _codeField.attributedPlaceholder = [@"请输入验证码" attributedColorStringWithTextColor:kDarkNineColor font:JSFont(13)];
    _codeField.tintColor = kLightBlueColor;
    [_codeField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_codeField];
    [_codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label);
        make.top.equalTo(label.mas_bottom).offset(48);
        make.right.offset(-30);
        make.height.offset(18);
    }];
    
    _getCodeBtn = [[UIButton alloc] init];
    _getCodeBtn.titleLabel.font = JSFont(12);
    [_getCodeBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    [_getCodeBtn setTitleColor:kLightBlueColor forState:(UIControlStateNormal)];
    [_getCodeBtn addTarget:self action:@selector(getCodeBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [_getCodeBtn sizeToFit];
    [self.view addSubview:_getCodeBtn];
    [_getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_codeField);
        make.right.equalTo(_codeField.mas_right).offset(-3);
    }];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = ISNightMode?kDarkNineColor:JSColor(@"#E6E6E6");
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.codeField);
        make.top.equalTo(self.codeField.mas_bottom).offset(14);
        make.height.offset(0.5);
    }];
    
    UIButton *doneBtn = [UIButton buttonWithTitle:@"完成" normalTextColor:kWhiteColor selectedTextColor:kWhiteColor titleFontSize:16 target:self action:@selector(doneBtnClick:)];
    self.doneBtn = doneBtn;
    [doneBtn setBackgroundColor:kDarkThreeColor];
    doneBtn.layer.cornerRadius = 38 / 2.0;
    doneBtn.layer.shadowColor = kPinkColor.CGColor;
    doneBtn.layer.shadowOffset = CGSizeMake(- 2, 10);
    doneBtn.layer.shadowRadius = 10;
    [self.view addSubview:doneBtn];
    [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(line1);
        make.height.offset(38);
        make.top.equalTo(line1).offset(105);
    }];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)textFieldTextChange:(UITextField *)textField
{
    if (self.codeField.text.length > 0) {
        self.doneBtn.backgroundColor = kPinkColor;
        self.doneBtn.layer.shadowOpacity = 0.3;
    }else{
        self.doneBtn.backgroundColor = kDarkThreeColor;
        self.doneBtn.layer.shadowOpacity = 0.0;
    }
}

- (void)doneBtnClick:(UIButton *)sender {
    
    if (self.codeField.text == nil || [self.codeField.text isEqualToString:@""]) {
        ZTShowAlertMsgWithAlignment(@"请填写验证码", AlertMessageAlignmentBottom);
        return;
    }
    
    [self changeMobileBind];
    
}

- (void)changeMobileBind {
    
    NSDictionary *paramaters = @{
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"new_phone":self.mobileString,
                                 @"old_phone":self.oldPhoneString,
                                 @"code":self.codeField.text
                                 };
    
    [[JstyleNewsNetworkManager shareManager] POSTURL:MOBILE_CHANGE_BIND_URL parameters:paramaters success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            JstyleNewsChangeMobileSuccessViewController *successVC = [JstyleNewsChangeMobileSuccessViewController new];
            [self.navigationController pushViewController:successVC animated:YES];
        } else {
            ZTShowAlertMsgWithAlignment(responseObject[@"data"], AlertMessageAlignmentBottom);
        }
        
    } failure:^(NSError *error) {
        ZTShowAlertMessage(@"绑定失败，请稍后再试");
    }];
    
}

/**获取验证码*/
- (void)getCodeBtnClicked:(UIButton *)sender
{
    [SVProgressHUD showWithStatus:@"正在发送"];
    NSDictionary *parameters = @{@"mobile":self.mobileString,
                                 @"type":@"3"};
    
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}

@end
