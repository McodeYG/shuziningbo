//
//  JstyleNewsCommentViewController.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/5.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsCommentViewController.h"
#import "JstyleNewsCommentViewCell.h"
#import "JstyleNewsCoverCommentViewController.h"
#import "JstyleNewsPlaceholderView.h"

@interface JstyleNewsCommentViewController ()<UITableViewDelegate, UITableViewDataSource,CommentViewCellDelegate>

@property (nonatomic, strong) JstyleNewsBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) JstyleNewsPlaceholderView *placeholderView;

@property (nonatomic, strong) JstyleNewsBaseBottomView *commentBar;
@property (nonatomic, strong) UITextField *commentTextField;
@property (nonatomic, strong) NSString *contentId;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIView *toolBarHoldView;

@end

static NSInteger page = 1;
@implementation JstyleNewsCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = kWhiteColor;
//    self.title = @"评论";
    
    [self addCommentToolBar];
    [self addTableView];
    [self addToolBarHoldView];
    [self addReshAction];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = YES;
    [self wr_setNavBarShadowImageHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNightModeBackColor] forBarMetrics:(UIBarMetricsDefault)];
    NSDictionary *titleColor = @{
                                 NSForegroundColorAttributeName:kNightModeTitleColor,
                                 NSFontAttributeName:[UIFont systemFontOfSize:18]
                                 };
    [self.navigationController.navigationBar setTitleTextAttributes:titleColor];
    
    if (self.dataArray.count) {
        page = 1;
        [self loadJstyleNewsVideoCommentData];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self wr_setNavBarShadowImageHidden:YES];
}

- (void)addReshAction
{
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf loadJstyleNewsVideoCommentData];
    }];
    
    self.tableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [weakSelf loadJstyleNewsVideoCommentData];
    }];
}

- (void)addTableView
{
    _tableView = [[JstyleNewsBaseTableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    _tableView.separatorColor = kSingleLineColor;
//    _tableView.backgroundColor = kWhiteColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.tableFooterView = [UIView new];
    
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsCommentViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsCommentViewCell"];
    
    [self.view insertSubview:_tableView belowSubview:_commentBar];
    _tableView.sd_layout
    .topEqualToView(self.view)
    .bottomSpaceToView(_commentBar, 0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view);
}

#pragma mark -- tableView的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.dataArray.count){
        static NSString *ID = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    static NSString *ID = @"JstyleNewsCommentViewCell";
    JstyleNewsCommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[JstyleNewsCommentViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    __weak typeof(self)weakSelf = self;
    cell.replyBlock = ^(NSString *userName, NSString *contentId) {
        weakSelf.commentTextField.placeholder = [NSString stringWithFormat:@"回复给%@:", userName];
        [weakSelf.commentTextField becomeFirstResponder];
        weakSelf.contentId = contentId;
    };
    cell.praiseBlock = ^(NSString *contentId, BOOL isSelected) {
        [weakSelf addJstyleNewsVideoPraiseWithRid:contentId indexPath:indexPath];
    };
    //
    
    
    if (indexPath.row < self.dataArray.count) {
        cell.model = self.dataArray[indexPath.row];
    }
    cell.delegate = self;
    cell.index = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - 展开按钮
-(void)cell:(JstyleNewsCommentViewCell *)cell unflodBtnAction:(UIButton *)button {
    
    if (cell.model.isShowBtn) {
        cell.model.isShowBtn = NO;
    }
    button.hidden = YES;
    
    [self.tableView reloadRowsAtIndexPaths:@[cell.index] withRowAnimation:(UITableViewRowAnimationFade)];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.dataArray.count) return 0;
    
    JstyleNewsCommentModel * model = self.dataArray[indexPath.row];
    NSString * comment = [NSString stringWithFormat:@"%@",model.content];
    
    CGFloat comH = [comment heightForFont:[UIFont systemFontOfSize:14] width:SCREEN_W-35-32];
    if (comH>70&&model.isShowBtn) {
        return 15+32+15+70+ 5+22+10;
    } else {
        return 15+32+15+comH+10;
    }
    
//    return [self.tableView cellHeightForIndexPath:indexPath model:self.dataArray[indexPath.row] keyPath:@"model" cellClass:[JstyleNewsCommentViewCell class] contentViewWidth:kScreenWidth];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.dataArray.count) return;
    JstyleNewsCommentModel *model = self.dataArray[indexPath.row];
    JstyleNewsCoverCommentViewController *jstyleNewsVideoCCVC = [JstyleNewsCoverCommentViewController new];
    jstyleNewsVideoCCVC.model = model;
    jstyleNewsVideoCCVC.vid = self.vid;
    jstyleNewsVideoCCVC.type = self.type;
    [self.navigationController pushViewController:jstyleNewsVideoCCVC animated:YES];
}

/**
 * 添加评论输入框
 */
- (void)addCommentToolBar
{
    _commentBar = [[JstyleNewsBaseBottomView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 50 - (IS_iPhoneX?15:0), kScreenWidth, 50)];
    [self.view addSubview:_commentBar];
    
    UIView *singleLine = [[UIView alloc] init];
    singleLine.backgroundColor = ISNightMode?kDarkThreeColor:JSColor(@"#C8C7CC");
    [_commentBar addSubview:singleLine];
    singleLine.sd_layout
    .leftEqualToView(_commentBar)
    .rightEqualToView(_commentBar)
    .topEqualToView(_commentBar)
    .heightIs(0.5);
    
    _sendButton = [[UIButton alloc] init];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _sendButton.tintColor = [UIColor whiteColor];
    _sendButton.backgroundColor = kPinkColor;
    _sendButton.titleLabel.font = JSFont(14);
    _sendButton.layer.cornerRadius = 15;
    _sendButton.layer.masksToBounds = YES;
    [_sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [_commentBar addSubview:_sendButton];
    _sendButton.sd_layout
    .rightSpaceToView(_commentBar, 15)
    .centerYEqualToView(_commentBar)
    .widthIs(70)
    .heightIs(30);
    _sendButton.lee_theme
    .LeeCustomConfig(ThemeMainBtnTitleOrBorderColor, ^(id item, id value) {
        [item setBackgroundColor:value];
    });
    
    _commentTextField = [[UITextField alloc] init];
    _commentTextField.tintColor = kDarkTwoColor;
    _commentTextField.lee_theme
    .LeeConfigTintColor(ThemeMainBtnTitleOrBorderColor);
    _commentTextField.returnKeyType = UIReturnKeyDefault;
    _commentTextField.keyboardAppearance = ISNightMode?UIKeyboardAppearanceDark:UIKeyboardAppearanceDefault;
    _commentTextField.font = [UIFont systemFontOfSize:14];
    _commentTextField.textColor = kDarkTwoColor;
    _commentTextField.placeholder = @"添加评论...";
    [_commentBar addSubview:_commentTextField];
    _commentTextField.sd_layout
    .leftSpaceToView(_commentBar, 15)
    .rightSpaceToView(_sendButton, 10)
    .topEqualToView(_commentBar)
    .heightIs(50);
    
    [self registKeyboardNotifications];
}

- (void)addToolBarHoldView{
    _toolBarHoldView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _toolBarHoldView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.0];

    [self.view insertSubview:_toolBarHoldView belowSubview:_commentBar];
    _toolBarHoldView.hidden = YES;
}

- (void)registKeyboardNotifications
{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)notification
{
    _toolBarHoldView.hidden = NO;
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [value CGRectValue];
    _commentBar.y = rect.origin.y - _commentBar.height;
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)notification
{
    _toolBarHoldView.hidden = YES;
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [value CGRectValue];
    _commentBar.y = rect.origin.y - _commentBar.height - (IS_iPhoneX?15:0);
}

- (void)sendButtonClicked:(UIButton *)sender
{
    if ([[JstyleToolManager sharedManager] isTourist]) {
        [[JstyleToolManager sharedManager] loginInViewController];
        return;
    }
    
    NSString *comment = [self.commentTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (comment == nil || [comment isEqualToString:@""]) {
        ZTShowAlertMessage(@"评论内容不能为空");
        return;
    }
    if (comment.length>2000) {
        ZTShowAlertMessage(@"字数限制最多2000字，请调整后再发。");
        return;
    }
    if ([NSString stringContainsEmoji:comment]) {
        ZTShowAlertMessage(@"昵称不能含有表情等特殊字符");
        return;
    }
    if (self.contentId) {
        [self addJstyleNewsVideoCommentWithPid:self.contentId];
    }else{
        [self addJstyleNewsVideoCommentData];
    }
    [_commentTextField resignFirstResponder];
    self.commentTextField.placeholder = @"添加评论...";
    _toolBarHoldView.hidden = YES;
    self.contentId = nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_commentTextField resignFirstResponder];
    self.commentTextField.placeholder = @"添加评论...";
    _toolBarHoldView.hidden = YES;
    self.contentId = nil;
}

/**获取评论列表数据*/
- (void)loadJstyleNewsVideoCommentData
{
    NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%ld",page],
                                 @"type":self.type,
                                 @"hid":self.vid,
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID]};
    [[JstyleNewsNetworkManager shareManager] GETURL:COMMENT_LIST_URL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] != 1) {
            if (self.dataArray.count==0) {
                self.title = @"暂无评论";
            }
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
        
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsCommentModel class] json:responseObject[@"data"][@"list"]]];
        if (self.dataArray.count!=0) {
            self.title = [NSString stringWithFormat:@"%@条评论",responseObject[@"data"][@"count"]];
        }
        
        
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

/**添加评论数据*/
- (void)addJstyleNewsVideoCommentData
{
    NSDictionary *parameters = @{@"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"type":self.type,
                                 @"hid":self.vid,
                                 @"content":self.commentTextField.text,
                                 @"pid":@""
                                 };
    [[JstyleNewsNetworkManager shareManager] POSTURL:ADD_COMMENT_URL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            ZTShowAlertMessage(@"发布成功");
            self.commentTextField.text = @"";
            page = 1;
            [self.dataArray removeAllObjects];
            [self loadJstyleNewsVideoCommentData];
        }
        
    } failure:^(NSError *error) {
        ZTShowAlertMessage(@"评论失败, 请稍后再试");
    }];
}

/**回复某条评论数据*/
- (void)addJstyleNewsVideoCommentWithPid:(NSString *)pid
{
    NSDictionary *parameters = @{@"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"type":self.type,
                                 @"hid":self.vid,
                                 @"content":self.commentTextField.text,
                                 @"pid":pid
                                 };
    [[JstyleNewsNetworkManager shareManager] POSTURL:ADD_COMMENT_URL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            ZTShowAlertMessage(@"回复成功");
            self.commentTextField.text = @"";
            
            page = 1;
            [self.dataArray removeAllObjects];
            [self loadJstyleNewsVideoCommentData];
        }
        
    } failure:^(NSError *error) {
        ZTShowAlertMessage(@"评论失败, 请稍后再试");
    }];
}

/**添加评论点赞*/
- (void)addJstyleNewsVideoPraiseWithRid:(NSString *)rid indexPath:(NSIndexPath *)indexPath
{
    NSDictionary *parameters = @{@"platform_type":@"2",
                                 @"rid":[NSString stringWithFormat:@"%@",rid],
                                 @"type":@"3",
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID]
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:ADD_PRAISE_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            JstyleNewsCommentModel *model = self.dataArray[indexPath.row];
            model.is_praise = responseObject[@"data"][@"praise_type"];
            model.praise_num = [NSString stringWithFormat:@"%ld",[model.praise_num integerValue] + ([model.is_praise integerValue] == 1 ? 1: - 1)];
            JstyleNewsCommentViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
            cell.thumbNumLabel.text = [NSString stringWithFormat:@"%@",model.praise_num];
            
            if ([model.is_praise integerValue] == 1) {
                [cell.thumbBtn setImage:JSImage(@"点赞-面") forState:(UIControlStateNormal)];
                [ThumbUpSpecialEffec addThumbUpSpecialEffecWithBigShineColor:kLightBlueColor smallShineColor:kLightBlueColor shineFillColor:kLightBlueColor button:cell.thumbBtn];
            }else{
                [cell.thumbBtn setImage:JSImage(@"点赞-线") forState:(UIControlStateNormal)];
            }
//            [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:(UITableViewRowAnimationNone)];
        }
    } failure:nil];
}

- (void)addPlaceholderView{
    [self.placeholderView removeFromSuperview];
    self.placeholderView = [[JstyleNewsPlaceholderView alloc] initWithFrame:[UIScreen mainScreen].bounds placeholderImage:[UIImage imageNamed:@"评论空白"] placeholderText:@"暂无评论，快来抢沙发哟~"];
    if (!self.dataArray.count && !self.dataArray.count) {
        [self.tableView addSubview:self.placeholderView];
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
-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
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

