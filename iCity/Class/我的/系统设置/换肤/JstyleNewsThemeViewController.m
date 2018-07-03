//
//  JstyleNewsThemeViewController.m
//  JstyleNews
//
//  Created by 数字跃动 on 2018/1/24.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsThemeViewController.h"
#import "JstyleNewsThemeCollectionViewCell.h"

@interface JstyleNewsThemeViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *themeArray;

@end

static NSString *JstyleNewsThemeCollectionViewCellID = @"JstyleNewsThemeCollectionViewCellID";

@implementation JstyleNewsThemeViewController

- (NSArray *)themeArray {
    if (_themeArray == nil) {
        _themeArray = @[@"中国红",@"商务黑",@"高贵紫",@"永恒蓝",@"香槟金",@"优雅白"];
    }
    return _themeArray;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat horizontalMargin = 16;
        _flowLayout.itemSize = CGSizeMake((kScreenWidth - horizontalMargin * 2)/3.0, 205+36);
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView  = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = kWhiteColor;
        _collectionView.contentInset = UIEdgeInsetsMake(30, 10, 20, 10);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = YES;
        [_collectionView registerNib:[UINib nibWithNibName:@"JstyleNewsThemeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:JstyleNewsThemeCollectionViewCellID];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"主题换肤";
    
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNightModeBackColor] forBarMetrics:UIBarMetricsDefault];
    self.collectionView.backgroundColor = kNightModeBackColor;

}

- (void)setupUI {
    
    [self.view addSubview:self.collectionView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSInteger selectInt = 0;
        NSString *currentThemeName = [LEETheme currentThemeTag];
        if ([currentThemeName isEqualToString:ThemeName_Red]) {
            selectInt = 0;
        } else if ([currentThemeName isEqualToString:ThemeName_White]) {
            selectInt = 5;
        } else if ([currentThemeName isEqualToString:ThemeName_Blue]) {
            selectInt = 3;
        } else if ([currentThemeName isEqualToString:ThemeName_Black]) {
            selectInt = 1;
        } else if ([currentThemeName isEqualToString:ThemeName_Purple]) {
            selectInt = 2;
        } else if ([currentThemeName isEqualToString:ThemeName_Brown]) {
            selectInt = 4;
        }
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:selectInt inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    });
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.themeArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JstyleNewsThemeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JstyleNewsThemeCollectionViewCellID forIndexPath:indexPath];
    if (indexPath.item < self.themeArray.count) {
        cell.title = self.themeArray[indexPath.item];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%@",self.themeArray[indexPath.item]);
    
    //更换主题
    switch (indexPath.item) {
        case 0:[LEETheme startTheme:ThemeName_Red];break;
        case 1:[LEETheme startTheme:ThemeName_Black];break;
        case 2:[LEETheme startTheme:ThemeName_Purple];break;
        case 3:[LEETheme startTheme:ThemeName_Blue];break;
        case 4:[LEETheme startTheme:ThemeName_Brown];break;
        case 5:[LEETheme startTheme:ThemeName_White];break;
        default:break;
    }
    
    [self setupTabbarThemeWithTag:indexPath.item];
}

- (void)setupTabbarThemeWithTag:(NSInteger)tag {
    switch (tag) {
        case 0:[self setupTabbarSelectedImageWithColorString:@"red" titleColor:ThemeTabbarColor_Red];break;
        case 1:[self setupTabbarSelectedImageWithColorString:@"black" titleColor:ThemeTabbarColor_Black];break;
        case 2:[self setupTabbarSelectedImageWithColorString:@"purple" titleColor:ThemeTabbarColor_Purple];break;
        case 3:[self setupTabbarSelectedImageWithColorString:@"blue" titleColor:ThemeTabbarColor_Blue];break;
        case 4:[self setupTabbarSelectedImageWithColorString:@"brown" titleColor:ThemeTabbarColor_Brown];break;
        case 5:[self setupTabbarSelectedImageWithColorString:@"white" titleColor:ThemeTabbarColor_White];break;
        default:
            break;
    }
}

- (void)setupTabbarSelectedImageWithColorString:(NSString *)colorString titleColor:(UIColor *)titleColor{

    //tab_%@_life_default
    
    self.tabBarController.tabBar.items[0].selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"tab_%@_recommend_selected",colorString]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarController.tabBar.items[1].selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"tab_%@_read_selected",colorString]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarController.tabBar.items[2].selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"tab_%@_culture_selected",colorString]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarController.tabBar.items[3].selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"tab_%@_life_selected",colorString]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarController.tabBar.items[4].selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"tab_%@_my_selected",colorString]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    for (UITabBarItem *item in self.tabBarController.tabBar.items) {
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:titleColor} forState:UIControlStateSelected];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}


@end
