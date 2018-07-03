//
//  ICityLifeTableViewCell.m
//  iCity
//
//  Created by 王磊 on 2018/4/29.
//  Copyright © 2018年 LongYuan. All rights reserved.
//  生活

#import "ICityLifeTableViewCell.h"
#import "ZJScrollPageView.h"
#import "ICityLifeCollectionViewController.h"
#import "ICityLifeBannerModel.h"

@interface ICityLifeTableViewCell() <ZJScrollPageViewDelegate>

@property (nonatomic, strong) ZJScrollPageView *scrollPageView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) ZJSegmentStyle *style;
@property (nonatomic, strong) NSMutableArray *titles;//栏目标题数组
@end

@implementation ICityLifeTableViewCell

-(void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //必要的设置, 如果没有设置可能导致内容显示不正常
    _style = [[ZJSegmentStyle alloc] init];
    //显示遮盖
    _style.showCover = YES;
    _style.coverBackgroundColor = JSColor(@"#46B6EA");
    _style.coverCornerRadius = 0;
    _style.coverHeight = 35;
    _style.titleMargin = 0;
    _style.showLine = NO;
    _style.scrollTitle = YES;
    _style.adjustCoverOrLineWidth = NO;
    _style.segmentViewBounces = NO;
    _style.normalTitleColor = RGBACOLOR(155, 155, 155, 1);
    _style.selectedTitleColor = RGBACOLOR(255, 255, 255, 1);
    _style.titleFont = JSFontWithWeight(17, UIFontWeightRegular);
    _style.selectedTitleFont = JSFontWithWeight(17, UIFontWeightRegular);
    // 颜色渐变
    _style.gradualChangeTitleColor = YES;
    // 显示附加的按钮
    _style.showExtraButton = NO;
    // 设置附加按钮的背景图片
    _style.segmentHeight = 35;
    _style.autoAdjustTitlesWidth = YES;
    
    // 初始化
    CGRect scrollPageViewFrame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:scrollPageViewFrame segmentStyle:_style titles:@[@""] parentViewController:self.viewController delegate:self];
    self.scrollPageView = scrollPageView;
    scrollPageView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:scrollPageView];
    
    self.line = [UIView new];
    [self.scrollPageView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(35);
        make.height.offset(1);
    }];

    [self applyTheme];
}

- (NSInteger)numberOfChildViewControllers {
    return self.collcetionCatagroyArray.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    ICityLifeCollectionViewController *lifeCV = [[ICityLifeCollectionViewController alloc] initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
    lifeCV.parentID = [self.collcetionCatagroyArray[index] id];
    __weak typeof(self) weakSelf = self;
    lifeCV.lifeCollectionMenuBlock = ^(NSString *title, NSString *html) {
        if (weakSelf.lifeCollectionMenuBlock) {
            weakSelf.lifeCollectionMenuBlock(title,html);
        }
    };
    return lifeCV;
}

- (void)setCollcetionCatagroyArray:(NSArray *)collcetionCatagroyArray {
    _collcetionCatagroyArray = collcetionCatagroyArray;
    
    self.titles = [NSMutableArray arrayWithCapacity:collcetionCatagroyArray.count];
    for (NSInteger i = 0; i < collcetionCatagroyArray.count; i++) {
        NSString *title = [collcetionCatagroyArray[i] name];
        [self.titles addObject:title];
    }
    if (self.titles.count) {
        [self.scrollPageView reloadWithNewTitles:self.titles];
    }
}


- (void)applyTheme {
    [super applyTheme];
    
    self.scrollPageView.backgroundColor = kNightModeBackColor;
    self.line.backgroundColor = kNightModeLineColor;
    
}

@end
