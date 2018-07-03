//
//  JstyleAuthenticateAccountViewController.m
//  Exquisite
//
//  Created by 数字跃动 on 2017/10/10.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleAuthenticateAccountViewController.h"
#import "JstyleManagementVerificationSelectedView.h"
#import "JstyleManagementVerificationWriteView.h"
#import "JstyleManagementVerificationWriteMoreView.h"
#import "JstyleManagementVerificationUploadImageView.h"
#import "JstyleManagementVerificationUploadIDCardView.h"
#import "JstyleManagementVerificationTextView.h"
#import "JstyleManagementVerificationAgreeProtocolView.h"

#import "JstyleManagementAddUserMediaModel.h"
#import "JstyleManagementUserMediaForlModel.h"
#import "JstyleManagementUserInformationModel.h"

#import "JstyleManagementAccoutStatusViewController.h"
#import "JstyleManagementAccoutStatusDaiShenHeViewController.h"
#import "JstyleNewsImagePickerViewController.h"

#define kPickerViewHeight (IS_iPhoneX?230:200)
#define kToolBarHeight 40

typedef enum : NSUInteger {
    JstyleAuthenticateAccountPickerViewTypeMedia,
    JstyleAuthenticateAccountPickerViewTypeField ,
    JstyleAuthenticateAccountPickerViewTypeLocation
} JstyleAuthenticateAccountPickerViewType;

@interface JstyleAuthenticateAccountViewController () <UIPickerViewDataSource, UIPickerViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) JstyleNewsBaseTableView *mediaTableView;
@property (nonatomic, strong) JstyleNewsBaseTableView *operatorTableView;
@property (nonatomic, strong) JstyleNewsBaseTableView *mobileTableView;

@property (nonatomic, strong) UIButton *mediaInfoBtn;
@property (nonatomic, strong) UIButton *operatorInfoBtn;
@property (nonatomic, strong) UIButton *mobileAuthenticationBtn;
@property (nonatomic, strong) UIButton *nextStepBtn;
@property (nonatomic, strong) UIButton *previousStepBtn;
@property (nonatomic, strong) UIButton *operatorNextStepBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIView *mobileAuthenticationView;

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *toolBar;

@property (nonatomic, weak) JstyleManagementVerificationSelectedView *mediaTypeView;
@property (nonatomic, weak) JstyleManagementVerificationUploadImageView *mediaSelectImageView;
@property (nonatomic, weak) JstyleManagementVerificationWriteView *mobileAuthenticationPhoneNumView;
@property (nonatomic, weak) JstyleManagementVerificationWriteView *mobileAuthenticationNumberView;
@property (nonatomic, weak) JstyleManagementVerificationSelectedView *mediaTypeCell;
@property (nonatomic, weak) JstyleManagementVerificationWriteView *mediaNameCell;
@property (nonatomic, weak) JstyleManagementVerificationWriteMoreView *mediaInstructionCell;
@property (nonatomic, weak) JstyleManagementVerificationUploadImageView *mediaHeadImgCell;
@property (nonatomic, weak) JstyleManagementVerificationWriteView *operatorNameCell;
@property (nonatomic, weak) JstyleManagementVerificationWriteView *operatorOrganizationNameCell;
@property (nonatomic, weak) JstyleManagementVerificationWriteView *operatorIDCardCell;
@property (nonatomic, weak) JstyleManagementVerificationWriteView *operatorOrganizationIDCardCell;
@property (nonatomic, weak) JstyleManagementVerificationUploadIDCardView *operatorIDphotoCell;
@property (nonatomic, weak) JstyleManagementVerificationUploadIDCardView *operatorOrganizationIDphotoCell;
@property (nonatomic, weak) JstyleManagementVerificationWriteView *operatorPhoneCell;
@property (nonatomic, weak) JstyleManagementVerificationWriteView *operatorOrganizationPhoneCell;
@property (nonatomic, weak) JstyleManagementVerificationSelectedView *operatorFieldCell;
@property (nonatomic, weak) JstyleManagementVerificationSelectedView *operatorOrganizationFieldCell;
@property (nonatomic, weak) JstyleManagementVerificationSelectedView *operatorLocationCell;
@property (nonatomic, weak) JstyleManagementVerificationSelectedView *operatorOrganizationLocationCell;
@property (nonatomic, weak) JstyleManagementVerificationUploadImageView *operatorIntelligenceCell;
@property (nonatomic, weak) JstyleManagementVerificationUploadImageView *operatorOrganizationIntelligenceCell;
@property (nonatomic, weak) JstyleManagementVerificationWriteView *operatorMailcell;
@property (nonatomic, weak) JstyleManagementVerificationWriteView *operatorOrganizationMailcell;
@property (nonatomic, weak) JstyleManagementVerificationWriteView *operatorOrganizationUserNameCell;
@property (nonatomic, weak) JstyleManagementVerificationUploadImageView *operatorOrganizationImageCell;
@property (nonatomic, weak) JstyleManagementVerificationAgreeProtocolView *agreeCell;
@property (nonatomic, weak) UIButton *agreeBtn;
@property (nonatomic, weak) UIButton *agreeOrganizationBtn;


@property (nonatomic, strong) JstyleManagementAddUserMediaModel *uploadModel;

@property (nonatomic, strong) NSMutableDictionary *uploadData;

//通过pickerView修改哪个按钮的文字
@property (nonatomic, strong) UIButton *changeWhichTitleBtn;
//通过选取照片修改哪个按钮的图片
@property (nonatomic, strong) UIButton *changeWhichImageBtn;
//协议webView
@property (nonatomic, weak) UIWebView *protocolWebView;
@property (nonatomic, weak) UIButton *yanZhengMaBtn;


//领域名数组
@property (nonatomic, strong) NSArray *fieldNameArray;
//所在地名数组
@property (nonatomic, strong) NSArray *loacationNameArray;
//uniqueid
@property (nonatomic, copy) NSString *uniqueid;
//用户信息数据
@property (nonatomic, strong) JstyleManagementUserInformationModel *userInformationModel;

@property (nonatomic, assign) JstyleAuthenticateAccountPickerViewType pickerViewType;

@end

static NSString *JstyleManagementVerificationTextViewCellID = @"JstyleManagementVerificationTextViewCellID";
static NSString *JstyleManagementVerificationSelectedViewCellID = @"JstyleManagementVerificationSelectedViewCellID";
static NSString *JstyleManagementVerificationWriteViewCellID = @"JstyleManagementVerificationWriteViewCellID";
static NSString *JstyleManagementVerificationWriteMoreViewCellID = @"JstyleManagementVerificationWriteMoreViewCellID";
static NSString *JstyleManagementVerificationUploadImageViewCellID = @"JstyleManagementVerificationUploadImageViewCellID";
static NSString *JstyleManagementVerificationUploadIDCardViewCellID = @"JstyleManagementVerificationUploadIDCardViewCellID";
static NSString *JstyleManagementVerificationAgreeProtocolViewCellID = @"JstyleManagementVerificationAgreeProtocolViewCellID";

@implementation JstyleAuthenticateAccountViewController

- (JstyleManagementAddUserMediaModel *)uploadModel {
    if (_uploadModel == nil) {
        _uploadModel = [JstyleManagementAddUserMediaModel new];
    }
    return _uploadModel;
}

- (NSMutableDictionary *)uploadData {
    if (_uploadData == nil) {
        _uploadData = [NSMutableDictionary dictionary];
    }
    return _uploadData;
}

- (UITableView *)mediaTableView {
    if (_mediaTableView == nil) {
        _mediaTableView = [[JstyleNewsBaseTableView alloc] initWithFrame:CGRectZero
                                                       style:UITableViewStylePlain];
        _mediaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerTableViewCellWithTableView:_mediaTableView];
    }
    return _mediaTableView;
}

- (UITableView *)operatorTableView {
    if (_operatorTableView == nil) {
        _operatorTableView = [[JstyleNewsBaseTableView alloc] initWithFrame:CGRectZero
                                                          style:UITableViewStylePlain];
        _operatorTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerTableViewCellWithTableView:_operatorTableView];
    }
    return _operatorTableView;
}

- (UITableView *)mobileTableView {
    if (_mobileTableView == nil) {
        _mobileTableView = [[JstyleNewsBaseTableView alloc] initWithFrame:CGRectZero
                                                        style:UITableViewStylePlain];
        _mobileTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerTableViewCellWithTableView:_mobileTableView];
    }
    return _mobileTableView;
}

- (void)registerTableViewCellWithTableView:(UITableView *)tableView {
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 50;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"JstyleManagementVerificationTextView" bundle:nil] forCellReuseIdentifier:JstyleManagementVerificationTextViewCellID];
    [tableView registerNib:[UINib nibWithNibName:@"JstyleManagementVerificationSelectedView" bundle:nil] forCellReuseIdentifier:JstyleManagementVerificationSelectedViewCellID];
    [tableView registerNib:[UINib nibWithNibName:@"JstyleManagementVerificationWriteView" bundle:nil] forCellReuseIdentifier:JstyleManagementVerificationWriteViewCellID];
    [tableView registerNib:[UINib nibWithNibName:@"JstyleManagementVerificationWriteMoreView" bundle:nil] forCellReuseIdentifier:JstyleManagementVerificationWriteMoreViewCellID];
    [tableView registerNib:[UINib nibWithNibName:@"JstyleManagementVerificationUploadImageView" bundle:nil] forCellReuseIdentifier:JstyleManagementVerificationUploadImageViewCellID];
    [tableView registerNib:[UINib nibWithNibName:@"JstyleManagementVerificationUploadIDCardView" bundle:nil] forCellReuseIdentifier:JstyleManagementVerificationUploadIDCardViewCellID];
    [tableView registerNib:[UINib nibWithNibName:@"JstyleManagementVerificationAgreeProtocolView" bundle:nil] forCellReuseIdentifier:JstyleManagementVerificationAgreeProtocolViewCellID];
}

- (UIPickerView *)pickerView {
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView = [UIPickerView new];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.backgroundColor = kManagementGrayColor;
    }
    return _pickerView;
}

- (UIView *)toolBar {
    if (_toolBar == nil) {
        _toolBar = [[UIView alloc] init];
        _toolBar = [UIView new];
        _toolBar.backgroundColor = kWhiteColor;
        
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [doneBtn setTitleColor:kDarkTwoColor forState:UIControlStateNormal];
        doneBtn.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:14];
        [doneBtn sizeToFit];
        [doneBtn addTarget:self action:@selector(doneBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [doneBtn sizeToFit];
        doneBtn.frame = CGRectMake(kScreenWidth - doneBtn.width - 15, _toolBar.center.y+5, 30, 32);
        [_toolBar addSubview:doneBtn];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        line1.backgroundColor = kManagementGrayColor;
        [_toolBar addSubview:line1];
    }
    return _toolBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载领域和所在地数据
    [self loadUserMediaForlData];
    [self setupNavigation];
    
    [self setupMediaInfoView];
    [self setupOperatorInfoView];
    [self setupMobileAuthenticationView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = YES;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self addNavigationBarView];
}

- (void)addNavigationBarView
{
    self.navigationController.navigationBar.hidden = YES;
    
    UIImageView *navigationBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, YG_StatusAndNavightion_H)];
    navigationBarView.userInteractionEnabled = YES;

    navigationBarView.lee_theme
    .LeeCustomConfig(ThemeManagementNavigationBarBottomImage, ^(id item, id value) {
        UIImage *bgImage = [value resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
        [navigationBarView setImage:bgImage];
    });
    [self.view addSubview:navigationBarView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 80)/2, StatusBarHeight, 80, NavigationBarHeight)];
    titleLabel.text = @"iCity号";//管理我的
    titleLabel.textColor = kWhiteColor;
    titleLabel.font = JSFontWithWeight(16, UIFontWeightRegular);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lee_theme
    .LeeConfigTextColor(ThemeDiscoveryNavigationBarTitleColor);
    [navigationBarView addSubview:titleLabel];
    
    UIButton *leftBtn = [[UIButton alloc] init];
    [leftBtn setImage:([ThemeTool isWhiteModel]?JSImage(@"图文返回黑"):JSImage(@"返回白色")) forState:(UIControlStateNormal)];
    [leftBtn addTarget:self action:@selector(leftBarButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [navigationBarView addSubview:leftBtn];
    leftBtn.sd_layout
    .topSpaceToView(navigationBarView, 30 + (IS_iPhoneX?26:0))
    .leftSpaceToView(navigationBarView, 7)
    .widthIs(25)
    .heightIs(25);
    
    leftBtn.lee_theme
    .LeeCustomConfig(ThemeManagementNavigationBarLeftItem, ^(id item, id value) {
        [item setImage:value forState:(UIControlStateNormal)];
    });
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return [[LEETheme currentThemeTag] isEqualToString:ThemeName_White] ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
}

- (void)leftBarButtonAction
{
    if (self.pushOrPresentType == 1025) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
    [self dismissPickerView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)setupNavigation {
    
    UIButton *mediaInfoBtn = [self creatInfoButtonWithTitle:@"媒体信息" backgroundImageTag:@"1"];
    self.mediaInfoBtn = mediaInfoBtn;
    [self.view addSubview:mediaInfoBtn];
    [mediaInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(YG_StatusAndNavightion_H);
        make.left.offset(0);
        make.width.offset((kScreenWidth) / 3);
        make.height.offset(45);
    }];
    mediaInfoBtn.selected = YES;
    
    UIButton *operatorInfoBtn = [self creatInfoButtonWithTitle:@"运营者信息" backgroundImageTag:@"2"];
    self.operatorInfoBtn = operatorInfoBtn;
    [self.view addSubview:operatorInfoBtn];
    [operatorInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(mediaInfoBtn);
        make.left.equalTo(mediaInfoBtn.mas_right);
        make.width.offset((kScreenWidth) / 3);
        make.height.offset(45);
    }];
    operatorInfoBtn.selected = NO;
    
    UIButton *mobileAuthenticationBtn = [self creatInfoButtonWithTitle:@"手机验证" backgroundImageTag:@"3"];
    self.mobileAuthenticationBtn = mobileAuthenticationBtn;
    [self.view addSubview:mobileAuthenticationBtn];
    [mobileAuthenticationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(mediaInfoBtn);
        make.left.equalTo(operatorInfoBtn.mas_right);
        make.width.offset((kScreenWidth) / 3);
        make.height.offset(45);
    }];
    mobileAuthenticationBtn.selected = NO;
    
}

- (UIButton *)creatInfoButtonWithTitle:(NSString *)title backgroundImageTag:(NSString *)imageTag {
    
    NSString *currentThemeName = [LEETheme currentThemeTag];
    NSString *themeName;
    if ([currentThemeName isEqualToString:ThemeName_Red]) {
        themeName = @"红色";
    } else if ([currentThemeName isEqualToString:ThemeName_White]) {
        themeName = @"白色";
    } else if ([currentThemeName isEqualToString:ThemeName_Blue]) {
        themeName = @"蓝色";
    } else if ([currentThemeName isEqualToString:ThemeName_Black]) {
        themeName = @"黑色";
    } else if ([currentThemeName isEqualToString:ThemeName_Purple]) {
        themeName = @"紫色";
    } else {
        themeName = @"金色";
    }
    
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoBtn setTitle:title forState:UIControlStateNormal];
    [infoBtn setTitleColor:([currentThemeName isEqualToString:ThemeName_White] ? kDarkTwoColor : kWhiteColor) forState:UIControlStateNormal];
    [infoBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"我的-下-%@无缺角-%@",imageTag,themeName]] forState:UIControlStateNormal];
    [infoBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"我的-下-%@-%@",imageTag,themeName]] forState:UIControlStateSelected];
    
    infoBtn.adjustsImageWhenHighlighted = NO;
    infoBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    infoBtn.userInteractionEnabled = NO;
    [infoBtn addTarget:self action:@selector(infoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return infoBtn;
}

- (void)infoButtonClick:(UIButton *)button {
    
    if ([button.titleLabel.text isEqualToString:@"媒体信息"]) {
        [self previousStepBtnClick:button];
    } else if ([button.titleLabel.text isEqualToString:@"运营者信息"]) {
        [self nextStepBtnClick];
        
        self.mediaInfoBtn.selected = NO;
        self.operatorInfoBtn.selected = YES;
        self.mobileAuthenticationBtn.selected = NO;
        
        self.mediaTableView.hidden = YES;
        self.operatorTableView.hidden = NO;
        self.mobileAuthenticationView.hidden = YES;
        
        self.nextStepBtn.hidden = YES;
        self.previousStepBtn.hidden = NO;
        self.operatorNextStepBtn.hidden = NO;
        self.confirmBtn.hidden = YES;
    } else if ([button.titleLabel.text isEqualToString:@"手机验证"]) {
        [self operatorNextStepBtn];
        
        self.mediaInfoBtn.selected = NO;
        self.operatorInfoBtn.selected = NO;
        self.mobileAuthenticationBtn.selected = YES;
        
        self.mediaTableView.hidden = YES;
        self.operatorTableView.hidden = YES;
        self.mobileAuthenticationView.hidden = NO;
        
        self.nextStepBtn.hidden = YES;
        self.previousStepBtn.hidden = YES;
        self.operatorNextStepBtn.hidden = YES;
        self.confirmBtn.hidden = NO;
    }
}

#pragma mark - 搭建媒体信息
- (void)setupMediaInfoView {
    
    [self.view addSubview:self.mediaTableView];
    [self.mediaTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mediaInfoBtn.mas_bottom);
        make.left.right.offset(0);
        make.bottom.offset(-45);
    }];
    self.mediaTableView.hidden = NO;
    
    
    UIButton *nextStepBtn = [[UIButton alloc] init];
    self.nextStepBtn = nextStepBtn;
    [nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextStepBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [nextStepBtn setBackgroundColor:kManagementRedColor];
    nextStepBtn.layer.cornerRadius = 38 / 2;
    nextStepBtn.layer.masksToBounds = YES;
    [self.view addSubview:nextStepBtn];
    nextStepBtn.lee_theme
    .LeeConfigBackgroundColor(ThemeMainBtnTitleOrBorderColor);
    
    if (IS_iPhoneX) {
        [nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(27);
            make.right.offset(-27);
            make.bottom.offset(-40);
            make.height.offset(38);
        }];
    } else {
        [nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(27);
            make.right.offset(-27);
            make.bottom.offset(-30);
            make.height.offset(38);
        }];
    }
    
    
    [nextStepBtn addTarget:self action:@selector(nextStepBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 搭建运营者信息
- (void)setupOperatorInfoView {
    
    [self.view addSubview:self.operatorTableView];
    [self.operatorTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mediaInfoBtn.mas_bottom);
        make.left.right.offset(0);
        make.bottom.offset(-45);
    }];
    self.operatorTableView.hidden = YES;
    
    UIButton *previousStepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.previousStepBtn = previousStepBtn;
    [previousStepBtn setTitle:@"上一步" forState:UIControlStateNormal];
    previousStepBtn.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:15];
    [previousStepBtn setTitleColor:kDarkFiveColor forState:UIControlStateNormal];
    [previousStepBtn setBackgroundColor:[UIColor colorFromHex:0xF4F5F6]];
    previousStepBtn.layer.cornerRadius = 38 / 2;
    previousStepBtn.layer.masksToBounds = YES;
    [previousStepBtn addTarget:self action:@selector(previousStepBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:previousStepBtn];
    
    if (IS_iPhoneX) {
        [previousStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.bottom.offset(-40);
            make.height.offset(38);
            make.width.offset(kScreenWidth * 0.435);
        }];
    } else {
        [previousStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.bottom.offset(-30);
            make.height.offset(38);
            make.width.offset(kScreenWidth * 0.435);
        }];
    }
    
    UIButton *operatorNextStepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.operatorNextStepBtn = operatorNextStepBtn;
    [operatorNextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [operatorNextStepBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    operatorNextStepBtn.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:15];
    operatorNextStepBtn.lee_theme
    .LeeConfigBackgroundColor(ThemeMainBtnTitleOrBorderColor);
    
    operatorNextStepBtn.layer.cornerRadius = 38 / 2;
    operatorNextStepBtn.layer.masksToBounds = YES;

//    [operatorNextStepBtn setBackgroundColor:kManagementRedColor];
    [operatorNextStepBtn addTarget:self action:@selector(operatorNextStepBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:operatorNextStepBtn];
    
    if (IS_iPhoneX) {
        [operatorNextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-10);
            make.bottom.offset(-40);
            make.height.offset(38);
            make.width.offset(kScreenWidth * 0.435);
        }];
    } else {
        [operatorNextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-10);
            make.bottom.offset(-30);
            make.height.offset(38);
            make.width.offset(kScreenWidth * 0.435);
        }];
    }
    
    previousStepBtn.hidden = YES;
    operatorNextStepBtn.hidden = YES;
}

#pragma mark - 搭建手机验证
- (void)setupMobileAuthenticationView {
    
    JstyleNewsBaseView *mobileAuthenticationView = [JstyleNewsBaseView new];
    self.mobileAuthenticationView = mobileAuthenticationView;
    [self.view addSubview:mobileAuthenticationView];
    [mobileAuthenticationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mobileAuthenticationBtn.mas_bottom);
        make.left.right.bottom.offset(0);
    }];
    
    mobileAuthenticationView.hidden = YES;
    
    JstyleManagementVerificationWriteView *mobileAuthenticationPhoneNumView = [[UINib nibWithNibName:@"JstyleManagementVerificationWriteView" bundle:nil] instantiateWithOwner:self options:0].firstObject;
    self.mobileAuthenticationPhoneNumView = mobileAuthenticationPhoneNumView;
    mobileAuthenticationPhoneNumView.isShortTextField = YES;
    mobileAuthenticationPhoneNumView.titleLabel.text = @"请输入手机号";
    mobileAuthenticationPhoneNumView.textField.attributedPlaceholder = [@"请输入手机号" attributedColorStringWithTextColor:ISNightMode?kDarkNineColor:kPlaceholderColor font:JSFont(12)];
    mobileAuthenticationPhoneNumView.textField.keyboardType = UIKeyboardTypeNumberPad;
    [mobileAuthenticationView addSubview:mobileAuthenticationPhoneNumView];
    [mobileAuthenticationPhoneNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(50);
    }];
    
    JstyleManagementVerificationWriteView *mobileAuthenticationNumberView = [[UINib nibWithNibName:@"JstyleManagementVerificationWriteView" bundle:nil] instantiateWithOwner:self options:0].firstObject;
    self.mobileAuthenticationNumberView = mobileAuthenticationNumberView;
    mobileAuthenticationNumberView.isShortTextField = YES;
    mobileAuthenticationNumberView.titleLabel.text = @"请输入验证码";
    mobileAuthenticationNumberView.textField.attributedPlaceholder = [@"请输入验证码" attributedColorStringWithTextColor:ISNightMode?kDarkNineColor:kPlaceholderColor font:JSFont(12)];
    mobileAuthenticationNumberView.textField.keyboardType = UIKeyboardTypePhonePad;
    [mobileAuthenticationView addSubview:mobileAuthenticationNumberView];
    [mobileAuthenticationNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mobileAuthenticationPhoneNumView.mas_bottom);
        make.left.right.offset(0);
        make.height.offset(50);
    }];
    
    UIButton *yanZhengMaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.yanZhengMaBtn = yanZhengMaBtn;
    [yanZhengMaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//    [yanZhengMaBtn setTitleColor:kManagementRedColor forState:UIControlStateNormal];
    yanZhengMaBtn.lee_theme
    .LeeConfigButtonTitleColor(ThemeMainBtnTitleOrBorderColor, UIControlStateNormal);
    yanZhengMaBtn.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:13];
    [yanZhengMaBtn addTarget:self action:@selector(yanZhengMaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [yanZhengMaBtn sizeToFit];
    [mobileAuthenticationNumberView.textField addSubview:yanZhengMaBtn];
    [yanZhengMaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.offset(-4);
    }];
    
    UIButton *confirmBtn = [[UIButton alloc] init];
    self.confirmBtn = confirmBtn;
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    confirmBtn.layer.cornerRadius = 38 / 2;
    confirmBtn.layer.masksToBounds = YES;
//    [confirmBtn setBackgroundColor:kManagementRedColor];
    [mobileAuthenticationView addSubview:confirmBtn];
    confirmBtn.lee_theme
    .LeeConfigBackgroundColor(ThemeMainBtnTitleOrBorderColor);
    
    if (IS_iPhoneX) {
        [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(27);
            make.right.offset(-27);
            make.bottom.offset(-40);
            make.height.offset(38);
        }];
    } else {
        [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(27);
            make.right.offset(-27);
            make.bottom.offset(-30);
            make.height.offset(38);
        }];
    }
    
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.hidden = YES;
}

#pragma mark - PickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (self.pickerViewType) {
        case JstyleAuthenticateAccountPickerViewTypeMedia:
        {
            return 2;
        }
            break;
        case JstyleAuthenticateAccountPickerViewTypeField:
        {
            return self.fieldNameArray.count;
        }
            break;
        case JstyleAuthenticateAccountPickerViewTypeLocation:
        {
            return self.loacationNameArray.count;
        }
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (self.pickerViewType) {
        case JstyleAuthenticateAccountPickerViewTypeMedia:
        {
            if (row == 0) {
                return @"个人媒体";
            } else {
                return @"企业媒体";
            }
        }
            break;
        case JstyleAuthenticateAccountPickerViewTypeField:
        {
            return [self.fieldNameArray[row] name];
        }
            break;
        case JstyleAuthenticateAccountPickerViewTypeLocation:
        {
            return [self.loacationNameArray[row] name];
        }
            break;
        default:
            return @"暂无数据";
            break;
    }
}

#pragma mark - PickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.changeWhichTitleBtn setTitleColor:ISNightMode?kDarkNineColor:kDarkTwoColor forState:UIControlStateNormal];
    switch (self.pickerViewType) {
        case JstyleAuthenticateAccountPickerViewTypeMedia:
        {
            NSString *title = @"";
            if (row == 0) {
                title = @"个人媒体";
            } else if (row == 1) {
                title = @"企业媒体";
            }
            [self.changeWhichTitleBtn setTitle:title forState:UIControlStateNormal];
        }
            break;
        case JstyleAuthenticateAccountPickerViewTypeField:
        {
            
            [self.changeWhichTitleBtn setTitle:[self.fieldNameArray[row] name] forState:UIControlStateNormal];
        }
            break;
        case JstyleAuthenticateAccountPickerViewTypeLocation:
        {
            [self.changeWhichTitleBtn setTitle:[self.loacationNameArray[row] name] forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    
}

// TODO: 弹出选择媒体类型
- (void)selectMediaTypeBtnClick:(UIButton *)button {
    
    NSLog(@"弹出选择媒体类型");
    self.pickerViewType = JstyleAuthenticateAccountPickerViewTypeMedia;
    self.changeWhichTitleBtn = button;
    
    [self showPickerView];
    [button setTitle:@"个人媒体" forState:UIControlStateNormal];
}

// TODO: 弹出选择媒体领域
- (void)selectMediaDomainBtnClick:(UIButton *)button {
    
    NSLog(@"弹出选择媒体领域");
    self.pickerViewType = JstyleAuthenticateAccountPickerViewTypeField;
    self.changeWhichTitleBtn = button;
    
    [self showPickerView];
    [button setTitle:@"明星" forState:UIControlStateNormal];
}

// TODO: 弹出相册选择器
- (void)selectImageBtnClick:(UIButton *)button {
    
    NSLog(@"弹出相册选择器");
    self.changeWhichImageBtn = button;
    [self uploadImage];
}

// TODO: 下一步
- (void)nextStepBtnClick {
    
    NSLog(@"下一步");
    
    NSString *type = [self.mediaTypeCell.rightBtn.titleLabel.text isEqualToString:@"个人媒体"] ? @"1":@"2";
    self.uploadModel.type = type;
    self.uploadModel.pen_name = self.mediaNameCell.textField.text;
    self.uploadModel.instruction = self.mediaInstructionCell.textView.text;
    NSData *imageData = UIImageJPEGRepresentation(self.mediaHeadImgCell.selectImageBtn.imageView.image, 1.0f);
    self.uploadModel.head_img = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    if ([self.mediaTypeCell.rightBtn.titleLabel.text isEqualToString:@"媒体类型"]) {
        ZTShowAlertMessage(@"请选择媒体类型");
        return;
    }
    
    if (self.mediaNameCell.textField.text == nil || [self.mediaNameCell.textField.text isEqualToString:@""]) {
        ZTShowAlertMessage(@"请输入姓名");
        return;
    }
    
    if ([self.operatorFieldCell.rightBtn.titleLabel.text isEqualToString:@"分类"]) {
        ZTShowAlertMessage(@"请选择专注领域");
        return;
    }
    
    if (self.mediaInstructionCell.textView.text == nil || [self.mediaInstructionCell.textView.text isEqualToString:@""]) {
        ZTShowAlertMessage(@"请填写媒体简介");
        return;
    }
    
    NSData *imageData2 = UIImageJPEGRepresentation([UIImage imageNamed:@"照片占位"], 1.0f);
    if (imageData == nil || [imageData isEqualToData:imageData2]) {
        ZTShowAlertMessage(@"请选择媒体头像");
        return;
    }
    
    [self isManagerRepleatedNameWithString:self.mediaNameCell.textField.text];
}

- (void)isManagerRepleatedNameWithString:(NSString *)string
{
    NSDictionary *parameters = @{@"pen_name":string};
    [[JstyleNewsNetworkManager shareManager] GETURL:MANAGER_REPEATED_NAME parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"-1"]) {
            ZTShowAlertMessage(responseObject[@"data"]);
            return;
        }else{
            [self.operatorTableView reloadData];
            
            self.mediaInfoBtn.selected = NO;
            self.operatorInfoBtn.selected = YES;
            self.mobileAuthenticationBtn.selected = NO;
            
            self.mediaTableView.hidden = YES;
            self.operatorTableView.hidden = NO;
            self.mobileTableView.hidden = YES;
            
            self.nextStepBtn.hidden = YES;
            self.previousStepBtn.hidden = NO;
            self.operatorNextStepBtn.hidden = NO;
            
            self.mediaInfoBtn.userInteractionEnabled = YES;
            self.operatorInfoBtn.userInteractionEnabled = YES;
        }
    } failure:^(NSError *error) {
        ZTShowAlertMessage(@"提交失败，请稍后重试");
    }];
}

// TODO: 上传身份证照
- (void)uploadIDCardImageBtnClick:(UIButton *)button {
    
    NSLog(@"上传身份证照");
    self.changeWhichImageBtn = button;
    [self uploadImage];
}

// TODO: 选择运营所在地
- (void)selectOperatorLocationBtnClick:(UIButton *)button {
    
    NSLog(@"选择运营所在地");
    self.pickerViewType = JstyleAuthenticateAccountPickerViewTypeLocation;
    self.changeWhichTitleBtn = button;
    
    [self showPickerView];
    [button setTitle:@"北京" forState:UIControlStateNormal];
}

// TODO: 上传材料说明图片
- (void)uploadOperatorImageBtnClick:(UIButton *)button {
    
    NSLog(@"上传材料说明图片");
    self.changeWhichImageBtn = button;
    [self uploadImage];
}

// TODO: 同意协议
- (void)agreeBtnClick:(UIButton *)button {
    button.selected = !button.selected;
    NSLog(@"同意协议");
}

// TODO: 点击协议
- (void)protocolTapGesture:(UITapGestureRecognizer *)tap {
    
    NSLog(@"点击协议");
}

// TODO: 上一步
- (void)previousStepBtnClick:(UIButton *)button {
    
    NSLog(@"上一步");
    
    self.mediaInfoBtn.selected = YES;
    self.operatorInfoBtn.selected = NO;
    self.mobileAuthenticationBtn.selected = NO;
    
    self.mediaTableView.hidden = NO;
    self.operatorTableView.hidden = YES;
    self.mobileAuthenticationView.hidden = YES;
    
    self.nextStepBtn.hidden = NO;
    self.previousStepBtn.hidden = YES;
    self.operatorNextStepBtn.hidden = YES;
    self.confirmBtn.hidden = YES;
}

// TODO: 运营者下一步
- (void)operatorNextStepBtnClick:(UIButton *)button {
    
    NSLog(@"运营者下一步");
    
    self.uploadModel.operate_name = self.operatorNameCell.textField.text;
    self.uploadModel.IDcard = self.operatorIDCardCell.textField.text;
    NSData *idImageData = UIImageJPEGRepresentation(self.operatorIDphotoCell.imageBtn.imageView.image, 1.0f);
    self.uploadModel.IDphoto = [idImageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    self.uploadModel.organization_name = self.operatorOrganizationNameCell.textField.text;
    NSData *organizationImageData = UIImageJPEGRepresentation(self.operatorOrganizationImageCell.selectImageBtn.imageView.image, 1.0f);
    self.uploadModel.organization_img = [organizationImageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    self.uploadModel.operate_phone = self.operatorPhoneCell.textField.text;
    self.uploadModel.operate_mail = self.operatorMailcell.textField.text;
    for (JstyleManagementUserMediaForlModel *model in self.fieldNameArray) {
        if ([model.name isEqualToString:self.operatorFieldCell.rightBtn.titleLabel.text]) {
            self.uploadModel.field_id = model.id;
        }
    }
    
    for (JstyleManagementUserMediaForlModel *model in self.loacationNameArray) {
        if ([model.name isEqualToString:self.operatorLocationCell.rightBtn.titleLabel.text]) {
            self.uploadModel.location_id = model.id;
        }
    }
    
    NSData *intelligenceImageData = UIImageJPEGRepresentation(self.operatorIntelligenceCell.selectImageBtn.imageView.image, 1.0f);
    NSData *intelligenceImageData2 = UIImageJPEGRepresentation([UIImage imageNamed:@"照片占位"], 1.0f);
    if (![intelligenceImageData isEqualToData:intelligenceImageData2]) {
        self.uploadModel.intelligence_img = [intelligenceImageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    } else {
        self.uploadModel.intelligence_img = @"";
    }
    
    if ([self.uploadModel.type integerValue] == 2) {
        //企业媒体
        if (self.operatorNameCell.textField.text == nil || [self.operatorNameCell.textField.text isEqualToString:@""]) {
            ZTShowAlertMessage(@"请输入组织名称");
            return;
        }
        
        NSData *organizationImageData2 = UIImageJPEGRepresentation([UIImage imageNamed:@"照片占位"], 1.0f);
        if (organizationImageData == nil || [organizationImageData isEqualToData:organizationImageData2]) {
            ZTShowAlertMessage(@"请选择组织机构代码证");
            return;
        }
    }
    
    if (self.operatorNameCell.textField.text == nil || [self.operatorNameCell.textField.text isEqualToString:@""]) {
        ZTShowAlertMessage(@"请输入姓名");
        return;
    }
    
    if (self.operatorIDCardCell.textField.text == nil || [self.operatorIDCardCell.textField.text isEqualToString:@""]) {
        ZTShowAlertMessage(@"请输入证件号");
        return;
    } else if(![self isIdentityCard:self.operatorIDCardCell.textField.text]){
        ZTShowAlertMessage(@"证件号格式不正确");
        return;
    }
    
    NSData *idImageData2 = UIImageJPEGRepresentation([UIImage imageNamed:@"身份证示例图"], 1.0f);
    if (idImageData == nil || [idImageData isEqualToData:idImageData2]) {
        ZTShowAlertMessage(@"请选择证件照");
        return;
    }
    
    if (self.operatorPhoneCell.textField.text == nil || [self.operatorPhoneCell.textField.text isEqualToString:@""]) {
        ZTShowAlertMessage(@"请输入电话号码");
        return;
    } else if (![self isPhoneNumber:self.operatorPhoneCell.textField.text]) {
        ZTShowAlertMessage(@"电话号码格式不正确");
        return;
    }
    
    if (self.operatorMailcell.textField.text == nil || [self.operatorMailcell.textField.text isEqualToString:@""]) {
        ZTShowAlertMessage(@"请输入邮箱地址");
        return;
    } else if (![self isEmailAdress:self.operatorMailcell.textField.text]) {
        ZTShowAlertMessage(@"邮箱格式不正确");
        return;
    }
    
    if ([self.operatorLocationCell.rightBtn.titleLabel.text isEqualToString:@"地区"]) {
        ZTShowAlertMessage(@"请选择地区");
        return;
    }
    
    if (self.agreeBtn.isSelected == NO) {
        ZTShowAlertMessage(@"未同意并遵守协议");
        return;
    }
    
    self.mediaInfoBtn.selected = NO;
    self.operatorInfoBtn.selected = NO;
    self.mobileAuthenticationBtn.selected = YES;
    
    self.mediaTableView.hidden = YES;
    self.operatorTableView.hidden = YES;
    self.mobileAuthenticationView.hidden = NO;
    
    self.nextStepBtn.hidden = YES;
    self.previousStepBtn.hidden = YES;
    self.operatorNextStepBtn.hidden = YES;
    self.confirmBtn.hidden = NO;
    
    self.operatorInfoBtn.userInteractionEnabled = YES;
    self.mobileAuthenticationBtn.userInteractionEnabled = YES;
}

///判断身份证格式
- (BOOL)isIdentityCard:(NSString *)IDCardNumber
{
    if (IDCardNumber.length <= 0) {
        return NO;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:IDCardNumber];
}
///判断手机号格式
- (BOOL) isPhoneNumber:(NSString *)number
{
    NSString *phoneRegex1=@"1[34578]([0-9]){9}";
    NSPredicate *phoneTest1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex1];
    return  [phoneTest1 evaluateWithObject:number];
}
///判断邮箱格式
- (BOOL) isEmailAdress:(NSString *)Email
{
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:Email];
}

// TODO: 获取验证码
- (void)yanZhengMaBtnClick:(UIButton *)button {
    
    NSLog(@"获取验证码");
    if (self.mobileAuthenticationPhoneNumView.textField.text == nil || [self.mobileAuthenticationPhoneNumView.textField.text isEqualToString:@""]) {
        ZTShowAlertMessage(@"请填写手机号");
        return;
    } else if (![self isPhoneNumber:self.mobileAuthenticationPhoneNumView.textField.text]) {
        ZTShowAlertMessage(@"手机号格式不正确");
        return;
    }
    
    [self getCodeNumData];
}

// TODO: 确定
- (void)confirmBtnClick {
    
    NSLog(@"确定");
    self.uploadModel.validphone = self.mobileAuthenticationPhoneNumView.textField.text;
    self.uploadModel.validcode = self.mobileAuthenticationNumberView.textField.text;
    
    if (self.uploadModel.validphone == nil || [self.uploadModel.validphone isEqualToString:@""]) {
        ZTShowAlertMessage(@"请填写手机号");
        return;
    } else if (![self isPhoneNumber:self.uploadModel.validphone]) {
        ZTShowAlertMessage(@"手机号格式不正确");
        return;
    }
    
    if (self.uploadModel.validcode == nil || [self.uploadModel.validcode isEqualToString:@""]) {
        ZTShowAlertMessage(@"请输入验证码");
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在上传,请稍后"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    //上传信息
    [self uploadUserAuthenticateData];
}

- (void)showPickerView {
    
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
    [self.changeWhichTitleBtn setTitleColor:ISNightMode?kDarkNineColor:kDarkTwoColor forState:UIControlStateNormal];
    
    [self.mediaTableView endEditing:YES];
    [self.operatorTableView endEditing:YES];
    [self.mobileTableView endEditing:YES];
    
    [self.pickerView reloadAllComponents];
    
    self.pickerView.frame = CGRectMake(0, kScreenHeight - kToolBarHeight, kScreenWidth, kPickerViewHeight);
    [self.view addSubview:self.pickerView];
    [self.view bringSubviewToFront:self.pickerView];
    
    self.toolBar.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kToolBarHeight);
    [self.view addSubview:self.toolBar];
    [self.view bringSubviewToFront:self.toolBar];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.pickerView.frame = CGRectMake(0, kScreenHeight - kPickerViewHeight, kScreenWidth, kPickerViewHeight);
        self.toolBar.frame = CGRectMake(0, kScreenHeight - kPickerViewHeight - kToolBarHeight, kScreenWidth, kToolBarHeight);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissPickerView {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.pickerView.frame = CGRectMake(0, kScreenHeight + kToolBarHeight, kScreenWidth, kPickerViewHeight);
        self.toolBar.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kToolBarHeight);
    } completion:^(BOOL finished) {
        [self.pickerView removeFromSuperview];
        [self.toolBar removeFromSuperview];
    }];
}

- (void)doneBtnClick {
    [self dismissPickerView];
}

//弹出选择照片
- (void)uploadImage {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"获取图片"
                                                                             message:@"请选择方式"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       [self readImageFromCamera];
                                                   }];
    UIAlertAction *album = [UIAlertAction actionWithTitle:@"相册"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      [self readImageFromAlbum];
                                                  }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    
    [alertController addAction:camera];
    [alertController addAction:album];
    [alertController addAction:cancel];
    
    [self presentViewController: alertController animated:YES completion:nil];
}

// 从相册中读取照片
- (void)readImageFromAlbum {
    JstyleNewsImagePickerViewController *imagePicker = [[JstyleNewsImagePickerViewController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [NightModeManager defaultManager].nightView.userInteractionEnabled = NO;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

// 拍照
- (void)readImageFromCamera {
    
    if ([JstyleNewsImagePickerViewController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        JstyleNewsImagePickerViewController *imagePicker = [[JstyleNewsImagePickerViewController alloc] init];
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告"
                                                                       message:@"未检测到摄像头"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    [self.changeWhichImageBtn setImage:image forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.mediaTableView endEditing:YES];
    [self.operatorTableView endEditing:YES];
    [self dismissPickerView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.mediaTableView endEditing:YES];
    [self.operatorTableView endEditing:YES];
    [self.mobileTableView endEditing:YES];
    [self dismissPickerView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.mediaTableView) {
        //媒体信息
        return 6;
    } else if (tableView == self.operatorTableView) {
        //运营者信息
        if ([self.uploadModel.type integerValue] == 1) {//个人媒体
            return 8;
        } else {//企业媒体
            return 10;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.mediaTableView) {
        //媒体信息
        switch (indexPath.row) {
            case 0:
            {
                JstyleManagementVerificationTextView *cell = [tableView dequeueReusableCellWithIdentifier:JstyleManagementVerificationTextViewCellID forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
            case 1:
            {
                JstyleManagementVerificationSelectedView *cell = [tableView dequeueReusableCellWithIdentifier:JstyleManagementVerificationSelectedViewCellID forIndexPath:indexPath];
                self.mediaTypeCell = cell;
                cell.titleLabel.text = @"媒体类型";
                [cell.rightBtn setTitle:@"媒体类型" forState:UIControlStateNormal];
                [cell.rightBtn addTarget:self action:@selector(selectMediaTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
            case 2:
            {
                JstyleManagementVerificationWriteView *cell = [tableView dequeueReusableCellWithIdentifier:JstyleManagementVerificationWriteViewCellID forIndexPath:indexPath];
                self.mediaNameCell = cell;
                cell.isShortTextField = NO;
                cell.titleLabel.text = @"媒体名称";
                cell.textField.attributedPlaceholder = [@"请输入媒体名称" attributedColorStringWithTextColor:ISNightMode?kDarkNineColor:kPlaceholderColor font:JSFont(12)];
                cell.textField.keyboardType = UIKeyboardTypeDefault;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
            case 3:
            {
                JstyleManagementVerificationSelectedView *cell = [tableView dequeueReusableCellWithIdentifier:JstyleManagementVerificationSelectedViewCellID forIndexPath:indexPath];
                self.operatorFieldCell = cell;
                cell.titleLabel.text = @"专注领域";
                [cell.rightBtn setTitle:@"分类" forState:UIControlStateNormal];
                [cell.rightBtn addTarget:self action:@selector(selectMediaDomainBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
            case 4:
            {
                JstyleManagementVerificationWriteMoreView *cell = [tableView dequeueReusableCellWithIdentifier:JstyleManagementVerificationWriteMoreViewCellID forIndexPath:indexPath];
                self.mediaInstructionCell = cell;
                cell.titleLabel.text = @"媒体简介";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
            case 5:
            {
                JstyleManagementVerificationUploadImageView *cell = [tableView dequeueReusableCellWithIdentifier:JstyleManagementVerificationUploadImageViewCellID forIndexPath:indexPath];
                self.mediaHeadImgCell = cell;
                cell.titleLabel.text = @"媒体头像";
                cell.summaryLabel.text = @"要求清晰、健康，代表品牌形象要求清晰、健康，代表品牌形象要求清晰、健康，代表品牌形象要求清晰.";
                [cell.selectImageBtn addTarget:self action:@selector(selectImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
            default:
                break;
        }
        UITableViewCell *cell = [UITableViewCell new];
        cell.textLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row];
        return cell;
        
    } else if (tableView == self.operatorTableView) {
        //运营者信息
        if ([self.mediaTypeCell.rightBtn.titleLabel.text isEqualToString:@"个人媒体"] ||
            self.mediaTypeCell.rightBtn.titleLabel.text == nil) {//个人媒体
            
            switch (indexPath.row) {
                case 0:
                {
                    JstyleManagementVerificationWriteView *cell = [tableView dequeueReusableCellWithIdentifier:JstyleManagementVerificationWriteViewCellID forIndexPath:indexPath];
                    self.operatorNameCell = cell;
                    cell.isShortTextField = NO;
                    cell.titleLabel.text = @"姓名";
                    cell.textField.attributedPlaceholder = [@"请输入姓名" attributedColorStringWithTextColor:ISNightMode?kDarkNineColor:kPlaceholderColor font:JSFont(12)];
                    cell.textField.keyboardType = UIKeyboardTypeDefault;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                    break;
                case 1:
                {
                    JstyleManagementVerificationWriteView *cell = [tableView dequeueReusableCellWithIdentifier:JstyleManagementVerificationWriteViewCellID forIndexPath:indexPath];
                    self.operatorIDCardCell = cell;
                    cell.isShortTextField = NO;
                    cell.titleLabel.text = @"证件号";
                    cell.textField.attributedPlaceholder = [@"请输入证件号" attributedColorStringWithTextColor:ISNightMode?kDarkNineColor:kPlaceholderColor font:JSFont(12)];
                    cell.textField.keyboardType = UIKeyboardTypeDefault;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                    break;
                case 2:
                {
                    JstyleManagementVerificationUploadIDCardView *cell = [tableView dequeueReusableCellWithIdentifier:JstyleManagementVerificationUploadIDCardViewCellID forIndexPath:indexPath];
                    self.operatorIDphotoCell = cell;
                    [cell.imageBtn addTarget:self action:@selector(uploadIDCardImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                    break;
                case 3:
                {
                    JstyleManagementVerificationWriteView *cell = [tableView dequeueReusableCellWithIdentifier:JstyleManagementVerificationWriteViewCellID forIndexPath:indexPath];
                    self.operatorPhoneCell = cell;
                    cell.isShortTextField = NO;
                    cell.titleLabel.text = @"联系电话";
                    cell.textField.attributedPlaceholder = [@"请输入电话号码" attributedColorStringWithTextColor:ISNightMode?kDarkNineColor:kPlaceholderColor font:JSFont(12)];
                    cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                    break;
                case 4:
                {
                    JstyleManagementVerificationWriteView *cell = [tableView dequeueReusableCellWithIdentifier:JstyleManagementVerificationWriteViewCellID forIndexPath:indexPath];
                    self.operatorMailcell = cell;
                    cell.isShortTextField = NO;
                    cell.titleLabel.text = @"联系邮箱";
                    cell.textField.attributedPlaceholder = [@"请输入邮箱" attributedColorStringWithTextColor:ISNightMode?kDarkNineColor:kPlaceholderColor font:JSFont(12)];
                    cell.textField.keyboardType = UIKeyboardTypeDefault;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                    break;
                case 5:
                {
                    JstyleManagementVerificationSelectedView *cell = [tableView dequeueReusableCellWithIdentifier:JstyleManagementVerificationSelectedViewCellID forIndexPath:indexPath];
                    self.operatorLocationCell = cell;
                    cell.titleLabel.text = @"运营所在地";
                    [cell.rightBtn setTitle:@"地区" forState:UIControlStateNormal];
                    [cell.rightBtn setTitleColor:kDarkNineColor forState:UIControlStateNormal];
                    [cell.rightBtn addTarget:self action:@selector(selectOperatorLocationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                    break;
                case 6:
                {
                    JstyleManagementVerificationUploadImageView *cell = [tableView dequeueReusableCellWithIdentifier:JstyleManagementVerificationUploadImageViewCellID forIndexPath:indexPath];
                    self.operatorIntelligenceCell = cell;
                    cell.starIconLabel.alpha = 0;
                    cell.titleLabel.text = @"材料说明";
                    cell.summaryLabel.text = @"提供图片形式的证明，（专栏、微博、微信公众号等媒体平台的后台管理页面截图）如在微信号、头条号、微博已获得原创功能，可直接上传相关截图";
                    [cell.selectImageBtn addTarget:self action:@selector(uploadOperatorImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                    break;
                case 7:
                {
                    JstyleManagementVerificationAgreeProtocolView *cell = [tableView dequeueReusableCellWithIdentifier:JstyleManagementVerificationAgreeProtocolViewCellID forIndexPath:indexPath];
                    self.agreeBtn = cell.agreeBtn;
                    self.agreeCell = cell;
                    __weak typeof(self) weakSelf = self;
                    cell.agreeProtocolBlock = ^{
                        UIWindow *window = [UIApplication sharedApplication].keyWindow;
                        UIWebView *protocolWebView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                        weakSelf.protocolWebView = protocolWebView;
                        [window addSubview:protocolWebView];
                        
                        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:MANAGER_PROTOCOL_URL]];
                        [protocolWebView loadRequest:request];
                        UIButton *exitProtocolWebViewBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                        [exitProtocolWebViewBtn setTitle:@"关闭" forState:UIControlStateNormal];
                        exitProtocolWebViewBtn.frame = CGRectMake(kScreenWidth - 50, kScreenHeight - 50, 0, 0);
                        [exitProtocolWebViewBtn sizeToFit];
                        [protocolWebView addSubview:exitProtocolWebViewBtn];
                        [exitProtocolWebViewBtn addTarget:self action:@selector(exitProtocolWebViewBtnClick) forControlEvents:UIControlEventTouchUpInside];
                        
                    };
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                    break;
                default:
                    break;
            }
            
        } else { //企业媒体
            
            switch (indexPath.row) {
                case 0:
                {
                    JstyleManagementVerificationWriteView *cell = [tableView dequeueReusableCellWithIdentifier:JstyleManagementVerificationWriteViewCellID forIndexPath:indexPath];
                    self.operatorOrganizationNameCell = cell;
                    cell.isShortTextField = NO;
                    cell.titleLabel.text = @"组织名称";
                    cell.textField.attributedPlaceholder = [@"请输入组织名称" attributedColorStringWithTextColor:ISNightMode?kDarkNineColor:kPlaceholderColor font:JSFont(12)];
                    cell.textField.keyboardType = UIKeyboardTypeDefault;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                    break;
                case 1:
                {
                    JstyleManagementVerificationUploadImageView *cell = [tableView dequeueReusableCellWithIdentifier:JstyleManagementVerificationUploadImageViewCellID forIndexPath:indexPath];
                    self.operatorOrganizationImageCell = cell;
                    cell.starIconLabel.alpha = 1;
                    cell.titleLabel.text = @"组织机构代码证";
                    cell.summaryLabel.text = @"组织机构代码证信息清晰最大2M";
                    [cell.selectImageBtn setImage:[UIImage imageNamed:@"照片占位"] forState:UIControlStateNormal];
                    [cell.selectImageBtn addTarget:self action:@selector(uploadOperatorImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                    break;
                case 2:
                {
                    JstyleManagementVerificationWriteView *cell = [tableView dequeueReusableCellWithIdentifier:JstyleManagementVerificationWriteViewCellID forIndexPath:indexPath];
                    self.operatorNameCell = cell;
                    cell.isShortTextField = NO;
                    cell.titleLabel.text = @"姓名";
                    cell.textField.attributedPlaceholder = [@"请输入姓名" attributedColorStringWithTextColor:ISNightMode?kDarkNineColor:kPlaceholderColor font:JSFont(12)];
                    cell.textField.keyboardType = UIKeyboardTypeDefault;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                    break;
                case 3:
                {
                    JstyleManagementVerificationWriteView *cell = [tableView dequeueReusableCellWithIdentifier:JstyleManagementVerificationWriteViewCellID forIndexPath:indexPath];
                    self.operatorIDCardCell = cell;
                    cell.isShortTextField = NO;
                    cell.titleLabel.text = @"证件号";
                    cell.textField.attributedPlaceholder = [@"请输入证件号" attributedColorStringWithTextColor:ISNightMode?kDarkNineColor:kPlaceholderColor font:JSFont(12)];
                    cell.textField.keyboardType = UIKeyboardTypeDefault;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                    break;
                case 4:
                {
                    JstyleManagementVerificationUploadIDCardView *cell = [tableView dequeueReusableCellWithIdentifier:JstyleManagementVerificationUploadIDCardViewCellID forIndexPath:indexPath];
                    self.operatorIDphotoCell = cell;
                    [cell.imageBtn addTarget:self action:@selector(uploadIDCardImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                    break;
                case 5:
                {
                    JstyleManagementVerificationWriteView *cell = [tableView dequeueReusableCellWithIdentifier:JstyleManagementVerificationWriteViewCellID forIndexPath:indexPath];
                    self.operatorPhoneCell = cell;
                    cell.isShortTextField = NO;
                    cell.titleLabel.text = @"联系电话";
                    cell.textField.attributedPlaceholder = [@"请输入手机号码" attributedColorStringWithTextColor:ISNightMode?kDarkNineColor:kPlaceholderColor font:JSFont(12)];
                    cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                    break;
                case 6:
                {
                    JstyleManagementVerificationWriteView *cell = [tableView dequeueReusableCellWithIdentifier:JstyleManagementVerificationWriteViewCellID forIndexPath:indexPath];
                    self.operatorMailcell = cell;
                    cell.isShortTextField = NO;
                    cell.titleLabel.text = @"联系邮箱";
                    cell.textField.attributedPlaceholder = [@"请输入邮箱" attributedColorStringWithTextColor:ISNightMode?kDarkNineColor:kPlaceholderColor font:JSFont(12)];
                    cell.textField.keyboardType = UIKeyboardTypeDefault;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                    break;
                case 7:
                {
                    JstyleManagementVerificationSelectedView *cell = [tableView dequeueReusableCellWithIdentifier:JstyleManagementVerificationSelectedViewCellID forIndexPath:indexPath];
                    self.operatorLocationCell = cell;
                    cell.titleLabel.text = @"运营所在地";
                    [cell.rightBtn setTitle:@"地区" forState:UIControlStateNormal];
                    [cell.rightBtn setTitleColor:kDarkNineColor forState:UIControlStateNormal];
                    [cell.rightBtn addTarget:self action:@selector(selectOperatorLocationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                    break;
                case 8:
                {
                    JstyleManagementVerificationUploadImageView *cell = [tableView dequeueReusableCellWithIdentifier:JstyleManagementVerificationUploadImageViewCellID forIndexPath:indexPath];
                    self.operatorIntelligenceCell = cell;
                    cell.starIconLabel.alpha = 0;
                    cell.titleLabel.text = @"材料说明";
                    cell.summaryLabel.text = @"提供图片形式的证明，（专栏、微博、微信公众号等媒体平台的后台管理页面截图）如在微信号、头条号、微博已获得原创功能，可直接上传相关截图";
                    [cell.selectImageBtn addTarget:self action:@selector(uploadOperatorImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                    break;
                case 9:
                {
                    JstyleManagementVerificationAgreeProtocolView *cell = [tableView dequeueReusableCellWithIdentifier:JstyleManagementVerificationAgreeProtocolViewCellID forIndexPath:indexPath];
                    self.agreeBtn = cell.agreeBtn;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                    break;
                default:
                    break;
            }
            
            
        }
        
        
        UITableViewCell *cell = [UITableViewCell new];
        cell.textLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        //手机验证
        UITableViewCell *cell = [UITableViewCell new];
        cell.textLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)exitProtocolWebViewBtnClick {
    [self.protocolWebView removeFromSuperview];
}

#pragma mark - 上传用户注册数据
- (void)uploadUserAuthenticateData {
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    NSDictionary *paramaters = @{
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"validphone":_uploadModel.validphone,
                                 @"validcode":_uploadModel.validcode,
                                 @"type":_uploadModel.type,
                                 @"pen_name":_uploadModel.pen_name,
                                 @"instruction":_uploadModel.instruction,
                                 @"head_img":_uploadModel.head_img,
                                 @"operate_name":_uploadModel.operate_name,
                                 @"IDcard":_uploadModel.IDcard,
                                 @"IDphoto":_uploadModel.IDphoto,
                                 @"field_id":_uploadModel.field_id,
                                 @"location_id":_uploadModel.location_id,
                                 @"intelligence_img":_uploadModel.intelligence_img,
                                 @"operate_email":_uploadModel.operate_mail,
                                 @"operate_phone":_uploadModel.operate_phone
                                 };
    
    NSMutableDictionary *organizationParamaters = [NSMutableDictionary dictionaryWithDictionary:paramaters];
    [organizationParamaters setValue:_uploadModel.organization_name forKey:@"organization_name"];
    [organizationParamaters setValue:_uploadModel.organization_img forKey:@"organization_img"];
    
    NSDictionary *p = [self.uploadModel.type isEqualToString:@"1"] ? paramaters : organizationParamaters;
    [manager POST:MANAGER_ADDUSERMEDIA_URL parameters:p progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSDictionary *responseData = responseObject;
        NSInteger stateNum = [responseData[@"code"] integerValue];
        NSString *errorString = responseData[@"error"];
        switch (stateNum) {
            case 1://iCity号注册成功，请耐心等待审核 ~
            {
                if (responseData[@"data"][@"uniqueid"]) {
                    self.uniqueid = responseData[@"data"][@"uniqueid"];
                    [[NSUserDefaults standardUserDefaults] setObject:responseData[@"data"][@"uniqueid"] forKey:@"uniqueid"];
                }
                NSLog(@"%@",responseData[@"data"][@"info"]);
                JstyleManagementAccoutStatusDaiShenHeViewController *accoutStatusVC = [JstyleManagementAccoutStatusDaiShenHeViewController new];
                accoutStatusVC.statusString = responseData[@"data"][@"info"];
                
                [self.navigationController pushViewController:accoutStatusVC animated:YES];
            }
                break;
            case -1:
            {
                ZTShowAlertMessage(errorString);
                NSLog(@"%@",errorString);
            }
                break;
            case 3:
            {
                ZTShowAlertMessage(errorString);
                NSLog(@"%@",errorString);
            }
                break;
            default:
                break;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
    }];
    
    
}

#pragma mark - 加载领域和所在地信息
- (void)loadUserMediaForlData {
    
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    //领域
    [manager GET:MANAGER_USERMEDIAFORL_URL parameters:@{@"type":@"1"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseData = responseObject;
        if ([responseData[@"code"] integerValue] == 1) {
            
            self.fieldNameArray = [NSArray modelArrayWithClass:[JstyleManagementUserMediaForlModel class] json:responseData[@"data"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    //所在地
    [manager GET:MANAGER_USERMEDIAFORL_URL parameters:@{@"type":@"2"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseData = responseObject;
        if ([responseData[@"code"] integerValue] == 1) {
            
            self.loacationNameArray = [NSArray modelArrayWithClass:[JstyleManagementUserMediaForlModel class] json:responseData[@"data"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [SVProgressHUD dismiss];
    }];
    
}

#pragma mark - 请求用户信息
- (void)requestUserInformation {
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
//    self.uniqueid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uniqueid"];
    NSDictionary *parameters = @{
                                 @"uniqueid":[[JstyleToolManager sharedManager] getUniqueId]
                                 };
    [manager GET:MANAGER_USERMEDIAINFORMATION_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseData = responseObject;
        if ([responseData[@"code"] integerValue] == 1) {
            
            JstyleManagementUserInformationModel *model = [JstyleManagementUserInformationModel modelWithJSON:responseData[@"data"]];
            
            self.userInformationModel = model;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [SVProgressHUD dismiss];
    }];
}

/**获取验证码*/
- (void)getCodeNumData
{
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:self.mobileAuthenticationPhoneNumView.textField.text,@"mobile",@"7",@"type", nil];
    [manager POST:GET_CODE_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictionary = responseObject;
        
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
                [self.yanZhengMaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self.yanZhengMaBtn setTitleColor:kManagementRedColor forState:UIControlStateNormal];
                self.yanZhengMaBtn.userInteractionEnabled = YES;
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"倒计时(%.2d)", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.yanZhengMaBtn.titleLabel.text = strTime;
                [self.yanZhengMaBtn setTitle:strTime forState:UIControlStateNormal];
                [self.yanZhengMaBtn setTitleColor:kDarkNineColor forState:(UIControlStateNormal)];
                self.yanZhengMaBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - 监听修改用户信息模型
- (void)setUserInformationModel:(JstyleManagementUserInformationModel *)userInformationModel {
    _userInformationModel = userInformationModel;
    
    if ([userInformationModel.type isEqualToString:@"个人"]) {
        [self.mediaTypeCell.rightBtn setTitle:@"个人媒体" forState:UIControlStateNormal];
    } else if ([userInformationModel.type isEqualToString:@"企业"]) {
        [self.mediaTypeCell.rightBtn setTitle:@"企业媒体" forState:UIControlStateNormal];
    }
    self.operatorOrganizationNameCell.textField.text = userInformationModel.organization_name;
    
    [self.operatorOrganizationImageCell.selectImageBtn sd_setImageWithURL:[NSURL URLWithString:userInformationModel.organization_img] forState:UIControlStateNormal];
    
    [self.mediaTypeCell.rightBtn setTitleColor:ISNightMode?kDarkNineColor:kDarkTwoColor forState:UIControlStateNormal];
    
    self.operatorNameCell.textField.text = userInformationModel.operate_name;
    self.operatorOrganizationNameCell.textField.text = userInformationModel.operate_name;
    
    self.mediaNameCell.textField.text = userInformationModel.pen_name;
    
    [self.operatorFieldCell.rightBtn setTitle:userInformationModel.field_name forState:UIControlStateNormal];
    [self.operatorFieldCell.rightBtn setTitleColor:ISNightMode?kDarkNineColor:kDarkTwoColor forState:UIControlStateNormal];
    [self.operatorOrganizationFieldCell.rightBtn setTitle:userInformationModel.field_name forState:UIControlStateNormal];
    [self.operatorOrganizationFieldCell.rightBtn setTitleColor:ISNightMode?kDarkNineColor:kDarkTwoColor forState:UIControlStateNormal];
    
    
    self.mediaInstructionCell.textView.text = userInformationModel.instruction;
    [self.mediaInstructionCell.placeholderLabel removeFromSuperview];
    
    [self.mediaHeadImgCell.selectImageBtn sd_setImageWithURL:[NSURL URLWithString:userInformationModel.head_img] forState:UIControlStateNormal];
    
    self.operatorIDCardCell.textField.text = userInformationModel.idcard;
    self.operatorOrganizationIDCardCell.textField.text = userInformationModel.idcard;
    
    [self.operatorIDphotoCell.imageBtn sd_setImageWithURL:[NSURL URLWithString:userInformationModel.idphoto] forState:UIControlStateNormal];
    [self.operatorOrganizationIDphotoCell.imageBtn sd_setImageWithURL:[NSURL URLWithString:userInformationModel.idphoto] forState:UIControlStateNormal];
    
    self.operatorPhoneCell.textField.text = userInformationModel.operate_phone;
    self.operatorOrganizationPhoneCell.textField.text = userInformationModel.operate_phone;
    
    self.operatorMailcell.textField.text = userInformationModel.operate_email;
    self.operatorOrganizationMailcell.textField.text = userInformationModel.operate_email;
    
    [self.operatorLocationCell.rightBtn setTitle:userInformationModel.fullName forState:UIControlStateNormal];
    [self.operatorLocationCell.rightBtn setTitleColor:ISNightMode?kDarkNineColor:kDarkTwoColor forState:UIControlStateNormal];
    [self.operatorOrganizationLocationCell.rightBtn setTitle:userInformationModel.fullName forState:UIControlStateNormal];
    [self.operatorOrganizationLocationCell.rightBtn setTitleColor:ISNightMode?kDarkNineColor:kDarkTwoColor forState:UIControlStateNormal];
    
    if ([userInformationModel.intelligence_img isEqualToString:@""]) {
        [self.operatorIntelligenceCell.selectImageBtn setImage:[UIImage imageNamed:@"照片占位"] forState:UIControlStateNormal];
        [self.operatorOrganizationIntelligenceCell.selectImageBtn setImage:[UIImage imageNamed:@"照片占位"] forState:UIControlStateNormal];
    } else {
        [self.operatorIntelligenceCell.selectImageBtn sd_setImageWithURL:[NSURL URLWithString:userInformationModel.intelligence_img] forState:UIControlStateNormal];
        [self.operatorOrganizationIntelligenceCell.selectImageBtn sd_setImageWithURL:[NSURL URLWithString:userInformationModel.intelligence_img] forState:UIControlStateNormal];
    }
}

- (void)setIsChangeUserInformation:(BOOL)isChangeUserInformation {
    _isChangeUserInformation = isChangeUserInformation;
    if (isChangeUserInformation == YES) {
        //请求用户信息
        [self requestUserInformation];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
}

@end
