//
//  CultureListReuseController.m
//  iCity
//
//  Created by mayonggang on 2018/7/16.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "CultureListReuseController.h"
#import "ICityCultureListReuseTableViewCell.h"
#import "ICityCultureReuseModel.h"
#import "JstylePartyDetailsViewController.h"//文化活动
#import "ICityCultureDetailViewController.h"//文化地图
#import "MoreListView.h"
#import "RImageButton.h"

static NSUInteger typeTag = 120;//类型按钮
static NSUInteger timeTag = 130;//时间按钮
static NSUInteger regionTag = 140;//地区按钮

static NSInteger page = 1;
static NSString * const ICityCultureListReuseTableViewCellID = @"ICityCultureListReuseTableViewCellID";

@interface CultureListReuseController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) NSArray * titleArray;//顶部三个按钮

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, assign) NSInteger top_select_tag;//点击了按钮时间。地区。类型
@property (nonatomic, copy) NSString * sendId;//标签的id


@property (nonatomic, strong) NSMutableArray *dataArray;
//4.文化活动类型; 5.文化地图类型；6.旅游景点类型
@property (nonatomic, copy) NSString * type;

//记录选中的button位置
@property (nonatomic, assign) NSInteger type_selecIndex;
@property (nonatomic, assign) NSInteger time_selectIndex;
@property (nonatomic, assign) NSInteger region_selecIndex;

/**tags*/
@property (nonatomic, strong) MoreListView * tagsView;
/**类型的标签*/
@property (nonatomic, strong) NSArray *typeTagArray;
/**地区的标签*/
@property (nonatomic, strong) NSArray *regionTagArray;
//时间的标签
@property (nonatomic, strong) NSArray *timeTagArray;

@end


@implementation CultureListReuseController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = (self.navigationTitle == nil ? @"" : self.navigationTitle);
    
    [self creatMyTableView];
    [self creatMytagsView];
    //默认sendId是类型的全部
    _sendId = @" ";
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.topView.backgroundColor = kNightModeBackColor;
    self.tableView.backgroundColor = kNightModeBackColor;
    self.view.backgroundColor = kNightModeBackColor;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UIColor * textColor = ISNightMode?kDarkCCCColor:JSColor(@"#000000");
    
    NSDictionary *titleColor = @{ NSForegroundColorAttributeName:textColor,
                                  NSFontAttributeName:[UIFont systemFontOfSize:18] };
    
    [self.navigationController.navigationBar setTitleTextAttributes:titleColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNightModeBackColor] forBarMetrics:(UIBarMetricsDefault)];
    [self addLeftBarButtonWithImage:ISNightMode?JSImage(@"返回白色"):JSImage(@"图文返回黑") action:@selector(leftItemClick)];
}

- (void)creatMytagsView {
    //昨天今天最近一周
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 40)];
    [self.view addSubview:self.topView];
    
    
    if ([self.navigationTitle isEqualToString:@"文化活动"]) {
        _type = @"4";
        _titleArray = @[@"类型",@"时间",@"地区"];
    } else if ([self.navigationTitle isEqualToString:@"文化地图"]) {
        _type = @"5";
        _titleArray = @[@"类型",@"地区"];
    } else {//旅游景点
        _type = @"6";
        _titleArray = @[@"类型",@"地区"];
    }
    
    
    for (int i=0;i<_titleArray.count;i++) {
        
        NSString * name = _titleArray[i];
        RImageButton * button = [RImageButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnW = SCREEN_W/_titleArray.count;
        
        button.frame = CGRectMake(i*btnW, 0, btnW, 40);
        if ([name isEqualToString:@"类型"]) {
            button.tag = typeTag;
        }else if ([name isEqualToString:@"时间"]) {
            button.tag = timeTag;
        }else{
            button.tag = regionTag;
        }
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
       
        [button setTitleColor:kNightModeTextColor forState:(UIControlStateNormal)];
       
        [button setImage:[UIImage imageNamed:@"more_list"] forState:(UIControlStateNormal)];
//        [self setBtn:button title:name];
        [self setBtn:button title:name forState:(UIControlStateNormal)];
        //主题换肤
        button.lee_theme
        .LeeCustomConfig(ThemeTypeBtnTitleColor, ^(id item, id value) {
            UIButton *button = (UIButton *)item;
            [button setTitleColor:value forState:UIControlStateSelected];
        });

        
        [button addTarget:self action:@selector(topButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.topView addSubview:button];
        if (i<_titleArray.count-1) {
            UIView * vLine = [[UIView alloc]initWithFrame:CGRectMake(btnW-0.5, 14, 0.5, 12)];
            vLine.backgroundColor = kNightModeLineColor;
            [button addSubview:vLine];
        }
        
    }

    UIView * hLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 0.5)];
    hLine.backgroundColor = kNightModeLineColor;
    [self.topView addSubview:hLine];
    UIView * hLine2 = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, SCREEN_W, 0.5)];
    hLine2.backgroundColor = kNightModeLineColor;
    [self.topView addSubview:hLine2];
    
    
    self.tagsView = [[MoreListView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_W, 0.5)];
    self.tagsView.GBbackgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.tagsView.cornerRadius = 14;
    
    self.tagsView.horizontalPadding = 14;
#pragma mark - 标签按钮点击事件
    kweakSelf
    [self.tagsView setDidselectItemBlock:^(NSInteger indexPath) {
       
        ICityLifeMenuModel * model = [ICityLifeMenuModel new];
        if (weakSelf.top_select_tag == timeTag) {
            weakSelf.time_selectIndex = indexPath;
            model = weakSelf.timeTagArray[indexPath];
            for (RImageButton *btn in weakSelf.topView.subviews) {
                if (btn.tag == timeTag) {
//                    [weakSelf setBtn:btn title:model.name];
                    [weakSelf setBtn:btn title:model.name forState:(UIControlStateSelected)];
                }
            }
        } else if (weakSelf.top_select_tag == typeTag) {
            weakSelf.type_selecIndex = indexPath;
            model = weakSelf.typeTagArray[indexPath];
            
            for (RImageButton *btn in weakSelf.topView.subviews) {
                if (btn.tag == typeTag) {
//                    [weakSelf setBtn:btn title:model.name];
                    [weakSelf setBtn:btn title:model.name forState:(UIControlStateSelected)];
                }
            }
        } else {//地区
            weakSelf.region_selecIndex = indexPath;
            model = weakSelf.regionTagArray[indexPath];
            
            for (RImageButton *btn in weakSelf.topView.subviews) {
                if (btn.tag == regionTag) {
//                    [weakSelf setBtn:btn title:model.name];
                    [weakSelf setBtn:btn title:model.name forState:(UIControlStateSelected)];
                }
            }
        }
        
        
        page = 1;
        weakSelf.sendId = model.id;
        [weakSelf loadDataWithSendId:weakSelf.sendId];
        
    }];
    
    self.tagsView.hidden = YES;
    
    self.tagsView.clipsToBounds = YES;
    [self.view addSubview:self.tagsView];
    [self loadMoreTypeTagsData];
    [self loadMoreRegionTagsData];
    
    if ([self.navigationTitle isEqualToString:@"文化活动"]) {
        [self loadMoreTimeTagsData];
    }
}
#pragma mark - 设置顶部三个按钮的title
//- (void)setBtn:(RImageButton *)btn title:(NSString *)title {
//    if ([title isEqualToString:@"全部"]) {
//        btn.selected = NO;
//        if (btn.tag == typeTag) {
//            title = @"类型";
//        } else if (btn.tag == timeTag) {
//            title = @"时间";
//        } else{
//            title = @"地区";
//        }
//    }
//    [btn setTitle:title forState:(UIControlStateNormal)];
//    CGFloat btnW = SCREEN_W/_titleArray.count;
//    CGFloat contentW = title.length*16+5+9;
//    [btn setTitleRect:CGRectMake(btnW/2-contentW/2, 12, title.length*16, 16)];
//    [btn setImageRect:CGRectMake(btnW/2-contentW/2+title.length*16+5, 17.5, 9, 5)];
//}

- (void)setBtn:(RImageButton *)btn title:(NSString *)title forState:(UIControlState)state {

    [btn setTitle:title forState:(state)];
    CGFloat btnW = SCREEN_W/_titleArray.count;
    CGFloat contentW = title.length*16+5+9;
    [btn setTitleRect:CGRectMake(btnW/2-contentW/2, 12, title.length*16, 16)];
    [btn setImageRect:CGRectMake(btnW/2-contentW/2+title.length*16+5, 17.5, 9, 5)];
    
    NSArray * arr = @[@"全部",@"类型",@"时间",@"地区"];
    if ([arr containsObject:title]) {
        btn.selected = NO;
    } else {
        btn.selected = YES;
    }
    
}

#pragma mark - 时间、类型、地区 按钮响应事件
- (void)topButtonAction:(UIButton *)button {
    
    self.top_select_tag = button.tag;
    if (button.tag == timeTag) {
        [self.tagsView setTagWithTagArray:self.timeTagArray andSelectIndex:self.time_selectIndex];
    }else if (button.tag == typeTag) {
        [self.tagsView setTagWithTagArray:self.typeTagArray andSelectIndex:self.type_selecIndex];
    }else{//地区
        [self.tagsView setTagWithTagArray:self.regionTagArray andSelectIndex:self.region_selecIndex];
    }
    [self.view bringSubviewToFront:self.tagsView];
    self.tagsView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.tagsView.mj_h = SCREEN_H;
    }];
}

- (void)creatMyTableView {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_W, SCREEN_H-YG_StatusAndNavightion_H-YG_SafeBottom_H-40) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kWhiteColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[ICityCultureListReuseTableViewCell class] forCellReuseIdentifier:ICityCultureListReuseTableViewCellID];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf loadDataWithSendId:self.sendId];
        
    }];
    
    self.tableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weakSelf loadDataWithSendId:self.sendId];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ICityCultureListReuseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ICityCultureListReuseTableViewCellID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (112.0*kScale*(149.0/112.0) + 20);
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.navigationTitle isEqualToString:@"文化活动"]) {
        JstylePartyDetailsViewController *partyVC = [JstylePartyDetailsViewController new];
        ICityCultureMorePopularActivitiesModel * model = self.dataArray[indexPath.row];
        partyVC.partyId = model.id;
        [self.navigationController pushViewController:partyVC animated:YES];
    }else{
        //更多  旅游景点 文化地图
        ICityCultureDetailViewController *cultureDetailVC = [ICityCultureDetailViewController new];
        cultureDetailVC.rid = [self.dataArray[indexPath.row] field_id];
        ICityCultureMoreMapModel * model = self.dataArray[indexPath.row];
        JstyleNewsArticleDetailModel * titleModel = [JstyleNewsArticleDetailModel new];
        titleModel.author_name = model.author_name;
        titleModel.poster = model.poster;
        titleModel.title = model.title;
        titleModel.author_did = model.author_did;
        titleModel.TOrFOriginal = model.TOrFOriginal;
        titleModel.author_img = model.author_img;
        titleModel.cname = model.cname;
        titleModel.ctime = model.ctime;
        titleModel.id = model.id;
        titleModel.isShowAuthor = model.isShowAuthor;
        titleModel.content = model.content;
        
        cultureDetailVC.titleModel = titleModel;
        
        [self.navigationController pushViewController:cultureDetailVC animated:YES];
    }
    
}

#pragma mark - 下载更多 《类型》 标签数据
- (void)loadMoreTypeTagsData {
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    NSDictionary * para = @{@"type":self.type};
    [manager GETURL:Culture_TV_Menu_URL parameters:para success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            self.typeTagArray = [NSArray modelArrayWithClass:[ICityLifeMenuModel class] json:responseObject[@"data"]];
            [self.tagsView setTagWithTagArray:self.typeTagArray andSelectIndex:0];
        }
    } failure:^(NSError *error) {
    }];
    
}

#pragma mark - 下载更多 《地区》 标签数据
- (void)loadMoreRegionTagsData {
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    NSDictionary * para = @{@"parentCode":@"330200"};
    [manager GETURL:Culture_Regionlist_URL parameters:para success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            self.regionTagArray = [NSArray modelArrayWithClass:[ICityLifeMenuModel class] json:responseObject[@"data"]];
            
        }
    } failure:^(NSError *error) {
    }];
}
#pragma mark - 下载更多 《时间》 标签数据
- (void)loadMoreTimeTagsData {
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    [manager GETURL:Culture_Timelist_URL parameters:nil success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            self.timeTagArray = [NSArray modelArrayWithClass:[ICityLifeMenuModel class] json:responseObject[@"data"]];
            
        }
    } failure:^(NSError *error) {
    }];
}


#pragma mark - 下载列表数据

- (void)loadDataWithSendId:(NSString *)sendId{
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    NSDictionary *paramaters;
    if (![self.sendId isNotBlank]) {
        paramaters = @{ @"page":[NSString stringWithFormat:@"%zd",page] };
    }else  if (_top_select_tag == timeTag) {
        
        paramaters = @{ @"page":[NSString stringWithFormat:@"%zd",page],
           @"time_slot":_sendId };
    } else if (_top_select_tag == typeTag) {
        paramaters = @{ @"page":[NSString stringWithFormat:@"%zd",page],
           @"scenic_type_id":_sendId };
    } else {
        paramaters = @{ @"page":[NSString stringWithFormat:@"%zd",page],
           @"scenic_region_id":_sendId };
    }
    
    [manager GETURL:self.dataURL parameters:paramaters success:^(id responseObject) {
        
//        NSLog(@"%@",self.dataURL);
        
        if (page==1) {
            [self.dataArray removeAllObjects];
        }
        
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            NSArray *currentData;
            if ([self.navigationTitle isEqualToString:@"文化活动"]) {
                currentData = [NSArray modelArrayWithClass:[ICityCultureMorePopularActivitiesModel class] json:responseObject[@"data"]];
            } else {
                //文化地图 、旅游景点
                currentData = [NSArray modelArrayWithClass:[ICityCultureMoreMapModel class] json:responseObject[@"data"]];
            }
            
            [self.dataArray addObjectsFromArray:currentData];
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
        } else {
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)leftItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}


@end
