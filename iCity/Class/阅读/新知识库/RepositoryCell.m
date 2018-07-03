//
//  RepositoryCell.m
//  iCity
//
//  Created by mayonggang on 2018/6/14.
//  Copyright © 2018年 LongYuan. All rights reserved.
//知识库

#import "RepositoryCell.h"
#import "ZJScrollPageView.h"
#import "RepositoryCollectionViewController.h"
#import "ICityLifeBannerModel.h"

@interface RepositoryCell() <ZJScrollPageViewDelegate>

@property (nonatomic, strong) ZJScrollPageView *scrollPageView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) NSMutableArray *titles;//栏目标题数组
@end



@implementation RepositoryCell

+(instancetype)initWithTableView:(UITableView *)tableView {
    
    static NSString * cell_id = @"RepositoryCell_id";
    RepositoryCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[RepositoryCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cell_id];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applyTheme) name:NightModeManagerNotification object:nil];

    }
    return self;
}

- (void)setupViews {

    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示遮盖
    style.showCover = YES;
    style.coverBackgroundColor = JSColor(@"#46B6EA");
    style.coverCornerRadius = 0;
    style.coverHeight = 35;
    style.titleMargin = 20;
    style.layerWith = (SCREEN_W-40)/3;
    
    style.showLine = NO;
    style.scrollTitle = NO;
    style.adjustCoverOrLineWidth = NO;
    style.segmentViewBounces = YES;
    style.normalTitleColor = RGBACOLOR(155, 155, 155, 1);
    style.selectedTitleColor = RGBACOLOR(255, 255, 255, 1);
    style.titleFont = JSFontWithWeight(17, UIFontWeightRegular);
    style.selectedTitleFont = JSFontWithWeight(17, UIFontWeightRegular);
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    // 显示附加的按钮
    style.showExtraButton = NO;
    // 设置附加按钮的背景图片
    style.segmentHeight = 35;
    style.autoAdjustTitlesWidth = YES;
    
    // 初始化
    CGRect scrollPageViewFrame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:scrollPageViewFrame segmentStyle:style titles:@[@""] parentViewController:self.viewController delegate:self];
    self.scrollPageView = scrollPageView;
    scrollPageView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:scrollPageView];

    
    self.line = [UIView new];
    [self.scrollPageView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(35);
        make.height.offset(0.5);
    }];
    
    
    [self applyTheme];
}
#pragma mark - 子控制器数目
- (NSInteger)numberOfChildViewControllers {
    return self.collcetionCatagroyArray.count;
}
#pragma mark - 子控制器数据操作
- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    
    RepositoryCollectionViewController *repositoryCV = [[RepositoryCollectionViewController alloc] initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
    ICityKnowledgeBaseModel * model = self.collcetionCatagroyArray[index];
    repositoryCV.pid = model.id;
    
    
    __weak typeof(self) weakSelf = self;
    [repositoryCV setRefreshBlock:^(NSInteger count) {
        if (weakSelf.refreshCellHeightBlock) {
            weakSelf.refreshCellHeightBlock(count);
        }
    }];
    
    repositoryCV.lifeCollectionMenuBlock = ^(NSString *title, NSString *html) {
        if (weakSelf.repositoryCellBlock) {
            weakSelf.repositoryCellBlock(title,html);
        }
    };
    return repositoryCV;
}
#pragma mark - 刷新title类
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
    
    self.backgroundColor = kNightModeBackColor;
    self.contentView.backgroundColor = kNightModeBackColor;
    
    self.scrollPageView.backgroundColor = kNightModeBackColor;
    self.line.backgroundColor = kNightModeLineColor;
    
}


@end
