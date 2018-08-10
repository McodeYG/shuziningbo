//
//  JMMySettingViewController.m
//  Exquisite
//
//  Created by 数字宁波 on 16/5/5.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import "JstyleNewsSettingViewController.h"
#import "JMMySettingViewCell.h"
#import "JMMyInformationViewController.h"
#import "JMAboutJingMeiViewController.h"
#import <AdSupport/AdSupport.h>

#import "JstyleNewsChangePassworldViewController.h"
#import "JstyleNewsSettingPasswordViewController.h"
#import "JstyleNewsSettingFontView.h"
#import "JstyleNewsAccountBindingViewController.h"

@interface JstyleNewsSettingViewController ()<UITableViewDelegate,UITableViewDataSource,JPUSHRegisterDelegate,NTESActionSheetDelegate>
/***/
@property (nonatomic, strong) JstyleNewsBaseTableView *tableView;
/**列表选项名称数组*/
@property (nonatomic, strong) NSArray *titleArray;
/**开启消息推送的switch*/
@property (nonatomic, strong) UISwitch *messageSwitch;
/**开启wifi的switch*/
@property (nonatomic, strong) UISwitch *wifiSwitch;
/**缓存label*/
@property (nonatomic, strong) UILabel *cacheLabel;
/**换肤label*/
@property (nonatomic, strong) UILabel *themeLabel;

//大小Label
@property (nonatomic, strong) UILabel *fontSizeLabel;
//版本label
@property (nonatomic, strong) UILabel *versionLabel;

@end

@implementation JstyleNewsSettingViewController
{
    id _notification;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushDidChanged) name:@"PushDidChangedNotification" object:nil];
    
    _tableView = [[JstyleNewsBaseTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:(UITableViewStyleGrouped)];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    if ([[JstyleToolManager sharedManager] isTourist]) {
        _tableView.contentInset = UIEdgeInsetsZero;
    } else {
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, (65 + 10*(IS_iPhoneX?1:0)), 0);
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [_tableView registerNib:[UINib nibWithNibName:@"JMMySettingViewCell" bundle:nil] forCellReuseIdentifier:@"JMMySettingViewCell"];
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
    
    UIButton *closeLogin = [[UIButton alloc]init];
    closeLogin.backgroundColor = kNightModeBackColor;
    closeLogin.titleLabel.font = [UIFont systemFontOfSize:16];
    closeLogin.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [closeLogin setTitle:@"退出登录" forState:(UIControlStateNormal)];
    [closeLogin setTitleColor:JSColor(@"#EE6767") forState:UIControlStateNormal];
    [closeLogin addTarget:self action:@selector(closeLoginAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:closeLogin];
    closeLogin.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 10*(IS_iPhoneX?1:0), 0);
    closeLogin.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    .heightIs(65 + 10*(IS_iPhoneX?1:0));
    
    closeLogin.hidden = [[JstyleToolManager sharedManager] isTourist];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    if ([[JstyleToolManager sharedManager] isTourist]) { // 游客
        self.titleArray = @[@"清除缓存",@"推送通知",@"仅WiFi播放视频",@"关于我们",@"当前版本"];
    } else { // 非游客
        if ([[JstyleToolManager sharedManager] isAllreadySettedPWD]) { // 设置过密码
            self.titleArray = @[@"编辑资料",@"账号绑定",@"修改密码",@"清除缓存",@"推送通知",@"仅WiFi播放视频",@"关于我们",@"当前版本"];
        } else { // 没密码
            self.titleArray = @[@"编辑资料",@"账号绑定",@"设置密码" ,@"清除缓存",@"推送通知",@"仅WiFi播放视频",@"关于我们",@"当前版本"];
        }
    }
    
    [self.tableView reloadData];
}

- (void)pushDidChanged
{
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIUserNotificationTypeNone) {
        [self.messageSwitch setOn:NO];
    }else{
        [self.messageSwitch setOn:YES];
    }
}

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
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"JMMySettingViewCell";
    JMMySettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[JMMySettingViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    cell.titleName.text = _titleArray[indexPath.row];
    NSString * name = _titleArray[indexPath.row];
    
    if ([name isEqualToString:@"清除缓存"]) {
        [cell.rightImageView removeFromSuperview];
        if (_cacheLabel == nil) {
            CGFloat cacheCount = [self filePathSize];
            NSString *cacheSize = [NSString stringWithFormat:@"%.2fM",cacheCount/10.00f];
            _cacheLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 15 - [cacheSize length]*12, 22, [cacheSize length]*12, 20)];
            _cacheLabel.text = cacheSize;
            _cacheLabel.textColor = kDarkNineColor;
            _cacheLabel.font = [UIFont systemFontOfSize:12];
            _cacheLabel.textAlignment = NSTextAlignmentRight;
            
            [cell.contentView addSubview:_cacheLabel];
        }
    }else if ([name isEqualToString:@"字体大小"]) {
        [cell.rightImageView removeFromSuperview];
        
        if (_fontSizeLabel == nil) {
            NSString *fontSize = [[NSUserDefaults standardUserDefaults]objectForKey:@"JstyleNewsFontSize"];
            if (fontSize == nil || [fontSize isEqualToString:@""]) {
                fontSize = @"中";
            }
            
            _fontSizeLabel = [[UILabel alloc] init];
            _fontSizeLabel.text = fontSize;
            _fontSizeLabel.textColor = kDarkNineColor;
            _fontSizeLabel.font = [UIFont systemFontOfSize:12];
            _fontSizeLabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:_fontSizeLabel];
            [_fontSizeLabel sizeToFit];
            [_fontSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.offset(0);
                make.right.offset(-15);
            }];
        }
    
    }else if ([name isEqualToString:@"推送通知"]) {
        [cell.rightImageView removeFromSuperview];
        
        if (_messageSwitch == nil) {
            _messageSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(kScreenWidth - 65, 12, 50, 30)];
            if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIUserNotificationTypeNone) {
                [_messageSwitch setOn:NO];
            }else{
                [_messageSwitch setOn:YES];
            }
            [_messageSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:_messageSwitch];
        }
        
    }else if ([name isEqualToString:@"仅WiFi播放视频"]) {
        [cell.rightImageView removeFromSuperview];
        if (_wifiSwitch == nil) {
            
            _wifiSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(kScreenWidth - 65, 12, 50, 30)];
            if ([[NSUserDefaults standardUserDefaults] stringForKey:@"PlayVideoOnlyWiFi"]) {
                [_wifiSwitch setOn:YES];
            } else {
                [_wifiSwitch setOn:NO];
            }
            [_wifiSwitch addTarget:self action:@selector(wifiSwitchAction:) forControlEvents:UIControlEventValueChanged];
            
            [cell.contentView addSubview:_wifiSwitch];
        }
    }else if ([name isEqualToString:@"关于我们"]) {

    }else if ([name isEqualToString:@"当前版本"]) {
        [cell.rightImageView removeFromSuperview];
        if (_versionLabel == nil) {
            
            NSString *versionString = [UIApplication sharedApplication].appVersion;
            _versionLabel = [[UILabel alloc]init];
            _versionLabel.text = versionString;
            _versionLabel.textColor = kDarkNineColor;
            _versionLabel.font = [UIFont systemFontOfSize:12];
            _versionLabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:_versionLabel];
            [_versionLabel sizeToFit];
            [_versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.offset(0);
                make.right.offset(-15);
            }];
        }
        
    }else if ([name isEqualToString:@"编辑资料"]) {
    }else if ([name isEqualToString:@"账号绑定"]) {
    }else if ([name isEqualToString:@"修改密码"]) {
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//- (NSString *)getCurrentThemeText {
//    NSString *currentThemeName = [LEETheme currentThemeTag];
//    if ([currentThemeName isEqualToString:ThemeName_Red]) {
//        currentThemeName = @"官方红";
//    } else if ([currentThemeName isEqualToString:ThemeName_White]) {
//        currentThemeName = @"优雅白";
//    } else if ([currentThemeName isEqualToString:ThemeName_Blue]) {
//        currentThemeName = @"永恒蓝";
//    } else if ([currentThemeName isEqualToString:ThemeName_Black]) {
//        currentThemeName = @"商务黑";
//    } else if ([currentThemeName isEqualToString:ThemeName_Purple]) {
//        currentThemeName = @"高贵紫";
//    } else if ([currentThemeName isEqualToString:ThemeName_Brown]) {
//        currentThemeName = @"香槟金";
//    }
//    return currentThemeName;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * name = _titleArray[indexPath.row];
    if ([name isEqualToString:@"清除缓存"]) {
        //清除缓存
        [self cleanCache];
    }else if ([name isEqualToString:@"字体大小"]) {
        //字体大小
        [self settingFontSize];
    }else if ([name isEqualToString:@"推送通知"]) {
        
    }else if ([name isEqualToString:@"仅WiFi播放视频"]) {
        
    }else if ([name isEqualToString:@"关于我们"]) {
        //关于我们
        JMAboutJingMeiViewController *jmAboutJingMeiVC = [JMAboutJingMeiViewController new];
        [self.navigationController pushViewController:jmAboutJingMeiVC animated:YES];
        
    }else if ([name isEqualToString:@"当前版本"]) {
        
        
    }else if ([name isEqualToString:@"编辑资料"]) {
        JMMyInformationViewController *jmInformationVC = [JMMyInformationViewController new];
        [self.navigationController pushViewController:jmInformationVC animated:YES];
    }else if ([name isEqualToString:@"账号绑定"]) {
        JstyleNewsAccountBindingViewController *accountBindingVC = [JstyleNewsAccountBindingViewController new];
        [self.navigationController pushViewController:accountBindingVC animated:YES];
    }else if ([name isEqualToString:@"修改密码"]||[name isEqualToString:@"设置密码"]) {
        //设置密码 或 修改密码
        if ([[JstyleToolManager sharedManager] isAllreadySettedPWD]) {
            JstyleNewsChangePassworldViewController *changePWDVC = [JstyleNewsChangePassworldViewController new];
            [self.navigationController pushViewController:changePWDVC animated:YES];
        } else {
            JstyleNewsSettingPasswordViewController *settingPWDVC = [JstyleNewsSettingPasswordViewController new];
            [self.navigationController pushViewController:settingPWDVC animated:YES];
        }
    }
}

- (void)settingFontSize {
    JstyleNewsSettingFontView *fontView = [[UINib nibWithNibName:@"JstyleNewsSettingFontView" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
    fontView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    
    __weak typeof(fontView)weakFontView = fontView;
    fontView.fontSizeBlock = ^(NSString *fontString) {
        
        self.fontSizeLabel.text = fontString;
        
        [UIView animateWithDuration:0.4 animations:^{
            weakFontView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        } completion:^(BOOL finished) {
            [weakFontView removeFromSuperview];
        }];
    };
    
    fontView.cancleBtnBlock = ^{
        [UIView animateWithDuration:0.4 animations:^{
            weakFontView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        } completion:^(BOOL finished) {
            [weakFontView removeFromSuperview];
        }];
    };
    
    [self.view addSubview:fontView];
    
    [UIView animateWithDuration:0.5 animations:^{
        fontView.frame = [UIScreen mainScreen].bounds;
    }];
}

- (void)addSwitchBtn:(UISwitch *)switchBtn
{
    //    switchBtn.backgroundColor = [UIColor whiteColor];
    //    switchBtn.onTintColor = kPinkColor;
}

/**
 * 获取缓存大小
 */
- (float)filePathSize
{
    NSString * cachPath = [NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES) firstObject];
    CGFloat chaches = [self folderSizeAtPath :cachPath];
    return chaches;
}

/**
 *首先我们计算一下 单个文件的大小
 */
- (long long)fileSizeAtPath:(NSString *) filePath{
    
    NSFileManager * manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    return 0 ;
}

/**
 *遍历文件夹获得文件夹大小，返回多少 M（提示：你可以在工程界设置（)m）
 */

- (float)folderSizeAtPath:( NSString *)folderPath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    
    NSString * fileName;
    
    long long folderSize = 0 ;
    
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        
        folderSize += [self fileSizeAtPath :fileAbsolutePath];
        
    }
    return folderSize/( 1024.0 * 1024.0 );
}

/**清理缓存*/
- (void)cleanCache{
    [SVProgressHUD showWithStatus:@"清理中..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //清理所有缓存
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        for (NSString *p in files){
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"launchImgUrl"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"launchAdUrl"];
            [SVProgressHUD setCornerRadius:8];
            [SVProgressHUD showSuccessWithStatus:@"清理成功"];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.cacheLabel.text = @"0.00M";
                [SVProgressHUD dismiss];
            });
        });
    });
}

- (void)closeLoginAction{
    NTESActionSheet *actionSheet = [[NTESActionSheet alloc]initWithTitle:@"退出登录" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"退出"]];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}


#pragma mark -- actionSheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //        [[HuanXinLogin huanxinLogin] logoutChatAction];
        [[JstyleToolManager sharedManager] loginOut];
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"JSTYLENEWSLOGINOUTNOTIFICATION" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
        ZTShowAlertMessage(@"已退出登录");
    }
}

//wifi开关动作
- (void)wifiSwitchAction:(UISwitch *)switchButton {
    
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        //打开,仅允许WiFi状态下播放视频
        [[NSUserDefaults standardUserDefaults] setObject:@"PlayVideoOnlyWiFi" forKey:@"PlayVideoOnlyWiFi"];
    } else {
        //关闭
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PlayVideoOnlyWiFi"];
    }
    
}

// 关闭推送
-(void)switchAction:(id)sender
{
    ZTAlertView *alertView = [[ZTAlertView alloc] initWithTitle:@"提示" message:@"请在系统设置内修改通知权限" sureBtn:@"去设置" cancleBtn:@"取消"];
    alertView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            [[UIApplication sharedApplication] unregisterForRemoteNotifications];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }else{
            if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIUserNotificationTypeNone) {
                [_messageSwitch setOn:NO];
            }else{
                [_messageSwitch setOn:YES];
            }
        }
    };
    [alertView show];
}

- (void)dealloc {
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}

@end
