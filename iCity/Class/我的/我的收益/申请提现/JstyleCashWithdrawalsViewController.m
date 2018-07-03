//
//  JstyleCashWithdrawalsViewController.m
//  Exquisite
//
//  Created by JingHongMuYun on 2018/3/6.
//  Copyright © 2018年 JstyleStar. All rights reserved.
//

#import "JstyleCashWithdrawalsViewController.h"

@interface JstyleCashWithdrawalsViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UITextField *zhifubaoField;

@property (nonatomic, strong) UITextField *moneyField;

@property (nonatomic, strong) UIButton *commitBtn;

@property (nonatomic, copy) NSString *totalIncome;

@property (nonatomic, copy) NSString *cashIncome;

@end

@implementation JstyleCashWithdrawalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请提现";
    self.view.backgroundColor = JSColor(@"#F7F7F7");
    [self setUpViews];
    [self loadJstyleDetailData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_zhifubaoField resignFirstResponder];
    [_moneyField resignFirstResponder];
}

- (void)setUpViews
{
    UIImageView *headerImageView = [[UIImageView alloc] init];
    headerImageView.image = JSImage(@"提现背景扁");
    [self.view addSubview:headerImageView];
    headerImageView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view, YG_StatusAndNavightion_H - 1)
    .heightIs(110);
    
    UILabel *headerLabel1 = [[UILabel alloc] init];
    headerLabel1.text = @"提现到支付宝";
    headerLabel1.textColor = JSColor(@"#F3EDE5");
    headerLabel1.textAlignment = NSTextAlignmentLeft;
    headerLabel1.font = JSFontWithWeight(13, UIFontWeightRegular);
    [headerImageView addSubview:headerLabel1];
    headerLabel1.sd_layout
    .leftSpaceToView(headerImageView, 15)
    .rightSpaceToView(headerImageView, 15)
    .topSpaceToView(headerImageView, 15)
    .heightIs(18);
    
    UILabel *headerLabel2 = [[UILabel alloc] init];
    headerLabel2.text = @"可提现金额";
    headerLabel2.textColor = JSColor(@"#F3EDE5");
    headerLabel2.textAlignment = NSTextAlignmentCenter;
    headerLabel2.font = JSFont(13);
    [headerImageView addSubview:headerLabel2];
    headerLabel2.sd_layout
    .leftSpaceToView(headerImageView, 15)
    .rightSpaceToView(headerImageView, 15)
    .topSpaceToView(headerLabel1, 5)
    .heightIs(18);
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.text = @"300.00";
    _moneyLabel.textColor = kWhiteColor;
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    _moneyLabel.font = JSFont(28);
    [headerImageView addSubview:_moneyLabel];
    _moneyLabel.sd_layout
    .leftSpaceToView(headerImageView, 15)
    .rightSpaceToView(headerImageView, 15)
    .topSpaceToView(headerLabel2, 2)
    .heightIs(34);
    
    UILabel *zhifubaoLabel = [[UILabel alloc] init];
    zhifubaoLabel.text = @"提现账户";
    zhifubaoLabel.textColor = kDarkThreeColor;
    zhifubaoLabel.font = JSFont(13);
    [self.view addSubview:zhifubaoLabel];
    zhifubaoLabel.sd_layout
    .leftSpaceToView(self.view, 15)
    .topSpaceToView(headerImageView, 20)
    .widthIs(200)
    .heightIs(18);
    
    _zhifubaoField = [[UITextField alloc] init];
    _zhifubaoField.backgroundColor = kWhiteColor;
    _zhifubaoField.font = JSFont(13);
    _zhifubaoField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _zhifubaoField.attributedPlaceholder = [@"请输入您的支付宝账户" attributedColorStringWithTextColor:JSColor(@"#BFBFBF") font:JSFont(13)];
    _zhifubaoField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 6, 0)];
    _zhifubaoField.leftViewMode = UITextFieldViewModeAlways;
    _zhifubaoField.textColor = kDarkTwoColor;
    _zhifubaoField.delegate = self;
    _zhifubaoField.returnKeyType = UIReturnKeyDone;
    [_zhifubaoField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_zhifubaoField];
    _zhifubaoField.sd_layout
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .topSpaceToView(zhifubaoLabel, 10)
    .heightIs(40);
    
    UILabel *cashLabel = [[UILabel alloc] init];
    cashLabel.text = @"提现金额";
    cashLabel.textColor = kDarkThreeColor;
    cashLabel.font = JSFont(13);
    [self.view addSubview:cashLabel];
    cashLabel.sd_layout
    .leftSpaceToView(self.view, 15)
    .topSpaceToView(_zhifubaoField, 20)
    .widthIs(200)
    .heightIs(18);
    
    _moneyField = [[UITextField alloc] init];
    _moneyField.backgroundColor = kWhiteColor;
    _moneyField.font = JSFont(13);
    _moneyField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _moneyField.attributedPlaceholder = [@"请输入要提现的金额（单位：元）" attributedColorStringWithTextColor:JSColor(@"#BFBFBF") font:JSFont(13)];
    _moneyField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 6, 0)];
    _moneyField.leftViewMode = UITextFieldViewModeAlways;
    _moneyField.textColor = kDarkTwoColor;
    _moneyField.delegate = self;
    _moneyField.returnKeyType = UIReturnKeyDone;
    [_moneyField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_moneyField];
    _moneyField.sd_layout
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .topSpaceToView(cashLabel, 10)
    .heightIs(40);
    
    UILabel *tishiLabel = [[UILabel alloc] init];
    tishiLabel.text = @"每笔提现最低1元，请确认支付宝账号是否输入正确";
    tishiLabel.textColor = kDarkNineColor;
    tishiLabel.font = JSFont(12);
    [self.view addSubview:tishiLabel];
    tishiLabel.sd_layout
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .topSpaceToView(_moneyField, 10)
    .autoHeightRatio(0);
    
    _commitBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _commitBtn.backgroundColor = JSColor(@"#EEEEEE");
    _commitBtn.titleLabel.font = JSFont(15);
    _commitBtn.layer.cornerRadius = 20;
    _commitBtn.userInteractionEnabled = NO;
    [_commitBtn setTitle:@"申请提现" forState:(UIControlStateNormal)];
    [_commitBtn setTitleColor:JSColor(@"BDBDBD") forState:(UIControlStateNormal)];
    [_commitBtn addTarget:self action:@selector(commitBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_commitBtn];
    _commitBtn.sd_layout
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .topSpaceToView(tishiLabel, 50)
    .heightIs(40);
}

- (void)textFieldTextChange:(UITextField *)textField
{
    if ((_zhifubaoField.text.length > 0) &&(_moneyField.text.length > 0)) {
        _commitBtn.backgroundColor = JSColor(@"#FB655E");
        [_commitBtn setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
        _commitBtn.userInteractionEnabled = YES;
    }else{
        _commitBtn.backgroundColor = JSColor(@"#EEEEEE");
        [_commitBtn setTitleColor:JSColor(@"BDBDBD") forState:(UIControlStateNormal)];
        _commitBtn.userInteractionEnabled = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_zhifubaoField resignFirstResponder];
    [_moneyField resignFirstResponder];
    return YES;
}

- (void)commitBtnClicked:(UIButton *)sender
{
    if (_zhifubaoField.text == nil || [[_zhifubaoField.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        ZTShowAlertMessage(@"请输入您的支付宝账号");
        return;
    }
    if (_moneyField.text == nil || [[_moneyField.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        ZTShowAlertMessage(@"请输入提现的金额");
        return;
    }
    if (![self isNumber:[self.moneyField.text stringByReplacingOccurrencesOfString:@" " withString:@""]]) {
        ZTShowAlertMessage(@"输入金额格式不正确");
        return;
    }
    if ([self.moneyField.text integerValue] > [self.cashIncome integerValue]) {
        ZTShowAlertMessage(@"输入金额超出可提现额度，请重新填写");
        return;
    }
    [self getCashWithdrawalsData];
}

#pragma mark - 获取数据
- (void)loadJstyleDetailData
{
    NSDictionary *parameters = @{@"uid":[[JstyleToolManager sharedManager] getUserId]};
    [[JstyleNewsNetworkManager shareManager] POSTURL:VIP_IS_BINDED_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] != 1) {
            return;
        }
        self.totalIncome = [[responseObject objectForKey:@"data"] objectForKey:@"all_price"];
        self.cashIncome = [[responseObject objectForKey:@"data"] objectForKey:@"now_price"];
        self.moneyLabel.text = [NSString stringWithFormat:@"%@", self.cashIncome];
    } failure:^(NSError *error) {
        
    }];
}

- (void)getCashWithdrawalsData
{
    [SVProgressHUD setBackgroundColor:kDarkSixColor];
    [SVProgressHUD setForegroundColor:kWhiteColor];
    [SVProgressHUD showWithStatus:@"提交中..."];
    CGFloat price = [_moneyField.text floatValue];
    NSDictionary *parameters = @{@"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"account":_zhifubaoField.text,
                                 @"price":[NSString stringWithFormat:@"%.2f",price],
                                 @"trade_platform":@"1",
                                 @"account_type":@"1"};
    [[JstyleNewsNetworkManager shareManager] POSTURL:VIP_GET_CASH_URL parameters:parameters success:^(id responseObject) {
        ZTShowAlertMessage(responseObject[@"data"]);
        if ([responseObject[@"code"] integerValue] == 1) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_zhifubaoField resignFirstResponder];
    [_moneyField resignFirstResponder];
}

- (BOOL)isNumber:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
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


