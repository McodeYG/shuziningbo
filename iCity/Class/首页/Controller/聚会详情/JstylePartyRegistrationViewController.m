//
//  JstylePartyRegistrationViewController.m
//  Exquisite
//
//  Created by 赵涛 on 2017/7/6.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstylePartyRegistrationViewController.h"
#import "JstylePartyRegistrationViewCell.h"
#import "JstylePartySuccessViewController.h"
//#import "JstylePartyPayViewController.h"

#define kImageArray         @[@"聚会手机",@"聚会验证码",@"聚会邮箱",@"聚会姓名",@"聚会性别",@"聚会职业",@"聚会公司"]
#define kPlaceholderArray   @[@"您的手机号",@"请输入您收到的验证码",@"设置您的邮箱",@"请输入您的姓名",@"性别",@"职业",@"公司"]

@interface JstylePartyRegistrationViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,NTESActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *inputTextArray;

@property (nonatomic, strong) UIButton *nextStepBtn;

@end

@implementation JstylePartyRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBackGroundColor;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.title = @"完善信息";
    [self addTableView];
    [self addNextStepBtn];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)addTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 48) style:(UITableViewStyleGrouped)];
    _tableView.backgroundColor = kBackGroundColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    [_tableView registerNib:[UINib nibWithNibName:@"JstylePartyRegistrationViewCell" bundle:nil] forCellReuseIdentifier:@"JstylePartyRegistrationViewCell"];
    
    [self.view addSubview:_tableView];
}

- (void)addNextStepBtn
{
    _nextStepBtn = [[UIButton alloc]init];
    _nextStepBtn.backgroundColor = kLightRedColor;
    [_nextStepBtn setTitle:@"下一步" forState:(UIControlStateNormal)];
    [_nextStepBtn setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
    _nextStepBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _nextStepBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_nextStepBtn addTarget:self action:@selector(nextStepBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_nextStepBtn];
    _nextStepBtn.sd_layout
    .bottomSpaceToView(self.view, YG_SafeBottom_H)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(48);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.inputTextArray removeAllObjects];
    for (int i = 0; i < kImageArray.count; i ++) {
        JstylePartyRegistrationViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [cell.inputTextField resignFirstResponder];
        if (cell.inputTextField.text) {
            [self.inputTextArray addObject:cell.inputTextField.text];
        }
    }
}

- (void)nextStepBtnClicked:(UIButton *)sender
{
    if (!self.inputTextArray.count) {
        ZTShowAlertMessage(@"请填写相关信息");
        return;
    }
    [self postPartyInformationDataSource];
//    JstylePartyPayViewController *jstylePartyPayVC = [JstylePartyPayViewController new];
//    [self.navigationController pushViewController:jstylePartyPayVC animated:YES];
}

#pragma mark -- tableView的代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kImageArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"JstylePartyRegistrationViewCell";
    JstylePartyRegistrationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[JstylePartyRegistrationViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    cell.iconImageView.image = [UIImage imageNamed:kImageArray[indexPath.row]];
    cell.inputTextField.placeholder = kPlaceholderArray[indexPath.row];
    cell.inputTextField.delegate = self;
    switch (indexPath.row) {
        case 0:
            cell.moreImageView.hidden = YES;
            break;
        case 1:
            cell.moreImageView.hidden = YES;
            break;
        case 2:
            cell.moreImageView.hidden = YES;
            cell.inputTextField.keyboardType = UIKeyboardTypeEmailAddress;
            break;
        case 4:{
            cell.moreImageView.hidden = NO;
            cell.inputTextField.enabled = NO;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
            [cell.inputTextField addGestureRecognizer:tap];
        }
            break;
        default:
            cell.moreImageView.hidden = YES;
            cell.inputTextField.keyboardType = UIKeyboardTypeDefault;
            break;
    }
    if (indexPath.row == 0) {
        cell.sendCodeBtn.hidden = NO;
        [cell.sendCodeBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        [cell.sendCodeBtn addTarget:self action:@selector(getCodeNumData) forControlEvents:(UIControlEventTouchUpInside)];
    }else{
        cell.sendCodeBtn.hidden = YES;
    }
    
    switch (indexPath.row) {
        case 4:
            if ([self.typeStr containsString:@"4"]) {
                cell.iconImageView.hidden = NO;
                cell.inputTextField.hidden = NO;
                cell.moreImageView.hidden = NO;
            }else{
                cell.iconImageView.hidden = YES;
                cell.inputTextField.hidden = YES;
                cell.moreImageView.hidden = YES;
            }
            break;
        case 5:
            if ([self.typeStr containsString:@"5"]) {
                cell.iconImageView.hidden = NO;
                cell.inputTextField.hidden = NO;
            }else{
                cell.iconImageView.hidden = YES;
                cell.inputTextField.hidden = YES;
            }
            break;
        case 6:
            if ([self.typeStr containsString:@"6"]) {
                cell.iconImageView.hidden = NO;
                cell.inputTextField.hidden = NO;
            }else{
                cell.iconImageView.hidden = YES;
                cell.inputTextField.hidden = YES;
            }
            break;
        default:
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 4:
            if ([self.typeStr containsString:@"4"]) {
                return 53;
            }else{
                return 0;
            }
            break;
        case 5:
            if ([self.typeStr containsString:@"5"]) {
                return 53;
            }else{
                return 0;
            }
            break;
        case 6:
            if ([self.typeStr containsString:@"6"]) {
                return 53;
            }else{
                return 0;
            }
            break;
        default:
            return 53;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (int i = 0; i < kImageArray.count; i ++) {
        JstylePartyRegistrationViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [cell.inputTextField resignFirstResponder];
    }
    if (indexPath.row == 4) {
        [self tapAction];
    }
}

- (void)tapAction
{
    NTESActionSheet *actionSheet = [[NTESActionSheet alloc]initWithTitle:@"选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"男",@"女"]];
    [actionSheet showInView:self.view];
}

#pragma mark -- actionSheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    JstylePartyRegistrationViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    switch (buttonIndex) {
        case 0:
            cell.inputTextField.text = @"男";
            break;
        case 1:
            cell.inputTextField.text = @"女";
            break;
        default:
            break;
    }
}


/**获取验证码*/
- (void)getCodeNumData
{
    JstylePartyRegistrationViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:cell.inputTextField.text,@"mobile",@"6",@"type", nil];
    // 初始化Manager
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];;
    
    // post请求
    [manager POST:GET_CODE_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dictionary[@"code"] integerValue] == 1) {
            [self godeNumberMinus];
        }
        ZTShowAlertMessage(dictionary[@"data"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
                JstylePartyRegistrationViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                [cell.sendCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                [cell.sendCodeBtn setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
                cell.sendCodeBtn.backgroundColor = kLightRedColor;
                cell.sendCodeBtn.userInteractionEnabled = YES;
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"倒计时%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                JstylePartyRegistrationViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                cell.sendCodeBtn.titleLabel.text = strTime;
                [cell.sendCodeBtn setTitle:strTime forState:UIControlStateNormal];
                [cell.sendCodeBtn setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
                cell.sendCodeBtn.backgroundColor = kDarkNineColor;
                cell.sendCodeBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.inputTextArray removeAllObjects];
    for (int i = 0; i < kImageArray.count; i ++) {
        JstylePartyRegistrationViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [cell.inputTextField resignFirstResponder];
        if (cell.inputTextField.text) {
            [self.inputTextArray addObject:cell.inputTextField.text];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.inputTextArray removeAllObjects];
    for (int i = 0; i < kImageArray.count; i ++) {
        JstylePartyRegistrationViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [cell.inputTextField resignFirstResponder];
        if (cell.inputTextField.text) {
            [self.inputTextArray addObject:cell.inputTextField.text];
        }
    }
    return YES;
}



- (BOOL)isPhoneCodeEmailNameExisted{
    if (self.inputTextArray[0] == nil || [self.inputTextArray[0] isEqualToString:@""]) {
        ZTShowAlertMessage(@"请输入手机号");
        return NO;
    }else if(![[JstyleToolManager sharedManager] isMobileNumber:self.inputTextArray[0]]){
        ZTShowAlertMessage(@"手机号格式不正确");
        return NO;
    }
    if (self.inputTextArray[1] == nil || [self.inputTextArray[1] isEqualToString:@""]) {
        ZTShowAlertMessage(@"请输入验证码");
        return NO;
    }
    
    if (self.inputTextArray[2] == nil || [self.inputTextArray[2] isEqualToString:@""]) {
        ZTShowAlertMessage(@"请输入邮箱");
        return NO;
    }else if(![[JstyleToolManager sharedManager] isEmailNumber:self.inputTextArray[2]]){
        ZTShowAlertMessage(@"邮箱格式不正确");
        return NO;
    }
    
    if (self.inputTextArray[3] == nil || [self.inputTextArray[3] isEqualToString:@""]) {
        ZTShowAlertMessage(@"请输入姓名");
        return NO;
    }
    return YES;
}

/**传入后台参数数据*/
- (void)postPartyInformationDataSource
{
    if (![self isPhoneCodeEmailNameExisted]) {
        return;
    }
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[[JstyleToolManager sharedManager] getUserId],@"uid",self.partyId,@"id",self.inputTextArray[0],@"mobile",self.inputTextArray[1],@"code",self.inputTextArray[2],@"email",self.inputTextArray[3],@"name",self.inputTextArray[4],@"sex",self.inputTextArray[5],@"profession",self.inputTextArray[6],@"company", nil];
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    // post请求
    [manager GET:JSTYLE_PARTY_INFOR_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dictionary[@"code"] integerValue] == 1) {
            if ([dictionary[@"data"][@"type"] integerValue] == 1) {
                //去支付并传参数
//                JstylePartyPayViewController *jstylePartyPayVC = [JstylePartyPayViewController new];
//                jstylePartyPayVC.phone = self.inputTextArray[0];
//                jstylePartyPayVC.partyId = self.partyId;
//                jstylePartyPayVC.way = 4;
//                [self.navigationController pushViewController:jstylePartyPayVC animated:YES];
            }else if ([dictionary[@"data"][@"type"] integerValue] == 2){
                //报名成功页面
                JstylePartySuccessViewController *jstylePartySuccessVC = [JstylePartySuccessViewController new];
                jstylePartySuccessVC.partyId = self.partyId;
                [self.navigationController pushViewController:jstylePartySuccessVC animated:YES];
            }
        }else{
            ZTShowAlertMessage(dictionary[@"data"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (NSMutableArray *)inputTextArray
{
    if (!_inputTextArray) {
        _inputTextArray = [NSMutableArray array];
    }
    return _inputTextArray;
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
