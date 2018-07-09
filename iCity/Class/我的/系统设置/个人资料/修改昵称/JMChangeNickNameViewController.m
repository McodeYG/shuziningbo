//
//  JMChangeNickNameViewController.m
//  Exquisite
//
//  Created by 赵涛 on 16/5/7.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import "JMChangeNickNameViewController.h"

@interface JMChangeNickNameViewController ()

@property (nonatomic, strong) UITextField *nickNameField;

@end

@implementation JMChangeNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改昵称";
    self.view.backgroundColor = ISNightMode?kNightModeBackColor:kBackGroundColor;;
    [self addNickNameTextFieldAndCompleteBtn];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)addNickNameTextFieldAndCompleteBtn
{
    _nickNameField = [[UITextField alloc]initWithFrame:CGRectMake(0, YG_StatusAndNavightion_H, kScreenWidth, 53.5)];
    _nickNameField.backgroundColor = ISNightMode?kDarkNineColor:kWhiteColor;
    _nickNameField.tintColor = kDarkOneColor;
    _nickNameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    _nickNameField.leftViewMode = UITextFieldViewModeAlways;
    _nickNameField.placeholder = @"以英文或汉字开头,4-16个字符,不可以使用特殊符号";
    [_nickNameField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    
    UIView *singleLine1 = [[UIView alloc]initWithFrame:CGRectMake(0, _nickNameField.bottom, kScreenWidth, 0.5)];
    singleLine1.backgroundColor = kSingleLineColor;
    
    UIButton *completeBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, singleLine1.bottom + 30, kScreenWidth - 30, 45)];
    completeBtn.layer.cornerRadius = 2;
    completeBtn.layer.masksToBounds = YES;
    completeBtn.backgroundColor = [UIColor colorFromHexString:@"#D49008"];
    completeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    completeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [completeBtn setTitle:@"保存" forState:(UIControlStateNormal)];
    [completeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [completeBtn addTarget:self action:@selector(completeBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    [self.view addSubview:_nickNameField];
    [self.view addSubview:singleLine1];
    [self.view addSubview:completeBtn];
}
#pragma mark - 保存
- (void)completeBtnAction
{
    self.nickNameField.text = [self.nickNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if (self.nickNameField.text == nil || [self.nickNameField.text isEqualToString:@""]) {
        ZTShowAlertMessage(@"昵称不能为空");
    }else if ([self textLength:self.nickNameField.text] <= 4){
        ZTShowAlertMessage(@"请保证昵称长度正确");
    }else if ([self textLength:self.nickNameField.text] >= 16){
        ZTShowAlertMessage(@"请保证昵称长度正确");
    } else if ([NSString stringContainsEmoji:self.nickNameField.text]) {
        ZTShowAlertMessage(@"昵称不能含有表情等特殊字符");
    }else {
        [self.nickNameField resignFirstResponder];
        [self getJMChangeNickNameDataSource];
    }
}

//测量文字长度，汉字是2个，英文是1个
-(NSUInteger)textLength:(NSString *)text {
    
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    NSUInteger unicodeLength = asciiLength;
    return unicodeLength;
}

#pragma mark - 获取数据
- (void)getJMChangeNickNameDataSource
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[[JstyleToolManager sharedManager] getUserId],@"uid",self.nickNameField.text,@"nickname", nil];
    // 初始化Manager
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    [manager GET:MY_CHANGENICK_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictionary = responseObject;
        
        if ([dictionary[@"code"] isEqualToString:@"1"]) {
            //本地保存
            [[NSUserDefaults standardUserDefaults] setObject:self.nickNameField.text forKey:@"username"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        ZTShowAlertMessage(dictionary[@"data"]);
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nickNameField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
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
