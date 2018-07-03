//
//  JstyleNewFeatureSelectedTagViewController.m
//  Exquisite
//
//  Created by 数字跃动 on 2017/8/24.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleNewFeatureSelectedTagViewController.h"
#import "JstyleNewFeaturePickTagCollectionViewCell.h"
#import "JstyleNewsTabBarController.h"
#import "JstyleNewsHomeBaseViewController.h"
#import "JstyleNewsVideoBaseViewController.h"
#import "JstyleNewsNavigationController.h"

#define TAGLIST_URL @"http://app.jstyle.cn:13000/app_interface/home/homepage/taglist.htm"
#define KScale kScreenWidth / 375.0

@interface JstyleNewFeatureSelectedTagViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *menBtn;
@property (nonatomic, strong) UIButton *womenBtn;
@property (nonatomic, assign) NSUInteger selectCount;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) NSString *tagNameStingM;
@property (nonatomic, strong) NSMutableArray *tagNamesArrM;
@property (nonatomic, strong) NSArray *iconNamesArray;

@end

static NSString *pickTagCollectionViewCellID = @"pickTagCollectionViewCellID";
@implementation JstyleNewFeatureSelectedTagViewController

- (NSArray *)iconNamesArray {
    if (_iconNamesArray == nil) {
        _iconNamesArray = @[@"娱乐",@"影音",@"时尚",@"穿搭",@"美容",@"艺术",@"生活",@"家居",@"旅行",@"美食",@"运动",@"健康",@"情感",@"街拍",@"科技",@"搞笑",@"宠物",@"心理"];
    }
    return _iconNamesArray;
}

- (NSMutableArray *)tagNamesArrM {
    if (_tagNamesArrM == nil) {
        _tagNamesArrM = [NSMutableArray array];
    }
    return _tagNamesArrM;
}

- (NSString *)tagNameStingM {
    if (_tagNameStingM == nil) {
        _tagNameStingM = [NSString string];
        _tagNameStingM = @"";
    }
    return _tagNameStingM;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumInteritemSpacing = 42 * KScale - 1;
        flowLayout.minimumLineSpacing = 45 * KScale - 1;
        flowLayout.itemSize = CGSizeMake(74 * KScale, (74 + 6 + 13) * KScale);
        flowLayout.sectionInset = UIEdgeInsetsMake(52 * KScale, 30 * KScale, 0, 30 * KScale);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (437 + 64) * KScale) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
        [_collectionView registerClass:[JstyleNewFeaturePickTagCollectionViewCell class] forCellWithReuseIdentifier:pickTagCollectionViewCellID];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.title = @"选择你喜欢的内容";
    
//    UILabel *skipLabel = [UILabel labelWithColor:kDarkTwoColor fontSize:13 text:@"跳过   "];
//    skipLabel.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeToMainWindow)];
//    [skipLabel addGestureRecognizer:tap];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:skipLabel];
    
    self.collectionView.backgroundColor = kWhiteColor;
    [self.view addSubview:self.collectionView];
    
    UIView *footView = [UIView new];
    footView.backgroundColor = kWhiteColor;
    [self.view addSubview:footView];
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(171 * KScale);
    }];
    
    UIImageView *maskView = [[UIImageView alloc] init];
    maskView.image = [UIImage imageNamed:@"1"];
    maskView.contentMode = UIViewContentModeScaleToFill;
    [footView addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.equalTo(footView.mas_top).offset(12);
        make.height.offset(64 * KScale);
        make.width.offset(kScreenWidth);
    }];
    
    UILabel *normalLabel = [[UILabel alloc] init];
    normalLabel.text = @"选择你感兴趣的标签";
    [normalLabel sizeToFit];
    normalLabel.textColor = kDarkFiveColor;
    normalLabel.font = [UIFont systemFontOfSize:13];
    [footView addSubview:normalLabel];
    [normalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-25 * KScale);
        make.centerX.offset(-16 * KScale);
    }];
    
    UILabel *countLabel = [[UILabel alloc] init];
    self.countLabel = countLabel;
    countLabel.text = @"0 ∕ 5";
    countLabel.textColor = kDarkNineColor;
    countLabel.font = [UIFont systemFontOfSize:11];
    [countLabel sizeToFit];
    [footView addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(normalLabel.mas_right).offset(10 * KScale);
        make.centerY.equalTo(normalLabel);
    }];

    UIButton *attentionBtn = [[UIButton alloc] init];
    attentionBtn.layer.cornerRadius = 38 * KScale / 2.0;
    attentionBtn.layer.masksToBounds = YES;
    attentionBtn.backgroundColor = JSColor(@"#EB6A64");
    [attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
    attentionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [footView addSubview:attentionBtn];
    [attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(normalLabel.mas_top).offset(-10 * KScale);
        make.left.offset(27 * KScale);
        make.right.offset(-27 * KScale);
        make.height.offset(38 * KScale);
    }];
    [attentionBtn addTarget:self action:@selector(attentionBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *menBtn = [[UIButton alloc] init];
    self.menBtn = menBtn;
    menBtn.tag = JstyleNewFeatureSelectedTagGenderButtonMen;
    menBtn.layer.cornerRadius = 37 * KScale / 2;
    menBtn.layer.masksToBounds = YES;
    menBtn.layer.borderWidth = 0.8;
    menBtn.layer.borderColor = kSearchBackColor.CGColor;
    [menBtn setTitle:@"男士MEN" forState:UIControlStateNormal];
    menBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [menBtn setTitleColor:kDarkFiveColor forState:UIControlStateNormal];
    [menBtn setTitleColor:JSColor(@"#EB6A64") forState:UIControlStateSelected];
    [menBtn setBackgroundColor:kSearchBackColor];
    [footView addSubview:menBtn];
    [menBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(160 * KScale);
        make.height.offset(37 * KScale);
        make.left.offset(18 * KScale);
        make.bottom.equalTo(attentionBtn.mas_top).offset(-20 * KScale);
    }];
    [menBtn addTarget:self action:@selector(genderButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *womenBtn = [[UIButton alloc] init];
    self.womenBtn = womenBtn;
    womenBtn.tag = JstyleNewFeatureSelectedTagGenderButtonWomen;
    womenBtn.layer.cornerRadius = 37 * KScale / 2;
    womenBtn.layer.masksToBounds = YES;
    womenBtn.layer.borderWidth = 0.8;
    womenBtn.layer.borderColor = kSearchBackColor.CGColor;
    [womenBtn setTitle:@"女士WOMEN" forState:UIControlStateNormal];
    womenBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [womenBtn setTitleColor:kDarkFiveColor forState:UIControlStateNormal];
    [womenBtn setTitleColor:JSColor(@"#EB6A64") forState:UIControlStateSelected];
    [womenBtn setBackgroundColor:kSearchBackColor];
    [footView addSubview:womenBtn];
    [womenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(160 * KScale);
        make.height.offset(37 * KScale);
        make.right.offset(-18 * KScale);
        make.centerY.equalTo(menBtn);
    }];
    [womenBtn addTarget:self action:@selector(genderButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.bottom.equalTo(footView.mas_top).offset(0);
    }];
    
}

- (void)attentionBtnOnClick {
    
    if (self.tagNamesArrM.count < 5) {
        ZTShowAlertMessage(@"请至少选择5个标签");
        return;
    }
    
    if (self.womenBtn.isSelected == NO && self.menBtn.isSelected == NO) {
        ZTShowAlertMessage(@"请选择性别");
        return;
    }
    
    if (self.tagNamesArrM.count < 5 || (self.womenBtn.isSelected == NO && self.menBtn.isSelected == NO)) {
        return;
    }
    
    //记录程序已经启动
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"ApplicationFirstLuanchTag"];
    
    //发请求
    NSString *uuid = [[JstyleToolManager sharedManager] getUDID];
    [self appendTag];
    NSString *sex = self.menBtn.isSelected ? @"1" : @"2";
    
    NSMutableDictionary *paramaters = [NSMutableDictionary dictionary];
    
    [paramaters setObject:uuid forKey:@"uuid"];
    [paramaters setObject:self.tagNameStingM forKey:@"tag"];
    [paramaters setObject:sex forKey:@"sex"];
    [paramaters setObject:@"1" forKey:@"phone_type"];
    [paramaters setObject:@"2" forKey:@"platform_type"];
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];

    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [manager POSTURL:ICity_LABEL_ADD parameters:paramaters success:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            [SVProgressHUD dismiss];
            [self changeToMainWindow];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD dismiss];
        [self changeToMainWindow];
    }];
}

///切换主窗口
- (void)changeToMainWindow {
    JstyleNewsTabBarController *tabbarC = [[JstyleNewsTabBarController alloc] initWithViewControllers:nil tabBarItemsAttributes:nil imageInsets:UIEdgeInsetsZero titlePositionAdjustment:UIOffsetZero];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = tabbarC;
}

- (void)appendTag {
    for (NSInteger i = 0; i < self.tagNamesArrM.count; i++) {
        if (i != self.tagNamesArrM.count-1) {
            self.tagNameStingM = [self.tagNameStingM stringByAppendingString:self.tagNamesArrM[i]];
            self.tagNameStingM = [self.tagNameStingM stringByAppendingString:@","];
        } else {
            self.tagNameStingM = [self.tagNameStingM stringByAppendingString:self.tagNamesArrM[i]];
        }
    }
    NSLog(@"tag: %@",self.tagNameStingM);
}


- (void)genderButtonOnClick:(UIButton *)genderButton {
    
    if (genderButton.tag == JstyleNewFeatureSelectedTagGenderButtonMen) {
        
        self.menBtn.selected = !self.menBtn.selected;
        if (self.menBtn.isSelected) {
            self.menBtn.layer.borderColor = kLightRedColor.CGColor;
            self.menBtn.backgroundColor = kWhiteColor;
        } else {
            self.menBtn.layer.borderColor = kSearchBackColor.CGColor;
            self.menBtn.backgroundColor = kSearchBackColor;
            
        }
        self.womenBtn.selected = NO;
        
        self.womenBtn.layer.borderColor = kSearchBackColor.CGColor;
        self.womenBtn.backgroundColor = kSearchBackColor;
        
    } else {
        
        self.womenBtn.selected = !self.womenBtn.selected;
        if (self.womenBtn.isSelected) {
            self.womenBtn.layer.borderColor = kLightRedColor.CGColor;
            self.womenBtn.backgroundColor = kWhiteColor;
        } else {
            self.womenBtn.layer.borderColor = kSearchBackColor.CGColor;
            self.womenBtn.backgroundColor = kSearchBackColor;
        }
        self.menBtn.selected = NO;
        
        self.menBtn.layer.borderColor = kSearchBackColor.CGColor;
        self.menBtn.backgroundColor = kSearchBackColor;
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.iconNamesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JstyleNewFeaturePickTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:pickTagCollectionViewCellID forIndexPath:indexPath];
    
    cell.indexPath = indexPath;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.iconNamesArray.count) {
        [self.tagNamesArrM addObject:self.iconNamesArray[indexPath.item]];
    }
    self.countLabel.text = [NSString stringWithFormat:@"%zd ∕ 5",self.tagNamesArrM.count];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.iconNamesArray.count) {
        [self.tagNamesArrM removeObject:self.iconNamesArray[indexPath.item]];
    }
    self.countLabel.text = [NSString stringWithFormat:@"%zd ∕ 5",self.tagNamesArrM.count];
}

@end
