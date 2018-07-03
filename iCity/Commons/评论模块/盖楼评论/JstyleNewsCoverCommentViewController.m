//
//  JstyleNewsCommentViewController.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/5.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsCoverCommentViewController.h"

@interface JstyleNewsCoverCommentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) JstyleNewsBaseBottomView *commentBar;
@property (nonatomic, strong) UITextField *commentTextField;
@property (nonatomic, copy) NSString *contentId;
@property (nonatomic, copy) NSString *replyAt;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIView *toolBarHoldView;

@end

static NSInteger page = 1;
@implementation JstyleNewsCoverCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
//    self.title = @"回复";
    [self addCommentToolBar];
    [self addTableView];
    [self addToolBarHoldView];
    [self addReshAction];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

     [self.navigationController setNavigationBarHidden:NO animated:YES];
    NSDictionary *titleColor = @{
                                 NSForegroundColorAttributeName:kNightModeTitleColor,
                                 NSFontAttributeName:[UIFont systemFontOfSize:18]
                                 };
    [self.navigationController.navigationBar setTitleTextAttributes:titleColor];
    
    page = 1;
    [self.dataArray removeAllObjects];
    [self loadJstyleNewsCoverCommentData];
}

- (void)addReshAction
{
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf.dataArray removeAllObjects];
        [weakSelf loadJstyleNewsCoverCommentData];
    }];
    
    self.tableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [weakSelf loadJstyleNewsCoverCommentData];
    }];
}

- (void)addTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = ISNightMode?kDarkThreeColor:kSingleLineColor;
    _tableView.backgroundColor = ISNightMode?kNightModeBackColor:JSColor(@"#F4F4F4");
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.tableFooterView = [UIView new];
    
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsCommentViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsCommentViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsCoverCommentViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsCoverCommentViewCell"];
    
    [self.view insertSubview:_tableView belowSubview:_commentBar];
    _tableView.sd_layout
    .topEqualToView(self.view)
    .bottomSpaceToView(_commentBar, 0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view);
}

#pragma mark -- tableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return 1;
    return self.dataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) return nil;
    return [self addHeaderViewWithTitle:@"评论回复"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return 0.01;
    return 54;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *ID = @"JstyleNewsCommentViewCell";
        JstyleNewsCommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[JstyleNewsCommentViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        
        __weak typeof(self)weakSelf = self;
        cell.replyBtn.userInteractionEnabled = YES;
        cell.replyBlock = ^(NSString *userName, NSString *contentId) {
            weakSelf.commentTextField.placeholder = [NSString stringWithFormat:@"回复给%@:", userName];
            [weakSelf.commentTextField becomeFirstResponder];
            weakSelf.contentId = contentId;
        };
        
        cell.praiseBlock = ^(NSString *contentId, BOOL isSelected) {
            [weakSelf addJstyleNewsVideoPraiseWithRid:contentId indexPath:indexPath];
        };
        
        if (self.model) {
            cell.model = self.model;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *ID = @"JstyleNewsCoverCommentViewCell";
        JstyleNewsCoverCommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[JstyleNewsCoverCommentViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        
        __weak typeof(self)weakSelf = self;
        cell.praiseBlock = ^(NSString *contentId) {
            [weakSelf addJstyleNewsVideoPraiseWithRid:contentId indexPath:indexPath];
        };
        
        if (indexPath.row < self.dataArray.count) {
            cell.model = self.dataArray[indexPath.row];
        }
        cell.backgroundColor = [UIColor colorFromHexString:@"#F4F4F4"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [self.tableView cellHeightForIndexPath:indexPath model:self.model keyPath:@"model" cellClass:[JstyleNewsCommentViewCell class] contentViewWidth:kScreenWidth];
    }else{
        return [self.tableView cellHeightForIndexPath:indexPath model:self.dataArray[indexPath.row] keyPath:@"model" cellClass:[JstyleNewsCoverCommentViewCell class] contentViewWidth:kScreenWidth];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) return;
    JstyleNewsCommentModel *model = self.dataArray[indexPath.row];
    self.commentTextField.placeholder = [NSString stringWithFormat:@"回复给%@:", model.nick_name];
    [self.commentTextField becomeFirstResponder];
    self.contentId = model.id;
    self.replyAt = [NSString stringWithFormat:@"回复给@%@:", model.nick_name];
}

/**
 * 添加评论输入框
 */
- (void)addCommentToolBar
{
    _commentBar = [[JstyleNewsBaseBottomView alloc] initWithFrame:CGRectMake(0, kScreenHeight - YG_StatusAndNavightion_H-50 - YG_SafeBottom_H/2, kScreenWidth, 50)];
    [self.view addSubview:_commentBar];
    
    UIView *singleLine = [[UIView alloc] init];
    singleLine.backgroundColor = JSColor(@"#C8C7CC");
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
    _sendButton.lee_theme
    .LeeCustomConfig(ThemeMainBtnTitleOrBorderColor, ^(id item, id value) {
        [item layer].backgroundColor = [value CGColor];
    });
    [_commentBar addSubview:_sendButton];
    _sendButton.sd_layout
    .rightSpaceToView(_commentBar, 15)
    .centerYEqualToView(_commentBar)
    .widthIs(70)
    .heightIs(30);
    
    _commentTextField = [[UITextField alloc] init];
    _commentTextField.tintColor = kNormalRedColor;
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
    _commentBar.y = rect.origin.y - _commentBar.height-YG_StatusAndNavightion_H;
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)notification
{
    _toolBarHoldView.hidden = YES;
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [value CGRectValue];
    _commentBar.y = rect.origin.y - _commentBar.height - (IS_iPhoneX?15:0)-YG_StatusAndNavightion_H;
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
    if (self.contentId) {
        [self addJstyleNewsVideoCommentWithPid:self.contentId];
    }else{
        [self addJstyleNewsVideoCommentData];
    }
    [_commentTextField resignFirstResponder];
    self.commentTextField.placeholder = @"添加评论...";
    _toolBarHoldView.hidden = YES;
    self.contentId = nil;
    self.replyAt = nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_commentTextField resignFirstResponder];
    self.commentTextField.placeholder = @"添加评论...";
    _toolBarHoldView.hidden = YES;
    self.contentId = nil;
    self.replyAt = nil;
}

#pragma mark - 获取数据
- (void)loadJstyleNewsCoverCommentData
{
    NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%ld",page],
                                 @"type":[NSString stringWithFormat:@"%@",self.type],
                                 @"hid":self.vid,
                                 @"fid":self.model.id,
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID]
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:COVER_COMMENT_URL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] != 1) {
            self.title = @"暂无回复";
            if (self.dataArray.count) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }
            return;
        }
        
        [self.dataArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsCommentModel class] json:responseObject[@"data"][@"list"]]];
        if (self.dataArray.count>0) {
            self.title = [NSString stringWithFormat:@"%ld条回复", self.dataArray.count];
        }
        self.model.reply_num = [NSString stringWithFormat:@"%ld", self.dataArray.count];
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

/**添加评论数据*/
- (void)addJstyleNewsVideoCommentData
{
    NSDictionary *parameters = @{@"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"type":[NSString stringWithFormat:@"%@",self.type],
                                 @"hid":self.vid,
                                 @"content":self.commentTextField.text,
                                 @"pid":self.model.id
                                 };
    [[JstyleNewsNetworkManager shareManager] POSTURL:ADD_COMMENT_URL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            ZTShowAlertMessage(@"发布成功");
            self.commentTextField.text = @"";
            self.replyAt = nil;
            
            page = 1;
            [self.dataArray removeAllObjects];
            [self loadJstyleNewsCoverCommentData];
        }
        
    } failure:^(NSError *error) {
        ZTShowAlertMessage(@"评论失败, 请稍后再试");
    }];
}

/**回复某条评论数据*/
- (void)addJstyleNewsVideoCommentWithPid:(NSString *)pid
{
    NSString *comment;
    if (self.replyAt) {
        comment = [self.replyAt stringByAppendingString:self.commentTextField.text];
    }else{
        comment = self.commentTextField.text;
    }
    NSDictionary *parameters = @{@"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"type":[NSString stringWithFormat:@"%@",self.type],
                                 @"hid":self.vid,
                                 @"content":comment,
                                 @"pid":pid
                                 };
    [[JstyleNewsNetworkManager shareManager] POSTURL:ADD_COMMENT_URL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            ZTShowAlertMessage(@"回复成功");
            self.commentTextField.text = nil;
            self.replyAt = nil;
            page = 1;
            [self.dataArray removeAllObjects];
            [self loadJstyleNewsCoverCommentData];
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
            if (indexPath.section == 0) {
                self.model.is_praise = responseObject[@"data"][@"praise_type"];
                self.model.praise_num = [NSString stringWithFormat:@"%ld",[self.model.praise_num integerValue] + ([self.model.is_praise integerValue] == 1 ? 1: - 1)];
                JstyleNewsCommentViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                cell.thumbNumLabel.text = [NSString stringWithFormat:@"%@",self.model.praise_num];
                
                if ([self.model.is_praise integerValue] == 1) {
                    [cell.thumbBtn setImage:JSImage(@"点赞-面") forState:(UIControlStateNormal)];
                    [ThumbUpSpecialEffec addThumbUpSpecialEffecWithBigShineColor:kLightBlueColor smallShineColor:kLightBlueColor shineFillColor:kLightBlueColor button:cell.thumbBtn];
                }else{
                    [cell.thumbBtn setImage:JSImage(@"点赞-线") forState:(UIControlStateNormal)];
                }
            }else{
                JstyleNewsCommentModel *model = self.dataArray[indexPath.row];
                model.is_praise = responseObject[@"data"][@"praise_type"];
                model.praise_num = [NSString stringWithFormat:@"%ld",[model.praise_num integerValue] + ([model.is_praise integerValue] == 1 ? 1: - 1)];
                JstyleNewsCoverCommentViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                cell.thumbNumLabel.text = [NSString stringWithFormat:@"%@",model.praise_num];
                
                if ([model.is_praise integerValue] == 1) {
                    [cell.thumbBtn setImage:JSImage(@"点赞-面") forState:(UIControlStateNormal)];
                    [ThumbUpSpecialEffec addThumbUpSpecialEffecWithBigShineColor:kLightBlueColor smallShineColor:kLightBlueColor shineFillColor:kLightBlueColor button:cell.thumbBtn];
                }else{
                    [cell.thumbBtn setImage:JSImage(@"点赞-线") forState:(UIControlStateNormal)];
                }
            }
//            [self.tableView reloadRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
        }
    } failure:nil];
}

- (UIView *)addHeaderViewWithTitle:(NSString *)title
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = ISNightMode?kNightModeBackColor:JSColor(@"#F4F4F4");
    
    JstyleNewsBaseTitleLabel *nameLabel = [[JstyleNewsBaseTitleLabel alloc] init];
    nameLabel.font = JSFont(12);
    nameLabel.text = title;
    [headerView addSubview:nameLabel];
    nameLabel.sd_layout
    .centerYEqualToView(headerView)
    .centerXEqualToView(headerView)
    .heightIs(12);
    [nameLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    JstyleNewsBaseLineView *singleLine1 = [[JstyleNewsBaseLineView alloc] init];
    [headerView addSubview:singleLine1];
    singleLine1.sd_layout
    .centerYEqualToView(headerView)
    .rightSpaceToView(nameLabel, 20)
    .widthIs(50)
    .heightIs(0.5);
    
    JstyleNewsBaseLineView *singleLine2 = [[JstyleNewsBaseLineView alloc] init];
    [headerView addSubview:singleLine2];
    singleLine2.sd_layout
    .centerYEqualToView(headerView)
    .leftSpaceToView(nameLabel, 20)
    .widthIs(50)
    .heightIs(0.5);
    
    return headerView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
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


