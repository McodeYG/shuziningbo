//
//  ICityLifeTableHeaderView.m
//  iCity
//
//  Created by 王磊 on 2018/4/28.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityLifeTableHeaderView.h"
#import "ICityLifeBannerModel.h"
#import "ICityBaseMenuButton.h"
#import "ICityLifeBannerModel.h"

@interface ICityLifeTableHeaderView() <SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView  *bannerView;

@property (nonatomic, strong) NSMutableArray *menuButtons;

@property (nonatomic, strong) UIView *line;

@end

@implementation ICityLifeTableHeaderView

#pragma mark - Property

- (void)awakeFromNib {
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:NightModeManagerNotification object:nil];
    
    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0,kScreenWidth,147*kScale) delegate:self placeholderImage:SZ_Place_LIFE];
    
    if (self.bannerView.imageURLStringsGroup.count < 2) {
        self.bannerView.autoScroll = NO;
    }else{
        self.bannerView.autoScroll = YES;
    }
    
    self.bannerView.autoScrollTimeInterval = 8.0f;
    self.bannerView.currentPageDotColor = [UIColor colorFromHexString:@"#636364"];
    self.bannerView.pageDotColor = kWhiteColor;
    self.bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    [self addSubview:self.bannerView];
    
    self.menuButtons = [NSMutableArray arrayWithCapacity:4];
    CGFloat buttonWidth = kScreenWidth / 4.0;
    for (NSInteger i = 0; i < 4; i++) {
        ICityBaseMenuButton *menuButton = [ICityBaseMenuButton buttonWithImage:[UIImage new] title:@""];
        menuButton.frame = CGRectMake(i*buttonWidth, self.bannerView.height, buttonWidth, 101 * kScale);
        menuButton.tag = 4000 + i;
        [menuButton addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuButton];
        [self.menuButtons addObject:menuButton];
    }
    
    self.line = [[UIView alloc] init];
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.offset(7);
    }];
    
    [self applyTheme];
}

- (void)menuButtonClick:(UIButton *)button {
    
    if (self.menuButtonClickBlock) {
        ICityLifeMenuModel *model = self.menuArray[button.tag - 4000];
        self.menuButtonClickBlock(model.name, model.html);
    }
}

#pragma mark - CycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.bannerClickBlock) {
        self.bannerClickBlock(index);
    }
}

- (void)setBannerArray:(NSMutableArray *)bannerArray {
    _bannerArray = bannerArray;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (ICityLifeBannerModel *model in bannerArray) {
        [array addObject:model.poster];
    }
    self.bannerView.imageURLStringsGroup = array;
}

- (void)setMenuArray:(NSArray<ICityLifeMenuModel *> *)menuArray {
    _menuArray = menuArray;
    
    for (NSInteger i = 0; i < self.menuButtons.count; i++) {
        
        ICityBaseMenuButton *button = self.menuButtons[i];
        if (i < menuArray.count) {
            NSURL *imageUrl = [NSURL URLWithString:[menuArray[i] icon]];
            NSString *title = [menuArray[i] name];
            [button setImageWithURL:imageUrl forState:UIControlStateNormal placeholder:SZ_Place_Header];
            [button setTitle:title forState:UIControlStateNormal];
        }
    }
}

- (void)applyTheme {
    
    self.backgroundColor = kNightModeBackColor;
    self.bannerView.backgroundColor = kNightModeBackColor;
    self.line.backgroundColor = kNightModeLineColor;//JSColor(@"#F2F2F2");
    
    UIColor * color = ISNightMode?kDarkCCCColor:kDarkThreeColor;
    for (ICityBaseMenuButton *button in self.menuButtons) {
        
        [button setTitleColor:color forState:(UIControlStateNormal)];
    }

}

@end
