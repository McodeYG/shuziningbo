//
//  JstyleNewsAccountBindingViewController.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/4/11.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsAccountBindingViewController.h"
#import "JstyleNewsChangeMobileViewController.h"
#import "JstyleNewsAccountBindingViewCell.h"
#import "JstyleNewsThirdPartBindStateModel.h"
#import "JstyleNewsBindStateView.h"

@interface JstyleNewsAccountBindingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) JstyleNewsBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSDictionary *userInfo;

@property (nonatomic, copy) NSString *phone;

@end

@implementation JstyleNewsAccountBindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号绑定";
    [self addTableView];
    [self loadThirdPartBindStateData];
}

- (void)addTableView
{
    _tableView = [[JstyleNewsBaseTableView alloc]initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsAccountBindingViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsAccountBindingViewCell"];
    
    [self.view addSubview:_tableView];
    _tableView.sd_layout
    .topSpaceToView(self.view, YG_StatusAndNavightion_H)
    .bottomEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view);
}

#pragma mark -- tableView的代理方法
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"JstyleNewsAccountBindingViewCell";
    JstyleNewsAccountBindingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[JstyleNewsAccountBindingViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    if (indexPath.row < self.dataArray.count) {
        JstyleNewsThirdPartBindStateModel *model = self.dataArray[indexPath.row];
        cell.model = model;
        if (indexPath.row == 0) {
            if (model.number.length > 10) {
                NSString *phone = model.number;
                phone = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
                cell.bindLabel.text = phone;
            }else{
                cell.bindLabel.text = @"";
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.dataArray.count) return;
    JstyleNewsThirdPartBindStateModel *model = self.dataArray[indexPath.row];
    __weak typeof(self)weakSelf = self;
    switch (indexPath.row) {
        case 0:{
            //改绑手机号
            JstyleNewsChangeMobileViewController *changeMobileVC = [JstyleNewsChangeMobileViewController new];
            [self.navigationController pushViewController:changeMobileVC animated:YES];
        }
            break;
        case 1:{
            //QQ
            if (model.number.length > 5) {
                [self showRemoveBindAlertWithMessage:@"确定要接触账号与QQ的关联吗？" Unionid:model.number type:@"1"];
            }else{
                [self qqBindAction];
            }
        }
            break;
        case 2:{
            //微信
            if (model.number.length > 5) {
                [self showRemoveBindAlertWithMessage:@"确定要接触账号与微信的关联吗？" Unionid:model.number type:@"2"];
            }else{
                [self wechatBindAction];
            }
        }
            break;
        case 3:{
            //新浪微博
            if (model.number.length > 5) {
                [self showRemoveBindAlertWithMessage:@"确定要接触账号与微博的关联吗？" Unionid:model.number type:@"3"];
            }else{
                [self sinaBindAction];
            }
        }
            break;
        default:
            break;
    }
}

/**
 * qq登录
 */
- (void)qqBindAction
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            ZTShowAlertMessage(@"获取QQ信息失败");
        }else{
            UMSocialUserInfoResponse *userinfo = result;
            NSLog(@"%@",userinfo.originalResponse);
            [[NSUserDefaults standardUserDefaults]setObject:@"qqLogin" forKey:@"qqLogin"];
            [[NSUserDefaults standardUserDefaults]setObject:userinfo.openid forKey:@"phone"];
            
            NSString *sex = userinfo.originalResponse[@"gender"];
            NSString *address = [userinfo.originalResponse[@"province"] stringByAppendingString:userinfo.originalResponse[@"city"]];
     
            if (![userinfo.unionId isNotBlank]) {
                userinfo.unionId = @" ";
            }
            NSDictionary *userInfo = @{@"openid":userinfo.uid,
                              @"unionid":userinfo.unionId,
                              @"type":@"1",
                              @"nickname":userinfo.name,
                              @"avator":userinfo.iconurl,
                              @"sex":sex,
                              @"birth":@" ",
                              @"address":address,
                              @"phone_type":@"1",
                              @"uuid":[JstyleToolManager sharedManager].getUDID,
                              @"platform_type":@"2",
                              @"phone":[NSString stringWithFormat:@"%@",self.phone]};
            [self thirdPartBindWithUserInfo:userInfo];
        }
    }];
}

/**
 * 微信登录
 */
- (void)wechatBindAction
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            ZTShowAlertMessage(@"获取微信信息失败");
        }else{
            UMSocialUserInfoResponse *userinfo = result;
            [[NSUserDefaults standardUserDefaults]setObject:@"wxLogin" forKey:@"wxLogin"];
            [[NSUserDefaults standardUserDefaults]setObject:userinfo.openid forKey:@"phone"];
            NSString *sex = userinfo.originalResponse[@"sex"];
            NSString *address = [userinfo.originalResponse[@"province"] stringByAppendingString:userinfo.originalResponse[@"city"]];
            if (![userinfo.unionId isNotBlank]) {
                userinfo.unionId = @" ";
            }
            NSDictionary *userInfo = @{@"openid":userinfo.uid,
                              @"unionid":userinfo.unionId,
                              @"type":@"2",
                              @"nickname":userinfo.name,
                              @"avator":userinfo.iconurl,
                              @"sex":sex,
                              @"birth":@" ",
                              @"address":address,
                              @"phone_type":@"1",
                              @"uuid":[JstyleToolManager sharedManager].getUDID,
                              @"platform_type":@"2",
                              @"phone":[NSString stringWithFormat:@"%@",self.phone]};
            [self thirdPartBindWithUserInfo:userInfo];
        }
    }];
}

/**
 * 新浪登录
 */
- (void)sinaBindAction
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            ZTShowAlertMessage(@"获取微博信息失败");
        }else{
            UMSocialUserInfoResponse *userinfo = result;
            [[NSUserDefaults standardUserDefaults]setObject:@"wbLogin" forKey:@"wbLogin"];
            [[NSUserDefaults standardUserDefaults]setObject:userinfo.uid forKey:@"phone"];
            NSString *sex = userinfo.originalResponse[@"gender"];
            NSString *address = userinfo.originalResponse[@"location"];
            if (![userinfo.unionId isNotBlank]) {
                userinfo.unionId = @" ";
            }
            NSDictionary *userInfo = @{@"openid":userinfo.uid,
                              @"unionid":userinfo.unionId,
                              @"type":@"3",
                              @"nickname":userinfo.name,
                              @"avator":userinfo.iconurl,
                              @"sex":sex,
                              @"birth":@" ",
                              @"address":address,
                              @"phone_type":@"1",
                              @"uuid":[JstyleToolManager sharedManager].getUDID,
                              @"platform_type":@"2",
                              @"phone":[NSString stringWithFormat:@"%@",self.phone]};
            
            [self thirdPartBindWithUserInfo:userInfo];
        }
    }];
}

/**
 * 第三方绑定操作
 @param userInfo 第三方信息
 */
- (void)thirdPartBindWithUserInfo:(NSDictionary *)userInfo
{
    [SVProgressHUD setCornerRadius:8];
    [SVProgressHUD setBackgroundColor:kDarkSixColor];
    [SVProgressHUD setForegroundColor:kWhiteColor];
    [SVProgressHUD showWithStatus:@"账号绑定中..."];
    [[JstyleNewsNetworkManager shareManager] POSTURL:THIRD_PART_BIND_URL parameters:userInfo success:^(id responseObject) {
        [NSThread sleepForTimeInterval:1.5];
        [SVProgressHUD dismiss];
        if ([responseObject[@"code"] integerValue] == 1) {
            //绑定成功
            [self loadThirdPartBindStateData];
            JSShowBindStateAlert(responseObject[@"data"], @"三方绑定成功");
        }else{
            JSShowBindStateAlert(responseObject[@"data"], @"三方绑定失败");
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        JSShowBindStateAlert(@"绑定失败!", @"三方绑定失败");
    }];
}

/**
 * 第三方解除绑定操作
 @param unionid   unionid（微信、微博、qq账号）
 @param type      type(1为qq，2为微信，3为微博)
 */
- (void)thirdPartRemoveBindWithUnionid:(NSString *)unionid type:(NSString *)type
{
    [SVProgressHUD setCornerRadius:8];
    [SVProgressHUD setBackgroundColor:kDarkSixColor];
    [SVProgressHUD setForegroundColor:kWhiteColor];
    [SVProgressHUD showWithStatus:@"账号解绑中..."];
    NSDictionary *parameters = @{@"uid":[JstyleToolManager sharedManager].getUserId,
                                 @"unionid":unionid,
                                 @"type":type};
    [[JstyleNewsNetworkManager shareManager] POSTURL:THIRD_REMOVE_BIND_URL parameters:parameters success:^(id responseObject) {
        [NSThread sleepForTimeInterval:1.5];
        [SVProgressHUD dismiss];
        if ([responseObject[@"code"] integerValue] == 1) {
            //解绑成功
            [self loadThirdPartBindStateData];
            JSShowBindStateAlert(@"解绑成功!", @"三方绑定成功");
        }else{
            //解绑失败
            JSShowBindStateAlert(@"解绑失败!", @"三方绑定失败");
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        JSShowBindStateAlert(@"解绑失败!", @"三方绑定失败");
    }];
}

- (void)loadThirdPartBindStateData
{
    NSDictionary *parameters = @{@"uid":[JstyleToolManager sharedManager].getUserId};
    [[JstyleNewsNetworkManager shareManager] POSTURL:THIRD_BIND_STATE_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            [self.dataArray removeAllObjects];
            for (int i = 0; i < 4; i ++) {
                JstyleNewsThirdPartBindStateModel *model = [JstyleNewsThirdPartBindStateModel new];
                switch (i) {
                    case 0:{
                        model.name = @"手机号";
                        model.number = responseObject[@"data"][@"phone"];
                        self.phone = responseObject[@"data"][@"phone"];
                    }
                        break;
                    case 1:{
                        model.name = @"QQ";
                        model.number = responseObject[@"data"][@"qq"];
                    }
                        break;
                    case 2:{
                        model.name = @"微信";
                        model.number = responseObject[@"data"][@"weixin"];
                    }
                        break;
                    case 3:{
                        model.name = @"新浪微博";
                        model.number = responseObject[@"data"][@"weibo"];
                    }
                        break;
                    default:
                        break;
                }
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        }else{
            ZTShowAlertMsgWithAlignment(responseObject[@"error"], AlertMessageAlignmentBottom);
        }
    } failure:^(NSError *error) {
        ZTShowAlertMessage(@"获取绑定状态失败");
    }];
}

- (void)showRemoveBindAlertWithMessage:(NSString *)message Unionid:(NSString *)unionid type:(NSString *)type
{
    ZTAlertView *alertView = [[ZTAlertView alloc] initWithTitle:@"解除绑定" message:message sureBtn:@"解除绑定" cancleBtn:@"取消"];
    alertView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            [self thirdPartRemoveBindWithUnionid:unionid type:type];
        }
    };
    [alertView show];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
