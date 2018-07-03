//
//  JstyleNewsJmNumsDetailLiveViewController.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/1/9.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsJmNumsDetailLiveViewController.h"
#import "JstylePersonalMediaDetailLiveCell.h"
#import "JstyleNewsPlaceholderView.h"
#import "JstyleNewsVideoDetailViewController.h"

@interface JstyleNewsJmNumsDetailLiveViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) JstyleNewsBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) JstyleNewsPlaceholderView *placeholderView;

@end

static NSInteger page = 1;
@implementation JstyleNewsJmNumsDetailLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ISNightMode?kNightModeBackColor:kWhiteColor;
    [self addTableView];
    [self addReshAction];
    page = 1;
    [self getJstylePersonalMediaHomeDataSource];
}

- (void)zj_viewDidLoadForIndex:(NSInteger)index {
    
}

- (void)addReshAction
{
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [weakSelf getJstylePersonalMediaHomeDataSource];
    }];
}

- (void)addTableView
{
    _tableView = [[JstyleNewsBaseTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:(UITableViewStylePlain)];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
//    _tableView.separatorColor = kSingleLineColor;
//    _tableView.backgroundColor = kWhiteColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.tableFooterView = [UIView new];
    
    [_tableView registerNib:[UINib nibWithNibName:@"JstylePersonalMediaDetailLiveCell" bundle:nil] forCellReuseIdentifier:@"JstylePersonalMediaDetailLiveCell"];
    
    [self.view addSubview:_tableView];
    _tableView.sd_layout
    .topEqualToView(self.view)
    .bottomEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view);
}

#pragma mark -- tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"JstylePersonalMediaDetailLiveCell";
    JstylePersonalMediaDetailLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[JstylePersonalMediaDetailLiveCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    if(indexPath.row < self.dataArray.count){
        cell.model = self.dataArray[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110 * kScreenWidth / 375.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.dataArray.count) return;
    JstylePersonalMediaDetailModel *model = self.dataArray[indexPath.row];
    JstyleNewsVideoDetailViewController *playVideoVC = [JstyleNewsVideoDetailViewController new];
    playVideoVC.videoUrl = model.url_sd;
    playVideoVC.videoTitle = model.title;
    playVideoVC.vid = model.id;
    playVideoVC.videoType = model.videoType;
    [self.navigationController pushViewController:playVideoVC animated:YES];
}

/**获取iCity号列表*/
- (void)getJstylePersonalMediaHomeDataSource
{
    NSDictionary *parameters = @{@"platform_type":@"2",
                                 @"did":[NSString stringWithFormat:@"%@", self.did],
                                 @"type":@"3",
                                 @"page":[NSString stringWithFormat:@"%ld",(long)page]
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:MANAGER_HOMELIST_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] != 1) {
            [self.tableView.mj_footer endRefreshing];
            [self addPlaceholderView];
            return ;
        }
        
        [self.dataArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstylePersonalMediaDetailModel class] json:responseObject[@"data"]]];
        
        [self addPlaceholderView];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self addPlaceholderView];
        [self.tableView.mj_footer endRefreshing];
    }];
}


- (void)addPlaceholderView{
    [_placeholderView removeFromSuperview];
    _placeholderView = [[JstyleNewsPlaceholderView alloc] initWithFrame:[UIScreen mainScreen].bounds placeholderImage:[UIImage imageNamed:@"评论空白"] placeholderText:@"暂时没有直播哦~"];
    _placeholderView.y = _placeholderView.y - 50;
    
    if (!self.dataArray.count) {
        [self.placeholderView removeFromSuperview];
        [self.tableView addSubview:self.placeholderView];
    }else{
        [self.placeholderView removeFromSuperview];
    }
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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


