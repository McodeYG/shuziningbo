//
//  JMFeedbackMessageViewController.m
//  Exquisite
//
//  Created by 数字宁波 on 16/6/18.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import "JMFeedbackMessageViewController.h"
#import "JMFeedBackViewCell.h"

//#define  kMenuArray    @[@"APP使用反馈",@"商品反馈",@"订单反馈",@"物流反馈",@"直播反馈",@"文章反馈"]
#define  kMenuArray    @[]
//UITableViewDelegate,UITableViewDataSource
@interface JMFeedbackMessageViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UILabel *characterLabel;

@property (nonatomic, strong) UITextField *phoneNum;

@property (nonatomic, strong) UILabel *placeHolder;

//@property (nonatomic, strong) UIButton *feedbackTypeBtn;

@property (nonatomic, strong) UIImageView *feedbackImageView;

//@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL feedbackTypeBtnIsSelected;

@property (nonatomic, copy) NSString *menuSelectedType;

/**截取*/
@property (nonatomic, assign) int subNumber;

@end

@implementation JMFeedbackMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"意见反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addTextViewAndPhoneNum];
    
    //    [self addTableView];
    
    self.feedbackTypeBtnIsSelected = NO;
    self.menuSelectedType = @"0";
}

- (void)addTextViewAndPhoneNum
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *feedbackTypeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 180, 44)];
    feedbackTypeLab.font = [UIFont systemFontOfSize:16];
    feedbackTypeLab.textColor = kDarkTwoColor;
    
    NSMutableAttributedString * text = [[NSMutableAttributedString alloc]initWithString:@"＊问题描述和建议"];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
    feedbackTypeLab.attributedText = text;
    
    //    _feedbackTypeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 145, 0, 120, 44)];
    //    [_feedbackTypeBtn setEnlargeEdgeWithTop:0 right:20 bottom:0 left:0];
    //    _feedbackTypeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    //    _feedbackTypeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //    [_feedbackTypeBtn setTitle:@"APP使用反馈" forState:(UIControlStateNormal)];
    //    [_feedbackTypeBtn setTitleColor:kDarkTwoColor forState:(UIControlStateNormal)];
    //    [_feedbackTypeBtn addTarget:self action:@selector(feedbackTypeBtnDidClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    //
    //    _feedbackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 18, 18, 10, 8)];
    //    _feedbackImageView.image = [UIImage imageNamed:@"三角形向上"];
    //
    UIView *columnView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, 10)];
    columnView.backgroundColor = kBackGroundColor;
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 54, kScreenWidth-20, 155)];
    _textView.tintColor = kDarkOneColor;
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.layer.masksToBounds = YES;
    _textView.layer.cornerRadius = 22;
    
    
    UIView *singleLine1 = [[UIView alloc]initWithFrame:CGRectMake(0, 99.5 + 54 + 70, kScreenWidth, 0.5)];
    singleLine1.backgroundColor = kSingleLineColor;
    
    _placeHolder = [[UILabel alloc]initWithFrame:CGRectMake(12, 9 + 54 , kScreenWidth - 20, 14)];
    _placeHolder.text = @"请输入您的意见,我们将不断优化";
    _placeHolder.textColor = kDarkNineColor;
    _placeHolder.font = [UIFont systemFontOfSize:14];
    
    _characterLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 60, CGRectGetMaxY(_textView.frame) +2, 55, 12)];
    _characterLabel.textColor = kDarkNineColor;
    _characterLabel.font = [UIFont systemFontOfSize:10];
    _characterLabel.textAlignment = NSTextAlignmentRight;
    _characterLabel.text = @"0/300";
    
    
    
    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 115+54+70+5, kScreenWidth, 16)];
    topLabel.font = [UIFont systemFontOfSize:16];
    topLabel.textColor = kDarkTwoColor;
    topLabel.text = @"联系方式";
    
    
    _phoneNum = [[UITextField alloc]initWithFrame:CGRectMake(10, 115+54+70+36, kScreenWidth-20, 44)];
    _phoneNum.backgroundColor = [UIColor whiteColor];
    _phoneNum.font = [UIFont systemFontOfSize:14];
    _phoneNum.placeholder = @"请添加联系方式(手机、QQ或邮箱)";
    [_phoneNum setValue:kDarkNineColor forKeyPath:@"_placeholderLabel.textColor"];
    [_phoneNum setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    _phoneNum.tintColor = kDarkOneColor;
    _phoneNum.delegate = self;
    _phoneNum.returnKeyType = UIReturnKeyDone;
    
    UIView *singleLine2 = [[UIView alloc]initWithFrame:CGRectMake(0, 158.5 + 54 + 70 + 36, kScreenWidth, 0.5)];
    singleLine2.backgroundColor = kSingleLineColor;
    
    UILabel *promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 159 + 60 + 70 + 36, kScreenWidth-20, 14)];
    promptLabel.font = [UIFont systemFontOfSize:10];
    promptLabel.textColor = kDarkNineColor;
    promptLabel.text = @"您的联系方式有助于我们沟通和解决问题";
    
    UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 260+70+50, kScreenWidth - 20, 44)];
    submitBtn.layer.cornerRadius = 22;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.backgroundColor = kDarkOneColor;
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [submitBtn setTitle:@"提交" forState:(UIControlStateNormal)];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [submitBtn addTarget:self action:@selector(submitBtnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    [headerView addSubview:feedbackTypeLab];
    //    [headerView addSubview:_feedbackTypeBtn];
    [headerView addSubview:_feedbackImageView];
    
    
    [self.view addSubview:topLabel];
    [self.view addSubview:headerView];
    [self.view addSubview:columnView];
    [self.view addSubview:_textView];
    [self.view addSubview:_characterLabel];
    [self.view addSubview:singleLine1];
    [self.view addSubview:_placeHolder];
    [self.view addSubview:_phoneNum];
    [self.view addSubview:singleLine2];
    [self.view addSubview:promptLabel];
    [self.view addSubview:submitBtn];
}

//- (void)addTableView
//{
//    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, 0)];
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.backgroundColor = [UIColor whiteColor];
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    self.tableView.estimatedRowHeight = 0;
//    self.tableView.estimatedSectionHeaderHeight = 0;
//    self.tableView.estimatedSectionFooterHeight = 0;
//    [_tableView registerNib:[UINib nibWithNibName:@"JMFeedBackViewCell" bundle:nil] forCellReuseIdentifier:@"JMFeedBackViewCell"];
//    [self.view addSubview:_tableView];
//}

/**textView的代理方法*/
- (void)textViewDidChange:(UITextView *)textView
{
    if (self.textView.text.length) {
        self.placeHolder.hidden = YES;
    }else{
        self.placeHolder.hidden = NO;
    }
    int number = [self getTotalCharacterFromString:textView.text];
    
    if (number > 300) {
        _characterLabel.text = @"300/300";
        ZTShowAlertMessage(@"字数达到上限");
        
    }else{
        _characterLabel.text = [NSString stringWithFormat:@"%d/300",number];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    [self.phoneNum resignFirstResponder];
    //    [UIView animateWithDuration:0.1 animations:^{
    //        _tableView.frame = CGRectMake(0, 44, kScreenWidth, 0);
    //    } completion:nil];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)submitBtnClickAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    if (!_textView.text || [_textView.text isEqualToString:@""]) {
        ZTShowAlertMessage(@"反馈内容不能为空");
        return;
    }
    int number = [self getTotalCharacterFromString:_textView.text];
    if (number > 300) {
        ZTShowAlertMessage(@"超出字数限制");
        return;
    }
    //    if (!_phoneNum.text || [_phoneNum.text isEqualToString:@""]) {
    //        ZTShowAlertMessage(@"手机号不能为空");
    //        return;
    //    }
    //    if (![[JstyleToolManager sharedManager] isMobileNumber:_phoneNum.text]) {
    //        ZTShowAlertMessage(@"手机号格式不正确");
    //        return;
    //    }
    [self postJMHelpCenterBackMessageDataSource];
}

- (void)feedbackTypeBtnDidClickAction:(UIButton *)sender
{
    self.feedbackTypeBtnIsSelected = ! self.feedbackTypeBtnIsSelected;
    if (self.feedbackTypeBtnIsSelected) {
        _feedbackImageView.image = [UIImage imageNamed:@"三角形向下"];
        //        [UIView animateWithDuration:0.1 animations:^{
        //            _tableView.frame = CGRectMake(0, 44, kScreenWidth, 44 * 6);
        //        } completion:nil];
    }else{
        _feedbackImageView.image = [UIImage imageNamed:@"三角形向上"];
        //        [UIView animateWithDuration:0.1 animations:^{
        //            _tableView.frame = CGRectMake(0, 44, kScreenWidth, 0);
        //        } completion:nil];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    //    [UIView animateWithDuration:0.1 animations:^{
    //        _tableView.frame = CGRectMake(0, 44, kScreenWidth, 0);
    //    } completion:nil];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return kMenuArray.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *ID = @"JMFeedBackViewCell";
//    JMFeedBackViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (!cell) {
//        cell = [[JMFeedBackViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
//    }
//
//    cell.menuNameLabel.text = kMenuArray[indexPath.row];
//
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    _feedbackImageView.image = [UIImage imageNamed:@"三角形向上"];
//    self.feedbackTypeBtnIsSelected = ! self.feedbackTypeBtnIsSelected;
//    self.menuSelectedType = [NSString stringWithFormat:@"%d",indexPath.row];
//
//    [_feedbackTypeBtn setTitle:kMenuArray[indexPath.row] forState:(UIControlStateNormal)];
//    [UIView animateWithDuration:0.1 animations:^{
//        _tableView.frame = CGRectMake(0, 44, kScreenWidth, 0);
//    } completion:nil];
//}

- (void)showMessageOne:(NSString *)messageOne messageTwo:(NSString *)messageTwo
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 2.0f;
    showview.layer.masksToBounds = YES;
    showview.center = CGPointMake(kScreenWidth/2, kScreenHeight*1/2);
    
    UILabel *expLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40 * kScreenWidth / 375.0, kScreenWidth - 60, 20 * kScreenWidth / 375.0)];
    expLabel.text = messageOne;
    expLabel.textAlignment = NSTextAlignmentCenter;
    expLabel.font = [UIFont systemFontOfSize:14];
    expLabel.textColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 70 * kScreenWidth / 375.0, kScreenWidth - 60 * kScreenWidth / 375.0, 20 * kScreenWidth / 375.0)];
    label.text = messageTwo;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    
    [showview addSubview:expLabel];
    [showview addSubview:label];
    showview.bounds = CGRectMake(0, 0, kScreenWidth - 60 * kScreenWidth / 375.0, 135 * kScreenWidth / 375.0);
    showview.y = 165 * kScreenWidth / 375.0;
    [window addSubview:showview];
    [UIView animateWithDuration:3.0f animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

/**留言反馈post数据*/
- (void)postJMHelpCenterBackMessageDataSource
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString * uid = [[JstyleToolManager sharedManager] getUserId];
    if (![uid isNotBlank]) {
        uid = @" ";
    }
    NSDictionary *parameters = @{@"uid":uid,
                                 @"content":self.textView.text,
                                 @"phone":self.phoneNum.text,
                                 @"feed_type":@"0",
                                 @"platform_type":@"2",
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID]};
    
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // post请求
    [manager POST:MY_HELPCENTER_BACKMESSAGE_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSDictionary * dic = responseObject;
        
        if ([dic[@"code"] integerValue] == 1) {
            self.textView.text = nil;
            self.phoneNum.text = nil;
            [self showMessageOne:@"您的建议已成功反馈,感谢您的反馈!" messageTwo:@"您的支持是我们的动力!"];
        }else{
            ZTShowAlertMessage(dic[@"data"]);
        }
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        //ZTShowAlertMessage(@"数据加载失败");
    }];
}

- (int)getTotalCharacterFromString:(NSString*)string {
    int strlength = 0;
    
    char* p = (char*)[string cStringUsingEncoding:NSUnicodeStringEncoding];
    
    for (int i=0 ; i< [string lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        
        if (*p) {
            p++;
            strlength++;
        }else {
            p++;
        }
        if ((strlength+1)/2==300) {
            self.subNumber = strlength+1;
            if (self.textView.text.length>=self.subNumber) {
                self.textView.text = [self.textView.text substringToIndex:self.subNumber];
            }
        }
    }
    return (strlength+1)/2;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
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
