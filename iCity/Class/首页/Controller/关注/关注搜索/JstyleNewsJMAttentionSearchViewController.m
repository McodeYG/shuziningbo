//
//  JstyleNewsJMAttentionSearchViewController.m
//  JstyleNews
//
//  Created by 王磊 on 2018/4/2.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsJMAttentionSearchViewController.h"
#import "JstyleNewsJMAttentionSearchCell.h"
#import "JstyleNewsJMAttentionSearchModel.h"
#import "JstyleNewsPlaceholderView.h"
#import "JstyleNewsJMNumDetailsViewController.h"

@interface JstyleNewsSearchBar : UISearchBar

@end

@implementation JstyleNewsSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.tintColor = kDarkNineColor;
    self.barStyle = UIBarStyleDefault;
    self.placeholder = @"搜索感兴趣的iCity号";
    for (UIView *view in self.subviews.lastObject.subviews) {
        if([view isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
            UITextField *textfield = (UITextField *)view;
            textfield.backgroundColor = JSColor(@"#F3F3F3");
            textfield.attributedText = [[NSAttributedString alloc] initWithString:@"" attributes:@{
                                                                                                   NSForegroundColorAttributeName:kDarkNineColor,
                                                                                                   NSFontAttributeName:[UIFont fontWithName:@"PingFang SC" size:13]
                                                                                                   }];
            [textfield setFont:[UIFont fontWithName:@"PingFang SC" size:13]];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UITextField *textfield = [self valueForKey:@"searchBarTextField"];
    if (textfield) {
        textfield.layer.cornerRadius = 32.0/2.0;
        textfield.layer.masksToBounds = YES;
        textfield.frame = CGRectMake(textfield.x, textfield.y, textfield.width, 32);
        
    }
}

@end

@interface JstyleNewsJMAttentionSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    NSInteger page;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) JstyleNewsSearchBar *searchBar;

@property (nonatomic, strong) JstyleNewsPlaceholderView *placeholderView;

@end

static NSString *JstyleNewsJMAttentionSearchCellID = @"JstyleNewsJMAttentionSearchCellID";


@implementation JstyleNewsJMAttentionSearchViewController

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = kWhiteColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.estimatedRowHeight = 68.0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsJMAttentionSearchCell" bundle:nil] forCellReuseIdentifier:JstyleNewsJMAttentionSearchCellID];
        
        __weak typeof(self)weakSelf = self;
        _tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
            page = 1;
            [weakSelf.dataArray removeAllObjects];
            [weakSelf loadData];
        }];
        
        _tableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            page ++;
            [weakSelf loadData];
        }];
    }
    return _tableView;
}

- (JstyleNewsSearchBar *)searchBar {
    if (_searchBar == nil) {
        _searchBar = [[JstyleNewsSearchBar alloc] initWithFrame:CGRectMake(15, 15, kScreenWidth * (300.0/375.0), 32)];
        _searchBar.delegate = self;
        _searchBar.text = self.keyword;
    }
    return _searchBar;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    page = 1;
    [self loadData];
    [self.view addSubview:self.tableView];
    
    [self setupNavigationBar];
}

- (void)setupNavigationBar {
    
    [self wr_setNavBarShadowImageHidden:YES];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBar];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消  " style:UIBarButtonItemStylePlain target:self action:@selector(cancleBtnClick)];
    self.navigationItem.rightBarButtonItem.tintColor = kDarkNineColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self wr_setNavBarShadowImageHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self wr_setNavBarShadowImageHidden:NO];
}

- (void)cancleBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JstyleNewsJMAttentionSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:JstyleNewsJMAttentionSearchCellID forIndexPath:indexPath];
    
    if (indexPath.row < self.dataArray.count) {
        JstyleNewsJMAttentionSearchModel *model = self.dataArray[indexPath.row];
        
        cell.model = model;
        __weak typeof(self)weakSelf = self;
        cell.attentionBlock = ^{
            [weakSelf addJstyleNewsJmNumsFocusOnWithDid:model.did indexPath:indexPath];
        };
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataArray.count) return;
    JstyleNewsJMAttentionSearchModel *model = self.dataArray[indexPath.row];
    JstyleNewsJMNumDetailsViewController *jstyleNewsJmNumsDVC = [JstyleNewsJMNumDetailsViewController new];
    jstyleNewsJmNumsDVC.did = model.did;
    [self.navigationController pushViewController:jstyleNewsJmNumsDVC animated:YES];
}

- (void)loadData {
    
    NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%ld",page],
                                 @"key":self.keyword == nil ? @"" : self.keyword,
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID],
                                 @"type":@"5"
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:SEARCH_RESULT_URL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] != 1) {
            if (self.dataArray.count) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }
            [self addPlaceholderView];
            return;
        }
        
        [self.dataArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsJMAttentionSearchModel class] json:responseObject[@"data"][@"authorList"]]];
        
        [self addPlaceholderView];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self addPlaceholderView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

///关注iCity号
- (void)addJstyleNewsJmNumsFocusOnWithDid:(NSString *)did indexPath:(NSIndexPath *)indexPath {
    
    if ([[JstyleToolManager sharedManager] isTourist]) {
        [[JstyleToolManager sharedManager] loginInViewController];
        return;
    }
    
    NSDictionary *parameters = @{@"platform_type":@"2",
                                 @"did":did,
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:MANAGER_SUBSCRIPTION_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            NSString *followType = responseObject[@"data"][@"follow_type"];
            JstyleNewsJMAttentionSearchModel *model = self.dataArray[indexPath.row];
            model.isFollow = followType;
            [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)addPlaceholderView{
    [_placeholderView removeFromSuperview];
    _placeholderView = [[JstyleNewsPlaceholderView alloc] initWithFrame:[UIScreen mainScreen].bounds placeholderImage:[UIImage imageNamed:@"文章空白"] placeholderText:@"暂时没有搜索到iCity号哦~"];
    
    if (!self.dataArray.count) {
        [self.placeholderView removeFromSuperview];
        [self.tableView addSubview:self.placeholderView];
    }else{
        [self.placeholderView removeFromSuperview];
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.keyword = searchText;
    [self.dataArray removeAllObjects];
    page = 1;
    [self loadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.keyword = searchBar.text;
    [self.dataArray removeAllObjects];
    page = 1;
    [self loadData];
    [self.searchBar resignFirstResponder];
}

@end
