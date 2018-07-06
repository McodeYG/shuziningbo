//
//  JstyleNewsSearchViewController.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/1.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsSearchViewController.h"
#import "ZTTagListView.h"
#import "JstyleNewsSearchModel.h"

#import "ZJScrollPageView.h"
#import "JstyleNewsSearchComprehensiveViewController.h"
#import "JstyleNewsSearchArticlesViewController.h"
#import "JstyleNewsSearchVideosViewController.h"
#import "JstyleNewsSearchPicturesViewController.h"
#import "JstyleNewsSearchJmNumsViewController.h"

#define kTitleArray    @[@"综合", @"文章", @"视频" ,@"图集" ,@"iCity号"]

@interface JstyleNewsSearchViewController ()<ZJScrollPageViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITextField *searchBar;
@property (nonatomic, strong) UIView *searchHoldView;
@property (nonatomic, copy) NSString *keyword;//搜索词

@property (nonatomic, strong) ZJScrollPageView *scrollPageView;
@property (nonatomic, strong) UIView *pageHoldView;

@property (nonatomic, strong) ZTTagListView *hotTagList;
@property (nonatomic, strong) ZTTagListView *historyTagList;

/***/
@property (nonatomic, strong) JstyleNewsBaseTableView *tableView;
/**清除历史记录按钮*/
@property (nonatomic, strong) UIButton *cleanBtn;
/**热门搜索的数组*/
@property (nonatomic, strong) NSMutableArray *hotSearchArray;
/**热门搜索的热词数组*/
@property (nonatomic, strong) NSMutableArray *hotSearchKeys;
/**历史搜索的数组*/
@property (nonatomic, strong) NSMutableArray *historySearchArray;
/**热门搜索的热词数组*/
@property (nonatomic, strong) NSMutableArray *historySearchKeys;

@end

@implementation JstyleNewsSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self addSearchBarView];
    [self addLeftBarButtonItemWithTitle:nil action:@selector(leftBarButtonAction)];
    [self addRightBarButtonItemWithTitle:@"取消" color:kLightBlueColor action:@selector(rightBarButtonAction)];
    [self addTableViewAndClearBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNightModeBackColor] forBarMetrics:(UIBarMetricsDefault)];
    
    [self getHotSearchDataSource];
    [self getHistorySearchDataSource];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}

- (void)addSearchBarView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(30, 0, kScreenWidth - 90, 30)];
    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(- 30, 0, titleView.width, 30)];
    searchBtn.backgroundColor = ISNightMode?kDarkFiveColor:kManagementGrayColor;
    searchBtn.layer.cornerRadius = 15;
    searchBtn.clipsToBounds = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 17, 17)];
    imageView.image = [UIImage imageNamed:@"推荐-搜索放大镜_search"];
    
    _searchBar = [[UITextField alloc]initWithFrame:CGRectMake(40, 0, searchBtn.width - 40, 30)];

    self.searchBar.lee_theme
    .LeeConfigBackgroundColor(@"searchBarBack");
    
    _searchBar.tintColor = kLightBlueColor;
    _searchBar.lee_theme
    .LeeConfigTintColor(ThemeMainBtnTitleOrBorderColor);
    _searchBar.font = [UIFont systemFontOfSize:13];
    _searchBar.placeholder = @" 请输入关键词...";
    _searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchBar.returnKeyType = UIReturnKeySearch;
    _searchBar.keyboardAppearance = ISNightMode?UIKeyboardAppearanceDark:UIKeyboardAppearanceDefault;
    _searchBar.delegate = self;
    
    [searchBtn addSubview:imageView];
    [searchBtn addSubview:_searchBar];
    [titleView addSubview:searchBtn];
    self.navigationItem.titleView = titleView;
}

- (void)addSearchHoldView
{
    _searchHoldView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_searchHoldView];
    _searchHoldView.hidden = YES;
}

- (void)addTableViewAndClearBtn
{
    _cleanBtn = [[UIButton alloc]init];
    [_cleanBtn setTitle:@"清空历史记录" forState:(UIControlStateNormal)];
    [_cleanBtn setTitleColor:kLightBlueColor forState:(UIControlStateNormal)];
    [_cleanBtn addTarget:self action:@selector(cleanBtnAction) forControlEvents:UIControlEventTouchUpInside];
    _cleanBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _cleanBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _cleanBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, (IS_iPhoneX?10:0), 0);
    [self.view addSubview:_cleanBtn];
    _cleanBtn.sd_layout
    .bottomEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(48 + (IS_iPhoneX?10:0));
    
    _tableView = [[JstyleNewsBaseTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    _tableView.sd_layout
    .topSpaceToView(self.view, (SYSTEM_VERSION_LESS_THAN(@"11.0")?64:0))
    .bottomSpaceToView(_cleanBtn, 0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self.searchBar resignFirstResponder];
    NSString *searchStr = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([NSString stringContainsEmoji:searchStr]) {
        ZTShowAlertMessage(@"不能搜索表情等特殊字符");
        return NO;
    }
    
    if (searchStr.length >38) {
        searchStr = [searchStr substringToIndex:38];
    }
    
    if (searchStr == nil || [searchStr isEqualToString:@""]) {
        ZTShowAlertMessage(@"搜索内容不能为空");
        self.searchBar.text = nil;
        return NO;
    }else if (self.searchBar.text == nil || [self.searchBar.text isEqualToString:@""]) {
        ZTShowAlertMessage(@"搜索内容不能为空");
        return NO;
    }else {
        self.keyword = searchStr;
        self.searchBar.text = searchStr;
        [self.view removeAllSubviews];
        [self addSearchHoldView];
        [self addPageView];
        return YES;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.searchBar.text = nil;
    [self.view removeAllSubviews];
    [self addTableViewAndClearBtn];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _searchHoldView.hidden = NO;
    [self.view bringSubviewToFront:_searchHoldView];
    return YES;
}

#pragma mark -- 历史搜索的tableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = ISNightMode?kNightModeBackColor:kWhiteColor;
    UIView *columnView = [[UIView alloc]init];
    columnView.backgroundColor = ISNightMode?JSColor(@"#A63F3F"):kPinkColor;
    [headerView addSubview:columnView];
    columnView.sd_layout
    .leftSpaceToView(headerView, 15)
    .centerYEqualToView(headerView)
    .widthIs(2)
    .heightIs(15);
    columnView.lee_theme
    .LeeConfigBackgroundColor(ThemeMainBtnTitleOrBorderColor);
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = ISNightMode?kPinkColor:JSColor(@"#6F6F6F");
    [headerView addSubview:titleLabel];
    
    
    titleLabel.sd_layout
    .leftSpaceToView(columnView, 10)
    .rightSpaceToView(headerView, 10)
    .centerYEqualToView(headerView)
    .heightIs(13);
    
    if (section == 0) {
        titleLabel.text = @"热门搜索";
    }else{
        titleLabel.text = @"历史搜索";
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *ID = @"hotCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID ];
        }
        
        [_hotTagList removeFromSuperview];
        _hotTagList = [[ZTTagListView alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth - 10, 0)];
        _hotTagList.canTouch = YES;
        _hotTagList.titleColor = ISNightMode?kDarkNineColor:kDarkOneColor;
        _hotTagList.GBbackgroundColor = ISNightMode?kNightModeBackColor:kWhiteColor;
        _hotTagList.tagBackgroundColor = ISNightMode? JSColor(@"191A1C"):JSColor(@"#F6F7FB");
        [_hotTagList setTagWithTagArray:self.hotSearchKeys];
        __weak typeof(self)weakSelf = self;
        [_hotTagList setDidselectItemBlock:^(NSInteger indexPath) {
            if (indexPath < weakSelf.hotSearchArray.count) {
                JstyleNewsSearchModel *model = weakSelf.hotSearchArray[indexPath];
//                JstyleNewsSearchResultViewController *jstyleSearchResultVC = [JstyleNewsSearchResultViewController new];
//                jstyleSearchResultVC.keyword = model.name;
//                [weakSelf.navigationController pushViewController:jstyleSearchResultVC animated:YES];
                [weakSelf.view removeAllSubviews];
                [weakSelf.searchBar resignFirstResponder];
                weakSelf.keyword = model.name;
                weakSelf.searchBar.text = model.name;
                [weakSelf addSearchHoldView];
                [weakSelf addPageView];
            }
        }];
        [cell addSubview:_hotTagList];
        
        cell.backgroundColor = kNightModeBackColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *ID = @"historyCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID ];
        }
        
        [_historyTagList removeFromSuperview];
        _historyTagList = [[ZTTagListView alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth - 10, 0)];
        _historyTagList.canTouch = YES;
        _historyTagList.titleColor = ISNightMode?kDarkNineColor:kDarkOneColor;
        _historyTagList.GBbackgroundColor = ISNightMode?kNightModeBackColor:kWhiteColor;
        _historyTagList.tagBackgroundColor = ISNightMode? JSColor(@"191A1C"):JSColor(@"#F6F7FB");
        [_historyTagList setTagWithTagArray:self.historySearchKeys];
        __weak typeof(self)weakSelf = self;
        [_historyTagList setDidselectItemBlock:^(NSInteger indexPath) {
            if (indexPath < weakSelf.historySearchArray.count) {
                JstyleNewsSearchModel *model = weakSelf.historySearchArray[indexPath];
//                JstyleNewsSearchResultViewController *jstyleSearchResultVC = [JstyleNewsSearchResultViewController new];
//                jstyleSearchResultVC.keyword = model.name;
//                [weakSelf.navigationController pushViewController:jstyleSearchResultVC animated:YES];
                [weakSelf.view removeAllSubviews];
                [weakSelf.searchBar resignFirstResponder];
                weakSelf.keyword = model.name;
                weakSelf.searchBar.text = model.name;
                [weakSelf addSearchHoldView];
                [weakSelf addPageView];
            }
        }];
        [cell addSubview:_historyTagList];
        
        cell.backgroundColor = kNightModeBackColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        if (!self.hotTagList.height) return 0;
        return self.hotTagList.height;
    }
    return self.historyTagList.height;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _searchHoldView.hidden = YES;
    [self.searchBar resignFirstResponder];
}

- (void)addPageView{
    _pageHoldView = [[UIView alloc] init];
    _pageHoldView.backgroundColor = kBackGroundColor;
    [self.view addSubview:_pageHoldView];
    _pageHoldView.sd_layout
    .topSpaceToView(self.view, YG_StatusAndNavightion_H)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(40);
    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    // 缩放标题
    style.scaleTitle = YES;
    style.isChangeScrollViewFrame = YES;
    style.titleFont = JSFont(12);
    style.titleBigScale = 1.25;
    style.segmentHeight = 40;
    //    style.autoAdjustTitlesWidth = YES;
    style.normalTitleColor = ISNightMode?RGBACOLOR(159, 159, 159, 1):RGBACOLOR(176, 174, 188, 1);
    style.selectedTitleColor = ISNightMode?RGBACOLOR(85, 85, 85, 1):RGBACOLOR(0, 0, 0, 1);
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    style.scrollTitle = NO;
    // 设置附加按钮的背景图片
    // 初始化
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, YG_StatusAndNavightion_H, kScreenWidth, kScreenHeight - YG_StatusAndNavightion_H) segmentStyle:style titles:kTitleArray parentViewController:self delegate:self];
    scrollPageView.backgroundColor = kNightModeBackColor;
    scrollPageView.segmentView.scrollView.frame = CGRectMake(40 * kScreenWidth/375.0, 0, kScreenWidth - 80 * kScreenWidth/375.0, 40);
    self.scrollPageView = scrollPageView;
    
    for (int i = 1; i < kTitleArray.count; i ++) {
        CGFloat lineWidth = (kScreenWidth - 80 * kScreenWidth/375.0)/kTitleArray.count;
        UIView *singleLine = [[UIView alloc] initWithFrame:CGRectMake(lineWidth * i, 15, 0.5, 10)];
        singleLine.backgroundColor = [UIColor colorFromHexString:@"#69686D"];
        [scrollPageView.segmentView.scrollView addSubview:singleLine];
    }
    [self.view addSubview:scrollPageView];
}

#pragma ZJScrollPageViewDelegate 代理方法
- (NSInteger)numberOfChildViewControllers {
    return kTitleArray.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    switch (index) {
        case 0:{
            JstyleNewsSearchComprehensiveViewController *jstyleNewsSearchCVC = [JstyleNewsSearchComprehensiveViewController new];
            jstyleNewsSearchCVC.keyword = self.keyword;
            return jstyleNewsSearchCVC;
        }
            break;
        case 1:{
            JstyleNewsSearchArticlesViewController *jstyleNewsSearchAVC = [JstyleNewsSearchArticlesViewController new];
            jstyleNewsSearchAVC.keyword = self.keyword;
            return jstyleNewsSearchAVC;
        }
            break;
        case 2:{
            JstyleNewsSearchVideosViewController *jstyleNewsSearchVideosVC = [JstyleNewsSearchVideosViewController new];
            jstyleNewsSearchVideosVC.keyword = self.keyword;
            return jstyleNewsSearchVideosVC;
        }
            break;
        case 3:{
            JstyleNewsSearchPicturesViewController *jstyleNewsSearchPicturesVC = [JstyleNewsSearchPicturesViewController new];
            jstyleNewsSearchPicturesVC.keyword = self.keyword;
            return jstyleNewsSearchPicturesVC;
        }
            break;
        default:{
            JstyleNewsSearchJmNumsViewController *jstyleNewsSearchJmNumsVC = [JstyleNewsSearchJmNumsViewController new];
            jstyleNewsSearchJmNumsVC.keyword = self.keyword;
            return jstyleNewsSearchJmNumsVC;
        }
            break;
    }
}

#pragma mark -- 清除历史搜索的按钮
- (void)cleanBtnAction
{
    [self cleanHistorySearchDataSource];
}

- (void)leftBarButtonAction
{
    
}

- (void)rightBarButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

/**获取热门搜索的数据*/
- (void)getHotSearchDataSource
{
    [[JstyleNewsNetworkManager shareManager] GETURL:HOT_SEARCH_URL parameters:nil progress:nil success:^(id responseObject) {
        NSDictionary *dictionary = responseObject;
        if ([dictionary[@"code"] integerValue] != 1 || [dictionary[@"data"] count] == 0) {
            return;
        }

        [self.hotSearchKeys removeAllObjects];
        [self.hotSearchArray removeAllObjects];
        for (NSDictionary *dict in dictionary[@"data"]) {
            [self.hotSearchKeys addObject:dict[@"name"]];
            JstyleNewsSearchModel *model = [JstyleNewsSearchModel new];
            [model setValuesForKeysWithDictionary:dict];
            [self.hotSearchArray addObject:model];
        }
        [self.tableView reloadData];
    } failure:nil];
}

/**获取历史搜索的数据*/
- (void)getHistorySearchDataSource
{
    NSDictionary *parameters = @{@"uuid":[[JstyleToolManager sharedManager] getUDID]};
    [[JstyleNewsNetworkManager shareManager] GETURL:HISTORY_SEARCH_URL parameters:parameters progress:nil success:^(id responseObject) {
        NSDictionary *dictionary = responseObject;
        if ([dictionary[@"code"] integerValue] != 1) {
            return;
        }
        [self.historySearchKeys removeAllObjects];
        [self.historySearchArray removeAllObjects];
        for (NSDictionary *dict in dictionary[@"data"]) {
            [self.historySearchKeys addObject:dict[@"name"]];
            JstyleNewsSearchModel *model = [JstyleNewsSearchModel new];
            [model setValuesForKeysWithDictionary:dict];
            [self.historySearchArray addObject:model];
        }
        [self.tableView reloadData];
    } failure:nil];
}

/**删除历史搜索的数据*/
- (void)cleanHistorySearchDataSource
{
    NSDictionary *parameters = @{@"uuid":[[JstyleToolManager sharedManager] getUDID]};
    [[JstyleNewsNetworkManager shareManager] GETURL:CLEAN_HISTORY_SEARCH_URL parameters:parameters progress:nil success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            [self.historySearchKeys removeAllObjects];
            [self.historySearchArray removeAllObjects];
            ZTShowAlertMessage(responseObject[@"data"]);
            [self.tableView reloadData];
        }
    } failure:nil];
}

- (NSMutableArray *)hotSearchArray
{
    if (!_hotSearchArray) {
        _hotSearchArray = [NSMutableArray array];
    }
    return _hotSearchArray;
}

- (NSMutableArray *)hotSearchKeys
{
    if (!_hotSearchKeys) {
        _hotSearchKeys = [NSMutableArray array];
    }
    return _hotSearchKeys;
}

- (NSMutableArray *)historySearchArray
{
    if (!_historySearchArray) {
        _historySearchArray = [NSMutableArray array];
    }
    return _historySearchArray;
}

- (NSMutableArray *)historySearchKeys
{
    if (!_historySearchKeys) {
        _historySearchKeys = [NSMutableArray array];
    }
    return _historySearchKeys;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
