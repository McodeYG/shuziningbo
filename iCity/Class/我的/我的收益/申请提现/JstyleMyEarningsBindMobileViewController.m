//
//  JstyleMyEarningsBindMobileViewController.m
//  Exquisite
//
//  Created by JingHongMuYun on 2018/3/6.
//  Copyright © 2018年 JstyleStar. All rights reserved.
//

#import "JstyleMyEarningsBindMobileViewController.h"
#import "JstyleMyEarningsBindIDViewController.h"

@interface JstyleMyEarningsBindMobileViewController ()

@property (nonatomic, strong) UITextField *mobileField;

@property (nonatomic, strong) UITextField *codeField;

@property (nonatomic, strong) UIButton *getCodeBtn;

@property (nonatomic, strong) UIButton *commitBtn;

@end

@implementation JstyleMyEarningsBindMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机号";
    self.view.backgroundColor = JSColor(@"#F7F7F7");
    [self setUpViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mobileField resignFirstResponder];
    [_codeField resignFirstResponder];
}

- (void)setUpViews
{
    UILabel *mobileLabel = [[UILabel alloc] init];
    mobileLabel.text = @"请输入手机号";
    mobileLabel.textColor = kDarkThreeColor;
    mobileLabel.font = JSFont(13);
    [self.view addSubview:mobileLabel];
    mobileLabel.sd_layout
    .leftSpaceToView(self.view, 15)
    .topSpaceToView(self.view, 26 + YG_StatusAndNavightion_H)
    .widthIs(200)
    .heightIs(18);
    
    _mobileField = [[UITextField alloc] init];
    _mobileField.backgroundColor = kWhiteColor;
    _mobileField.font = JSFont(13);
    _mobileField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 6, 0)];
    _mobileField.leftViewMode = UITextFieldViewModeAlways;
    _mobileField.keyboardType = UIKeyboardTypeNumberPad;
    _mobileField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //_mobileField.attributedPlaceholder = [@"请输入手机号" attributedColorStringWithTextColor:kDarkNineColor font:JSFont(13)];
    _mobileField.textColor = kDarkTwoColor;
    [_mobileField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_mobileField];
    _mobileField.sd_layout
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .topSpaceToView(mobileLabel, 10)
    .heightIs(40);
    
    _getCodeBtn = [[UIButton alloc] init];
    _getCodeBtn.titleLabel.font = JSFont(12);
    [_getCodeBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    [_getCodeBtn setTitleColor:JSColor(@"#BFBFBF") forState:(UIControlStateNormal)];
    _getCodeBtn.layer.borderColor = JSColor(@"#BFBFBF").CGColor;
    _getCodeBtn.layer.borderWidth = 1;
    _getCodeBtn.layer.cornerRadius = 3;
    _getCodeBtn.layer.masksToBounds = YES;
    [_getCodeBtn addTarget:self action:@selector(getCodeBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_getCodeBtn];
    _getCodeBtn.sd_layout
    .rightSpaceToView(self.view, 15)
    .topSpaceToView(_mobileField, 18)
    .widthIs(135)
    .heightIs(40);
    
    _codeField = [[UITextField alloc] init];
    _codeField.backgroundColor = kWhiteColor;
    _codeField.font = JSFont(13);
    _codeField.keyboardType = UIKeyboardTypeNumberPad;
    _codeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _codeField.attributedPlaceholder = [@"请输入验证码" attributedColorStringWithTextColor:JSColor(@"#BFBFBF") font:JSFont(13)];
    _codeField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 6, 0)];
    _codeField.leftViewMode = UITextFieldViewModeAlways;
    _codeField.textColor = kDarkTwoColor;
    [_codeField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_codeField];
    _codeField.sd_layout
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(_getCodeBtn, 15)
    .topSpaceToView(_mobileField, 18)
    .heightIs(40);
    
    _commitBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _commitBtn.backgroundColor = JSColor(@"#EEEEEE");
    _commitBtn.titleLabel.font = JSFont(15);
    _commitBtn.layer.cornerRadius = 20;
    _commitBtn.userInteractionEnabled = NO;
    [_commitBtn setTitle:@"立即绑定" forState:(UIControlStateNormal)];
    [_commitBtn setTitleColor:JSColor(@"BDBDBD") forState:(UIControlStateNormal)];
    [_commitBtn addTarget:self action:@selector(commitBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_commitBtn];
    _commitBtn.sd_layout
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .topSpaceToView(_codeField, 60)
    .heightIs(40);
}

- (void)textFieldTextChange:(UITextField *)textField
{
    if (_mobileField.text.length > 0) {
        [_getCodeBtn setTitleColor:JSColor(@"#FB655E") forState:(UIControlStateNormal)];
        _getCodeBtn.layer.borderColor = JSColor(@"#FB655E").CGColor;
        _commitBtn.backgroundColor = JSColor(@"#FB655E");
        [_commitBtn setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
        _commitBtn.userInteractionEnabled = YES;
    }else{
        [_getCodeBtn setTitleColor:JSColor(@"#BFBFBF") forState:(UIControlStateNormal)];
        _getCodeBtn.layer.borderColor = JSColor(@"#BFBFBF").CGColor;
        _commitBtn.backgroundColor = JSColor(@"#EEEEEE");
        [_commitBtn setTitleColor:JSColor(@"BDBDBD") forState:(UIControlStateNormal)];
        _commitBtn.userInteractionEnabled = NO;
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
                                 @"type":@"10"};
    
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
                if (_mobileField.text.length > 0) {
                    [_getCodeBtn setTitleColor:JSColor(@"#FB655E") forState:(UIControlStateNormal)];
                    _getCodeBtn.layer.borderColor = JSColor(@"#FB655E").CGColor;
                }else{
                    [_getCodeBtn setTitleColor:JSColor(@"#BFBFBF") forState:(UIControlStateNormal)];
                    _getCodeBtn.layer.borderColor = JSColor(@"#BFBFBF").CGColor;
                }
                _getCodeBtn.userInteractionEnabled = YES;
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"倒计时%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                _getCodeBtn.titleLabel.text = strTime;
                [_getCodeBtn setTitle:strTime forState:UIControlStateNormal];
                [_getCodeBtn setTitleColor:JSColor(@"#BFBFBF") forState:(UIControlStateNormal)];
                _getCodeBtn.layer.borderColor = JSColor(@"#BFBFBF").CGColor;
                _getCodeBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

/**绑定手机号*/
- (void)bindMobileDataSource
{
    [SVProgressHUD setBackgroundColor:kDarkSixColor];
    [SVProgressHUD setForegroundColor:kWhiteColor];
    [SVProgressHUD showWithStatus:@"绑定中..."];
    NSDictionary *parameters = @{@"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"mobile":_mobileField.text,
                                 @"code":_codeField.text};
    [[JstyleNewsNetworkManager shareManager] POSTURL:VIP_BIND_MOBILE_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            JstyleMyEarningsBindIDViewController *jstyleMyEarningBIVC = [JstyleMyEarningsBindIDViewController new];
            [self.navigationController pushViewController:jstyleMyEarningBIVC animated:YES];
        }
        ZTShowAlertMessage(responseObject[@"data"]);
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)commitBtnClicked:(UIButton *)sender
{
    if (![[JstyleToolManager sharedManager] isMobileNumber:_mobileField.text]) {
        ZTShowAlertMessage(@"手机号格式不正确");
        return;
    }
    if (!_codeField.text) {
        ZTShowAlertMessage(@"请输入验证码");
        return;
    }
    [self bindMobileDataSource];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_mobileField resignFirstResponder];
    [_codeField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
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



