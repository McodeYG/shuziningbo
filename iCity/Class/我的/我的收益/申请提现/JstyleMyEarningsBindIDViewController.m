//
//  JstyleMyEarningsBindIDViewController.m
//  Exquisite
//
//  Created by JingHongMuYun on 2018/3/6.
//  Copyright © 2018年 JstyleStar. All rights reserved.
//

#import "JstyleMyEarningsBindIDViewController.h"
#import "JstyleCashWithdrawalsViewController.h"
#import "JstyleDifferentAgreementViewController.h"

@interface JstyleMyEarningsBindIDViewController ()

@property (nonatomic, strong) UITextField *nameField;

@property (nonatomic, strong) UITextField *IDCardField;

@property (nonatomic, strong) UIButton *commitBtn;

@end

@implementation JstyleMyEarningsBindIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"身份证信息";
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
    [_nameField resignFirstResponder];
    [_IDCardField resignFirstResponder];
}

- (void)setUpViews
{
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"姓名";
    nameLabel.textColor = kDarkThreeColor;
    nameLabel.font = JSFont(13);
    [self.view addSubview:nameLabel];
    nameLabel.sd_layout
    .leftSpaceToView(self.view, 15)
    .topSpaceToView(self.view, 26 + YG_StatusAndNavightion_H)
    .widthIs(200)
    .heightIs(18);
    
    _nameField = [[UITextField alloc] init];
    _nameField.backgroundColor = kWhiteColor;
    _nameField.font = JSFont(13);
    _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameField.attributedPlaceholder = [@"请输入您的姓名" attributedColorStringWithTextColor:JSColor(@"#BFBFBF") font:JSFont(13)];
    _nameField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 6, 0)];
    _nameField.leftViewMode = UITextFieldViewModeAlways;
    _nameField.textColor = kDarkTwoColor;
    [_nameField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_nameField];
    _nameField.sd_layout
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .topSpaceToView(nameLabel, 10)
    .heightIs(40);
    
    UILabel *IDCardLabel = [[UILabel alloc] init];
    IDCardLabel.text = @"身份证号";
    IDCardLabel.textColor = kDarkThreeColor;
    IDCardLabel.font = JSFont(13);
    [self.view addSubview:IDCardLabel];
    IDCardLabel.sd_layout
    .leftSpaceToView(self.view, 15)
    .topSpaceToView(_nameField, 20)
    .widthIs(200)
    .heightIs(18);
    
    _IDCardField = [[UITextField alloc] init];
    _IDCardField.backgroundColor = kWhiteColor;
    _IDCardField.font = JSFont(13);
    _IDCardField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _IDCardField.attributedPlaceholder = [@"请输入您的身份证号" attributedColorStringWithTextColor:JSColor(@"#BFBFBF") font:JSFont(13)];
    _IDCardField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 6, 0)];
    _IDCardField.leftViewMode = UITextFieldViewModeAlways;
    _IDCardField.textColor = kDarkTwoColor;
    [_IDCardField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_IDCardField];
    _IDCardField.sd_layout
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .topSpaceToView(IDCardLabel, 10)
    .heightIs(40);
    
    UILabel *agreementLabel = [[UILabel alloc] init];
    agreementLabel.userInteractionEnabled = YES;
    NSString *text = @"此操作只为使您的提现符合我国相关规定，数字宁波承诺遵守《服务和隐私条款》保护您的隐私数据";
    agreementLabel.textColor = kDarkNineColor;
    agreementLabel.font = JSFont(12);
    agreementLabel.attributedText = [text attributedStringWithlineSpace:5 range:NSMakeRange(31, 9) textAlignment:NSTextAlignmentNatural textColor:JSColor(@"#7293BF") textFont:JSFont(12)];
    [self.view addSubview:agreementLabel];
    agreementLabel.isAttributedContent = YES;
    agreementLabel.sd_layout
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .topSpaceToView(_IDCardField, 10)
    .autoHeightRatio(0);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [agreementLabel addGestureRecognizer:tap];
    
    _commitBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _commitBtn.backgroundColor = JSColor(@"#EEEEEE");
    _commitBtn.titleLabel.font = JSFont(15);
    _commitBtn.layer.cornerRadius = 20;
    _commitBtn.userInteractionEnabled = NO;
    [_commitBtn setTitle:@"提交" forState:(UIControlStateNormal)];
    [_commitBtn setTitleColor:JSColor(@"BDBDBD") forState:(UIControlStateNormal)];
    [_commitBtn addTarget:self action:@selector(commitBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_commitBtn];
    _commitBtn.sd_layout
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .topSpaceToView(agreementLabel, 50)
    .heightIs(40);
}

- (void)textFieldTextChange:(UITextField *)textField
{
    if ((_nameField.text.length > 0) &&(_IDCardField.text.length > 0)) {
        _commitBtn.backgroundColor = JSColor(@"#FB655E");
        [_commitBtn setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
        _commitBtn.userInteractionEnabled = YES;
    }else{
        _commitBtn.backgroundColor = JSColor(@"#EEEEEE");
        [_commitBtn setTitleColor:JSColor(@"BDBDBD") forState:(UIControlStateNormal)];
        _commitBtn.userInteractionEnabled = NO;
    }
}

/**绑定手机号*/
- (void)bindIDCardDataSource
{
    [SVProgressHUD setBackgroundColor:kDarkSixColor];
    [SVProgressHUD setForegroundColor:kWhiteColor];
    [SVProgressHUD showWithStatus:@"绑定中..."];
    NSDictionary *parameters = @{@"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"name":_nameField.text,
                                 @"idcards":_IDCardField.text};
    [[JstyleNewsNetworkManager shareManager] POSTURL:VIP_BIND_NAMEID_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            JstyleCashWithdrawalsViewController *jstyleCashWVC = [JstyleCashWithdrawalsViewController new];
            [self.navigationController pushViewController:jstyleCashWVC animated:YES];
        }
        ZTShowAlertMessage(responseObject[@"data"]);
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)commitBtnClicked:(UIButton *)sender
{
    if (_nameField.text == nil || [[_nameField.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        ZTShowAlertMessage(@"请输入您的姓名");
        return;
    }
    if (![[JstyleToolManager sharedManager] isIdentityCard:_IDCardField.text]) {
        ZTShowAlertMessage(@"身份证号码不正确");
        return;
    }
    [_nameField resignFirstResponder];
    [_IDCardField resignFirstResponder];
    ZTAlertView *alertView = [[ZTAlertView alloc] initWithTitle:nil message:@"认证信息将用于您的绑定和提现（即绑定的支付宝必须是认证信息名下的支付宝）,目前暂不支持更改认证信息，请务必谨慎填写" sureBtn:@"确认" cancleBtn:@"返回修改"];
    alertView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            [self bindIDCardDataSource];
        }
    };
    [alertView show];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_nameField resignFirstResponder];
    [_IDCardField resignFirstResponder];
}

- (void)tapAction
{
    JstyleDifferentAgreementViewController *webView = [[JstyleDifferentAgreementViewController alloc] init];
    webView.urlStr = @"http://app.jstyle.cn/newwap/index.php/home/active/yinsi_agreement";
    [self.navigationController pushViewController:webView animated:YES];
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




