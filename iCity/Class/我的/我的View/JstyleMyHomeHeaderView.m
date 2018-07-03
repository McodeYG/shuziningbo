//
//  JstyleMyHomeHeaderView.m
//  Exquisite
//
//  Created by 王磊 on 2018/3/6.
//  Copyright © 2018年 JstyleStar. All rights reserved.
//

#import "JstyleMyHomeHeaderView.h"

@interface JstyleMyHomeHeaderView ()

@property (strong, nonatomic) IBOutlet UIView *personalInfoHoldView;

@property (strong, nonatomic) IBOutlet UIView *myOrderHoldView;
@property (strong, nonatomic) IBOutlet UILabel *myOrderLabel;
@property (strong, nonatomic) IBOutlet UILabel *checkVIPRightLabel;

@property (strong, nonatomic) IBOutlet UIImageView *avatorImageView;//头像
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *vipSymbolBtn;

@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;

@property (strong, nonatomic) IBOutlet UILabel *collectionNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *subscibeNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *recentNumLabel;

@property (strong, nonatomic) IBOutlet UILabel *collectionLabel;
@property (strong, nonatomic) IBOutlet UILabel *subscibeLabel;
@property (strong, nonatomic) IBOutlet UILabel *recentLabel;

@property (strong, nonatomic) IBOutlet UIView *holdView;
@property (strong, nonatomic) IBOutlet UIButton *checkAllOrderBtn;
@property (strong, nonatomic) IBOutlet UIButton *checkAllOrderImageBtn;

@end

@implementation JstyleMyHomeHeaderView

-(void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.backgroundColor = [UIColor clearColor];
    
    self.personalInfoHoldView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    if (userName != nil || ![userName isEqualToString:@""]) {
        self.nameLabel.text = userName;
    }
    
    self.nameLabel.text = [[JstyleToolManager sharedManager] isTourist] ? @"点击登录" : userName;
    
    self.holdView.layer.masksToBounds = YES;
    
    self.myOrderHoldView.layer.cornerRadius = self.myOrderHoldView.height / 2.0;
    
    //myOrderHoldView下半部分白色遮挡
    UIView *whiteOrderMaskView = [[UIView alloc] init];
    whiteOrderMaskView.backgroundColor = kWhiteColor;
    [self.myOrderHoldView insertSubview:whiteOrderMaskView belowSubview:self.myOrderLabel];
    [whiteOrderMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(38.0 / 2.0);
    }];
    [self.myOrderHoldView bringSubviewToFront:self.myOrderLabel];
    [self.myOrderHoldView bringSubviewToFront:self.checkAllOrderBtn];
    [self.myOrderHoldView bringSubviewToFront:self.checkAllOrderImageBtn];
    
    
    self.vipSymbolBtn.hidden = [[JstyleToolManager sharedManager] isTourist];
    
    self.avatorImageView.layer.cornerRadius = 65.0 / 2.0;
    self.avatorImageView.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatorClick)];
    [self.avatorImageView addGestureRecognizer:tap];
    
    UIView *maskView = [UIView new];
    maskView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.15];
    [self.avatorImageView addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
//    self.backgroundImageView.clipsToBounds = YES;
    self.backgroundImageView.backgroundColor = [UIColor yellowColor];
    
    NSString *imageUrl = [[NSUserDefaults standardUserDefaults]objectForKey:@"headimgurl"];
    if (imageUrl == nil || [imageUrl isEqualToString:@""]) {
        [self.avatorImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:JSImage(@"touxiang")];
        [self.backgroundImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:JSImage(@"touxiang")];
    } else {
        [self.avatorImageView setImageWithURL:[NSURL URLWithString:imageUrl] options:YYWebImageOptionProgressiveBlur];
        [self.backgroundImageView setImageWithURL:[NSURL URLWithString:imageUrl] options:YYWebImageOptionProgressiveBlur];
    }
    
    
    if ([[JstyleToolManager sharedManager] getUniqueId]) {
        self.checkVIPRightLabel.text = @"iCity号";
    } else {
        self.checkVIPRightLabel.text = @"开通iCity号";
    }
    UITapGestureRecognizer *tapCheckVIPRightLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkOutVIPRightsBtnClick:)];
    [self.checkVIPRightLabel addGestureRecognizer:tapCheckVIPRightLabel];
    
    UITapGestureRecognizer *tapNameLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameLabelClick)];
    [self.nameLabel addGestureRecognizer:tapNameLabel];

    UITapGestureRecognizer *tapMoneyLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myMoneyBtnClick:)];
    [self.moneyLabel addGestureRecognizer:tapMoneyLabel];
    
    UITapGestureRecognizer *tapCollection = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myCollectionClick)];
    [self.collectionLabel addGestureRecognizer:tapCollection];
    UITapGestureRecognizer *tapCollectionNum = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myCollectionClick)];
    [self.collectionNumLabel addGestureRecognizer:tapCollectionNum];
    
    UITapGestureRecognizer *tapSubcibe = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mySubcibeClick)];
    [self.subscibeLabel addGestureRecognizer:tapSubcibe];
    UITapGestureRecognizer *tapSubcibeNum = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mySubcibeClick)];
    [self.subscibeNumLabel addGestureRecognizer:tapSubcibeNum];
    
    UITapGestureRecognizer *tapRecent = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myRecentClick)];
    [self.recentLabel addGestureRecognizer:tapRecent];
    UITapGestureRecognizer *tapRecentNum = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myRecentClick)];
    [self.recentNumLabel addGestureRecognizer:tapRecentNum];
}

- (void)setUserInfoModel:(JstyleNewsMineLoginUserInfoModel *)userInfoModel {
    _userInfoModel = userInfoModel;
    
    if ([[JstyleToolManager sharedManager] isTourist]) {
        self.vipSymbolBtn.hidden = YES;
        [self.avatorImageView setImage:JSImage(@"touxiang")];
        [self.backgroundImageView setImage:JSImage(@"touxiang")];
    } else {
        self.vipSymbolBtn.hidden = NO;
        [self.avatorImageView setImageWithURL:[NSURL URLWithString:userInfoModel.poster] placeholder:SZ_Place_Header];
        [self.backgroundImageView setImageWithURL:[NSURL URLWithString:userInfoModel.poster] placeholder:SZ_Place_S_N];
    }
    
//    self.moneyLabel.text = [NSString stringWithFormat:@"%@",userInfoModel.now_price];
//    self.collectionNumLabel.text = [NSString stringWithFormat:@"%@",userInfoModel.follownum];
//    self.subscibeNumLabel.text = [NSString stringWithFormat:@"%@",userInfoModel.medianum];
//    self.recentNumLabel.text = [NSString stringWithFormat:@"%@",userInfoModel.browsenum];
    self.nameLabel.text = [[JstyleToolManager sharedManager] isTourist] ? @"点击登录" : [NSString stringWithFormat:@"%@",userInfoModel.nick_name];
    
    switch (userInfoModel.isbetauser.integerValue) {
        case 1://内测
        {
            [self.vipSymbolBtn setImage:JSImage(@"内测会员") forState:UIControlStateNormal];
            [self.vipSymbolBtn setTitleColor:JSColor(@"#ECB351") forState:UIControlStateNormal];
            [self.vipSymbolBtn setTitle:@"  荣耀会员" forState:UIControlStateNormal];
        }
            break;
        case 2://普通用户
        {
            [self.vipSymbolBtn setImage:JSImage(@"VIP普通会员") forState:UIControlStateNormal];
            [self.vipSymbolBtn setTitleColor:JSColor(@"#A6A6A6") forState:UIControlStateNormal];
            [self.vipSymbolBtn setTitle:@"  普通用户" forState:UIControlStateNormal];
        }
            break;
        case 3://活动
        case 4://付费
        {
            [self.vipSymbolBtn setImage:JSImage(@"VIP会员") forState:UIControlStateNormal];
            [self.vipSymbolBtn setTitleColor:JSColor(@"#BB996C") forState:UIControlStateNormal];
            [self.vipSymbolBtn setTitle:@"  VIP会员" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    
    if ([[JstyleToolManager sharedManager] getUniqueId]) {
        self.checkVIPRightLabel.text = @"iCity号";
    } else {
        self.checkVIPRightLabel.text = @"开通iCity号";
    }
    
}

- (IBAction)checkMyOrderBtnClick:(UIButton *)sender {
    if (self.checkMyOrderBlock) {
        self.checkMyOrderBlock();
    }
}

- (IBAction)myMoneyBtnClick:(UIButton *)sender {
    if (self.myMoneyBlock) {
        self.myMoneyBlock(self.moneyLabel);
    }
}

- (IBAction)checkOutVIPRightsBtnClick:(id)sender {
    if (self.checkOutVIPRightsBlock) {
        self.checkOutVIPRightsBlock();
    }
}

- (void)nameLabelClick {
    if ([self.nameLabel.text isEqualToString:@"点击登录"] && [[JstyleToolManager sharedManager] isTourist]) {
        [[JstyleToolManager sharedManager] loginInViewController];
    }
}

- (void)myCollectionClick {
    if (self.myCollectionBlock) {
        self.myCollectionBlock();
    }
}

- (void)mySubcibeClick {
    if (self.mySubcibeBlock) {
        self.mySubcibeBlock();
    }
}

- (void)myRecentClick {
    if (self.myRecentBlock) {
        self.myRecentBlock();
    }
}

- (void)avatorClick {
    if (self.avatorClickBlock) {
        self.avatorClickBlock();
    }
}

@end
