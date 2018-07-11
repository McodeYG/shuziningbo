//
//  JstyleMyHomeViewController.m
//  Exquisite
//
//  Created by 赵涛 on 2016/11/23.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import "JstyleMyHomeViewController.h"


///当前用户的iCity号账号类型
typedef enum : NSUInteger {
    JstyleMyHomeViewControllerRegisterJstyleAccountTypeDaiShenHe = 0,//待审核
    JstyleMyHomeViewControllerRegisterJstyleAccountTypeJuJue = 1,//拒绝
    JstyleMyHomeViewControllerRegisterJstyleAccountTypeTongGuo = 2,//通过
    JstyleMyHomeViewControllerRegisterJstyleAccountTypeWeiZhuCe = 3//未注册
} JstyleMyHomeViewControllerRegisterJstyleAccountType;


@interface JstyleMyHomeViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,NTESActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, weak) UILabel *navigationUserNameLabel;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowOrderLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionView *collectionOrderView;

@property (nonatomic, strong) NSMutableArray *menuArray;

@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, copy) NSString *shareImageurl;
@property (nonatomic, copy) NSString *ashareurl;
@property (nonatomic, copy) NSString *describes;

/**图片的base64编码*/
@property (nonatomic, copy) NSString *iconBase64Str;
/**我的信息字典*/
@property (nonatomic, strong) NSDictionary *myInforDict;

@property (nonatomic, weak) UIButton *settingBtn;
@property (nonatomic, weak) UIButton *messageBtn;
@property (nonatomic, weak) UILabel *moneyLabel;

@property (nonatomic, strong) UIImageView *inviteFriendImageView;//邀请好友
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *backHeaderImageView;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UIVisualEffectView *backHeaderEffectView;

@property (nonatomic, strong) JstyleNewsMineLoginUserInfoModel *userInfoModel;

@property (nonatomic, assign) BOOL isWhiteStatus;

@end

static NSString *JstyleMyHomeTableViewCellID = @"JstyleMyHomeTableViewCellID";
static NSString *JstyleMyHomeMenuCollectionViewCellID = @"JstyleMyHomeMenuCollectionViewCellID";

@implementation JstyleMyHomeViewController

- (NSMutableArray *)menuArray {
    if (_menuArray == nil) {
        _menuArray = [NSMutableArray arrayWithObjects:@"签到",@"管理iCity号",KNightModeTitle,@"主题换肤",@"最近阅读",@"我的关注",@"我的收藏",@"我的评论",@"客服",@"意见反馈",@"APP评分",@"关于我们", nil];
    }
    return _menuArray;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")? 0 : -YG_StatusAndNavightion_H), kScreenWidth, kScreenHeight + (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")? 0 : YG_StatusAndNavightion_H)) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")?(20+64):20), 0);
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[JstyleNewsBaseTableViewCell class] forCellReuseIdentifier:JstyleMyHomeTableViewCellID];
    }
    return _tableView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.itemSize = CGSizeMake(kScreenWidth / 4.0, 78);
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = kNightModeBackColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"JstyleMyHomeMenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:JstyleMyHomeMenuCollectionViewCellID];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowOrderLayout {
    if (_flowOrderLayout == nil) {
        _flowOrderLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowOrderLayout.minimumLineSpacing = 0;
        _flowOrderLayout.minimumInteritemSpacing = 0;
        _flowOrderLayout.itemSize = CGSizeMake(kScreenWidth / 5.0, 80);
    }
    return _flowOrderLayout;
}

- (UICollectionView *)collectionOrderView {
    if (_collectionOrderView == nil) {
        _collectionOrderView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80) collectionViewLayout:self.flowOrderLayout];
        _collectionOrderView.dataSource = self;
        _collectionOrderView.delegate = self;
        _collectionOrderView.backgroundColor = kWhiteColor;
        _collectionOrderView.showsVerticalScrollIndicator = NO;
        _collectionOrderView.showsHorizontalScrollIndicator = NO;
        [_collectionOrderView registerNib:[UINib nibWithNibName:@"JstyleMyHomeMenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:JstyleMyHomeMenuCollectionViewCellID];
    }
    return _collectionOrderView;
}

- (UIImageView *)inviteFriendImageView {
    //我的广告
    if (_inviteFriendImageView == nil) {
        _inviteFriendImageView = [[UIImageView alloc] init];
        _inviteFriendImageView.image = JSImage(@"我的-邀请好友");
        _inviteFriendImageView.frame = CGRectMake(10, 53, SCREEN_W-20, (SCREEN_W-20)*156.f/700.f);
        _inviteFriendImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inviteFriend)];
        [_inviteFriendImageView addGestureRecognizer:tap];
    }
    return _inviteFriendImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = kWhiteColor;
    
    [self setupNavigationItem];
    
    [self setupUI];
    
    [self getShareData];
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setNavigationBarBackgroundColor:[UIColor clearColor]];
    
    self.settingBtn.hidden = NO;
    self.messageBtn.hidden = NO;
    self.navigationBarView.hidden = NO;
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"] == nil ? @"" : [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    self.navigationUserNameLabel.text = userName;
    [self getUserInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    self.settingBtn.hidden = YES;
    self.messageBtn.hidden = YES;
    self.navigationBarView.hidden = YES;
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setupNavigationItem {
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    UIView *navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -YG_StatusBarH, kScreenWidth, YG_StatusAndNavightion_H)];
    self.navigationBarView = navigationBarView;
    navigationBarView.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar addSubview:navigationBarView];
    
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.settingBtn = settingBtn;
    [settingBtn setImage:JSImage(@"我的-设置") forState:UIControlStateNormal];
    
    settingBtn.frame = CGRectMake(5, YG_StatusBarH, 40, 44);
    
    [settingBtn addTarget:self action:@selector(settingItemClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarView addSubview:settingBtn];
    
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.messageBtn = messageBtn;
    [messageBtn setImage:JSImage(@"推荐-消息铃铛_white") forState:UIControlStateNormal];
    messageBtn.frame = CGRectMake((kScreenWidth-45), YG_StatusBarH , 40, 44);
    
    [messageBtn addTarget:self action:@selector(messageItemClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarView addSubview:messageBtn];
    
    NSString *useName = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"] == nil ? @"" : [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    UILabel *navigationUserNameLabel = [UILabel labelWithColor:kDarkThreeColor fontSize:18 text:useName];
    self.navigationUserNameLabel = navigationUserNameLabel;
    navigationUserNameLabel.alpha = 0;
    [navigationUserNameLabel sizeToFit];
    [navigationBarView addSubview:navigationUserNameLabel];
    [navigationUserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.offset(-8);
    }];
    
}

- (void)setupUI {
    
    //头部背景模糊图
    self.backHeaderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (271 + (IS_iPhoneX?24:0)))];
    self.backHeaderImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backHeaderImageView.clipsToBounds = YES;
    [self.view addSubview:self.backHeaderImageView];

    self.backHeaderEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    self.backHeaderEffectView.frame = CGRectMake(0, 0, self.backHeaderImageView.width, self.backHeaderImageView.height);
    self.backHeaderEffectView.clipsToBounds = YES;
    self.backHeaderEffectView.alpha = 0.9;
    [self.view addSubview:self.backHeaderEffectView];
    
}

#pragma mark - UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 237 : 0.00000;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 144 + 80 * (self.menuArray.count / 4);
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JstyleNewsBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JstyleMyHomeTableViewCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        
        UILabel *titleLabel = [UILabel labelWithColor:kDarkThreeColor fontSize:16 text:@"我的服务"];
        [cell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(15);
            make.left.offset(15);
        }];
        titleLabel.tag = 130;
        titleLabel.textColor = ISNightMode?kDarkNineColor:kDarkThreeColor;
        
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 10;
       
        
        [cell.contentView addSubview:self.inviteFriendImageView];
        
        [cell.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.inviteFriendImageView.mas_bottom).offset(20);
            make.left.right.offset(0);
            make.height.offset(240);
        }];
        
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JstyleMyHomeHeaderView *headerView = [[UINib nibWithNibName:@"JstyleMyHomeHeaderView" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
    
//    self.backgroundImageView = headerView.backgroundImageView;
//    self.effectView = headerView.effectView;
    
    if (self.userInfoModel) {
        headerView.userInfoModel = self.userInfoModel;
    }
    
    __weak typeof(self)weakSelf = self;
    
    //点击头像
    headerView.avatorClickBlock = ^{
        if ([[JstyleToolManager sharedManager] isTourist]) {
            [[JstyleToolManager sharedManager] loginInViewController];
            return;
        }
        
        NTESActionSheet *actionSheet = [[NTESActionSheet alloc]initWithTitle:@"选择相册或者相机" delegate:weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从相册选择"]];
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    };
    //收藏
    headerView.myCollectionBlock = ^{
        if ([[JstyleToolManager sharedManager] isTourist]) {
            [[JstyleToolManager sharedManager] loginInViewController];
            return;
        }
        
    };
    //订阅
    headerView.mySubcibeBlock = ^{
        if ([[JstyleToolManager sharedManager] isTourist]) {
            [[JstyleToolManager sharedManager] loginInViewController];
            return;
        }
        JstyleMySubscribeViewController *jstyleMySVC = [JstyleMySubscribeViewController new];
        [weakSelf.navigationController pushViewController:jstyleMySVC animated:YES];
    };
    //足迹
    headerView.myRecentBlock = ^{
        if ([[JstyleToolManager sharedManager] isTourist]) {
            [[JstyleToolManager sharedManager] loginInViewController];
            return;
        }
        
    };
    //查看VIP特权
    headerView.checkOutVIPRightsBlock = ^{
        [weakSelf isRegisterJMAccount];
    };
    
    return headerView;
}

#pragma mark - UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.menuArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JstyleMyHomeMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JstyleMyHomeMenuCollectionViewCellID forIndexPath:indexPath];
    
    if (collectionView == self.collectionView) {
        if (indexPath.item < self.menuArray.count) {
            cell.title = self.menuArray[indexPath.item];
        }
    }
    
    return cell;
}

#pragma mark - UICollectionDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.collectionView) {
        switch (indexPath.item) {
            case 0://签到
            {
                if ([[JstyleToolManager sharedManager] isTourist]) {
                    [[JstyleToolManager sharedManager] loginInViewController];
                    return;
                }
                JStyleDaySignInViewController *daySignInVC = [JStyleDaySignInViewController new];
                [self.navigationController pushViewController:daySignInVC animated:YES];
            }
                break;
            case 1://iCity号
            {
                if ([[JstyleToolManager sharedManager] isTourist]) {
                    [[JstyleToolManager sharedManager] loginInViewController];
                    return;
                }
                //判断是否注册过iCity号
                [self isRegisterJMAccount];
            }
                break;
            case 2://夜间模式按钮
            {
                if (ISNightMode) {//当前是夜间 按钮显示日间，点击按钮后界面为日间，按钮显示夜间
                    
                    [self.menuArray replaceObjectAtIndex:2 withObject:@"夜间"];
                    [[NightModeManager defaultManager]setNightModeName:Day];
                } else {
                    [self.menuArray replaceObjectAtIndex:2 withObject:@"日间"];
                    [[NightModeManager defaultManager]setNightModeName:Night];
                }
                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            
                
            }
                break;
            case 3://主题换肤
            {
                JstyleNewsThemeViewController * vc = [[JstyleNewsThemeViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 4://最近阅读
            {
//                if ([[JstyleToolManager sharedManager] isTourist]) {
//                    [[JstyleToolManager sharedManager] loginInViewController];
//                    return;
//                }
                JstyleNewsRecentReadViewController *recentReadVC = [JstyleNewsRecentReadViewController new];
                [self.navigationController pushViewController:recentReadVC animated:YES];
            }
                break;
            case 5://我的关注
            {
                if ([[JstyleToolManager sharedManager] isTourist]) {
                    [[JstyleToolManager sharedManager] loginInViewController];
                    return;
                }
                JstyleMySubscribeViewController *jstyleMySVC = [JstyleMySubscribeViewController new];
                [self.navigationController pushViewController:jstyleMySVC animated:YES];
            }
                break;
            case 6://我的收藏
            {
//                if ([[JstyleToolManager sharedManager] isTourist]) {
//                    [[JstyleToolManager sharedManager] loginInViewController];
//                    return;
//                }
                JstyleNewsMyCollectionViewController *collectionVC = [JstyleNewsMyCollectionViewController new];
                [self.navigationController pushViewController:collectionVC animated:YES];
            }
                break;
            case 7://我的评论
            {
                if ([[JstyleToolManager sharedManager] isTourist]) {
                    [[JstyleToolManager sharedManager] loginInViewController];
                    return;
                }
                JstyleNewsMyCommentViewController *commentVC = [JstyleNewsMyCommentViewController new];
                [self.navigationController pushViewController:commentVC animated:YES];
            }
                break;
            case 8://客服
            {
                ZTAlertView *alertView = [[ZTAlertView alloc]initWithTitle:@"400-6565-456" message:@"拨打电话" sureBtn:@"确认" cancleBtn:@"取消"];
                alertView.resultIndex = ^(NSInteger index){
                    if (index == 1) {
                        NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",@"4000788066"];
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
                    }
                };
                [alertView show];
            }
                break;
            case 9://意见反馈
            {
                JMFeedbackMessageViewController *feedbackVC = [JMFeedbackMessageViewController new];
                [self.navigationController pushViewController:feedbackVC animated:YES];
            }
                break;
            case 10://APP评分
            {
                // 评分页面地址
                NSString *scoreStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id1400108287?mt=8&action=write-review"];
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:scoreStr]]) {
                
                    if (@available(iOS 10.0, *)) {
                        NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly : @false};
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scoreStr]options:options completionHandler:nil];
                    } else {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scoreStr]];
                    }
                }
                
            }
                break;
            case 11://关于我们
            {
                JMAboutJingMeiViewController *aboutUSVC = [JMAboutJingMeiViewController new];
                [self.navigationController pushViewController:aboutUSVC animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - UIScrollViewDelegate 滑动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        CGFloat number = !SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")?0:YG_StatusAndNavightion_H;
        if (scrollView.contentOffset.y <= -number) {
            //上拉
            self.backgroundImageView.transform = CGAffineTransformIdentity;
            self.effectView.transform = CGAffineTransformIdentity;
            self.backHeaderImageView.transform = CGAffineTransformIdentity;
            self.backHeaderEffectView.transform = CGAffineTransformIdentity;
            
            CGFloat scale = (scrollView.contentOffset.y - (125 - number)) * 0.008;
            self.backgroundImageView.transform = CGAffineTransformScale(self.backgroundImageView.transform, -scale, -scale);
            self.effectView.transform = CGAffineTransformScale(self.effectView.transform, -scale, -scale);
            self.backHeaderImageView.transform = CGAffineTransformScale(self.backHeaderImageView.transform, -scale, -scale);
            self.backHeaderEffectView.transform = CGAffineTransformScale(self.backHeaderEffectView.transform, -scale, -scale);
            
            [self.settingBtn setImage:JSImage(@"我的-设置") forState:UIControlStateNormal];
            [self.messageBtn setImage:JSImage(@"推荐-消息铃铛_white") forState:UIControlStateNormal];

            self.navigationBarView.backgroundColor = [UIColor clearColor];
            self.isWhiteStatus = YES;
            
            self.navigationUserNameLabel.alpha = 0;
            
        } else {
            //下拉
            self.backgroundImageView.transform = CGAffineTransformIdentity;
            self.effectView.transform = CGAffineTransformIdentity;
            self.backHeaderImageView.transform = CGAffineTransformIdentity;
            self.backHeaderEffectView.transform = CGAffineTransformIdentity;
            
            CGFloat alpha = scrollView.contentOffset.y / (-number/2) - 1;

            [self.settingBtn setImage:JSImage(@"我的-设置黑") forState:UIControlStateNormal];
            [self.messageBtn setImage:JSImage(@"推荐-消息铃铛_black") forState:UIControlStateNormal];
            self.navigationBarView.backgroundColor = [UIColor colorWithWhite:1 alpha:-alpha];
            self.isWhiteStatus = NO;
            
            self.navigationUserNameLabel.alpha = -alpha;
        }
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

/// 获取分享数据
- (void)getShareData {
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[[JstyleToolManager sharedManager] getUserId],@"uid", nil];
    
    [manager GETURL:SAHRE_MYAPP_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            self.ashareurl = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"ashareurl"]];
            self.titleName = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"title"]];
            self.shareImageurl = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"poster"]];
            self.describes = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"describes"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}




- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[NightModeManager defaultManager]removeNighView];
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }else if (buttonIndex == 0){
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"相机不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
            return;
        }
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }else
        return;
}

///图片选择的代理方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [[NightModeManager defaultManager]showNightView];
    if (error) {
        NSLog(@"===%@",error);
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [[NightModeManager defaultManager]showNightView];
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    NSData *data;
    if ([type isEqualToString:@"public.image"]) {
        
        UIImage *originImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        UIImage *scaleImage = [self scaleImage:originImage toScale:0.3];
        
        if (UIImagePNGRepresentation(scaleImage) == nil) {
            data = UIImageJPEGRepresentation(scaleImage, 0.5);
        } else {
            data = UIImagePNGRepresentation(scaleImage);
        }
        _iconBase64Str = [data base64EncodedStringWithOptions:0];
    }
    [self postJMHeaderImageDataSource];
    
}

/// 上传头像
- (void)postJMHeaderImageDataSource {
    [SVProgressHUD showWithStatus:@"上传中..."];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[[JstyleToolManager sharedManager] getUserId],@"uid",_iconBase64Str,@"upload", nil];
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    [manager POSTURL:MY_POSTICON_URL parameters:parameters success:^(id responseObject) {
        [SVProgressHUD dismiss];
        ZTShowAlertMessage(responseObject[@"data"]);
        [self getUserInfo];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        ZTShowAlertMessage(@"上传失败");
    }];
}

#pragma mark - 获取当前用户当前注册iCity号的状态
- (void)isRegisterJMAccount {
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    NSDictionary *paramaters = @{@"uid":[[JstyleToolManager sharedManager] getUserId]};
    
    [manager GETURL:MANAGER_ISREGESTER_URL parameters:paramaters success:^(id responseObject) {
        NSDictionary *responseData = responseObject;
        
        if ([responseData[@"code"] integerValue] == 1) {
            
            NSDictionary *msg = responseData[@"data"];
            
            JstyleMyHomeViewControllerRegisterJstyleAccountType type = (JstyleMyHomeViewControllerRegisterJstyleAccountType)[msg[@"status"] integerValue];
            [SVProgressHUD dismiss];
            
            switch (type) {
                case JstyleMyHomeViewControllerRegisterJstyleAccountTypeDaiShenHe:
                    //待审核
                {
                    JstyleManagementAccoutStatusDaiShenHeViewController *jstyleManagementASVC = [JstyleManagementAccoutStatusDaiShenHeViewController new];
                    jstyleManagementASVC.statusString = @"您的账号正在审核，请耐心等待！";
                    [self.navigationController pushViewController:jstyleManagementASVC animated:YES];
                }
                    break;
                case JstyleMyHomeViewControllerRegisterJstyleAccountTypeJuJue:
                    //拒绝
                {
                    JstyleManagementAccoutStatusViewController *jstyleManagementASVC = [JstyleManagementAccoutStatusViewController new];
                    jstyleManagementASVC.statusString = msg[@"reason"];
                    [self.navigationController pushViewController:jstyleManagementASVC animated:YES];
                }
                    break;
                case JstyleMyHomeViewControllerRegisterJstyleAccountTypeTongGuo:
                    //通过
                {
                    if ([msg[@"is_use"] integerValue] == 0) {
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您的账号已被禁用，请联系iCity，通过客服邮箱icity_developer@sina.com与我们联系。" message:nil preferredStyle:UIAlertControllerStyleAlert];
                        [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            
                        }]];
                        [self presentViewController:alertController animated:YES completion:nil];
                        
                    } else {
                        JstyleManagementMyJstyleAccountViewController *jstyleMMJAVC = [JstyleManagementMyJstyleAccountViewController new];
                        [self.navigationController pushViewController:jstyleMMJAVC animated:YES];
                    }
                }
                    break;
                case JstyleMyHomeViewControllerRegisterJstyleAccountTypeWeiZhuCe:
                    //未注册
                {
                    JstyleAuthenticateAccountViewController *authenticateAccountVC = [JstyleAuthenticateAccountViewController new];
                    [self.navigationController pushViewController:authenticateAccountVC animated:YES];
                }
                    break;
                default:
                    break;
            }
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD dismiss];
    }];
}


///登陆成功后获取"我的信息"
- (void)getUserInfo {
    
    JstyleToolManager *tool = [JstyleToolManager sharedManager];
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    NSDictionary *paramaters = @{ @"uid":[tool getUserId]  };
    [manager GETURL:LOGIN_USERINFO_URL parameters:paramaters success:^(id responseObject) {
        
        NSDictionary *dictionary = responseObject;
        
        if ([dictionary[@"code"] isEqualToString:@"1"]) {
            self.userInfoModel = [JstyleNewsMineLoginUserInfoModel modelWithJSON:dictionary[@"data"]];
            
            //保存本地
            [[NSUserDefaults standardUserDefaults] setObject:self.userInfoModel.phone forKey:@"phone"];
            [[NSUserDefaults standardUserDefaults] setObject:self.userInfoModel.isbetauser forKey:@"isbetauser"];
            
            //保存头像url
            [[NSUserDefaults standardUserDefaults] setObject:self.userInfoModel.poster forKey:@"headimgurl"];
            
            //保存头像Image
            [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:self.userInfoModel.poster] options:YYWebImageOptionProgressive progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                
                if (stage == YYWebImageStageFinished) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:@"UserPosterImage"];
                    });
                } else {
                    NSLog(@"%@",error);
                }
            }];
            
        }
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableView reloadData];
    }];
}

///缩放图片
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize {
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (void)inviteFriend {
    if ([[JstyleToolManager sharedManager] isTourist]) {
        [[JstyleToolManager sharedManager] loginInViewController];
        return;
    }
    JstyleNewsActivityWebViewController *inviteVC = [[JstyleNewsActivityWebViewController alloc] init];
    inviteVC.urlString = @"https://mkh.qikan.com/promotion/p?id=5a3a0ff275657100436719b8&channel=500";
    [self.navigationController pushViewController:inviteVC animated:YES];
}

- (void)settingItemClick {
    JstyleNewsSettingViewController *settingVC = [JstyleNewsSettingViewController new];
    [self.navigationController pushViewController:settingVC animated:YES];
//    JMMySettingViewController *settingVC = [JMMySettingViewController new];
//    settingVC.isSettedPwd = [[JstyleToolManager sharedManager] isAllreadySettedPWD];
//    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)messageItemClick {
    if ([[JstyleToolManager sharedManager] isTourist]) {
        [[JstyleToolManager sharedManager] loginInViewController];
        return;
    }
    JstyleNewsMyMessageViewController *messageVC = [JstyleNewsMyMessageViewController new];
    [self.navigationController pushViewController:messageVC animated:YES];
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return self.isWhiteStatus?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
//}

//夜间模式
-(void)applyTheme {
    [super applyTheme];
    
    self.collectionView.backgroundColor = kNightModeBackColor;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    JstyleNewsBaseTableViewCell *cell = (JstyleNewsBaseTableViewCell *) [_tableView cellForRowAtIndexPath:indexPath];
    for (UILabel * titleLabel in cell.contentView.subviews) {
        if (titleLabel.tag ==130) {
            titleLabel.textColor = ISNightMode?kDarkNineColor:kDarkThreeColor;

        }
    }
    
}
//关于IOS 11 下，图片编辑界面左下角的cancel 按钮很难点击的问题
//https://blog.csdn.net/gzgengzhen/article/details/80320518
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 11)
    {
        return;
    }
    if ([viewController isKindOfClass:NSClassFromString(@"PUPhotoPickerHostViewController")])
    {
        [viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             // iOS 11之后，图片编辑界面最上层会出现一个宽度<42的view，会遮盖住左下方的cancel按钮，使cancel按钮很难被点击到，故改变该view的层级结构
             if (obj.frame.size.width < 42)
             {
                 [viewController.view sendSubviewToBack:obj];
                 *stop = YES;
             }
         }];
    }
}


@end
