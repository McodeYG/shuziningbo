//
//  JstyleNewsMineEffectTableHeaderView.m
//  JstyleNews
//
//  Created by 数字跃动 on 2018/1/16.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsMineEffectTableHeaderView.h"
#import "UIView+JSDraggable.h"

@interface JstyleNewsMineEffectTableHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundPosterImageView;
@property (weak, nonatomic) IBOutlet UIButton *posterBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) UIView *countLabelsView;
@property (nonatomic, weak) UILabel *movementCountLabel;
@property (nonatomic, weak) UILabel *commentCountLabel;
@property (nonatomic, weak) UILabel *sevenDaysCountLabel;
@property (nonatomic, weak) UIImageView *nightImageView;
@property (nonatomic, weak) UILabel *nightTitleLabel;

@property (nonatomic, weak) UIImageView *collectionImageView;
@property (nonatomic, weak) UIImageView *commentImageView;
@property (nonatomic, weak) UIImageView *messageImageView;

@end

@implementation JstyleNewsMineEffectTableHeaderView

-(void)awakeFromNib {
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
    
    self.posterBtn.layer.cornerRadius = self.posterBtn.height / 2.0;
    self.posterBtn.layer.masksToBounds = YES;
    self.posterBtn.layer.borderWidth = 1;
    self.posterBtn.layer.borderColor = kWhiteColor.CGColor;
    
    self.titleLabel.layer.cornerRadius = self.titleLabel.height / 2.0;
    self.titleLabel.layer.masksToBounds = YES;
    self.titleLabel.text = @"荣誉内测用户";
    
    [self.posterBtn addTarget:self action:@selector(posterBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.posterBtn makeDraggable];
    
    [self.backgroundPosterImageView setImage:[UIImage imageNamed:@"登录头像"]];
    
    [self setupMenuView];
    
    [self setupCountLabelsView];
    
}

///数量View
- (void)setupCountLabelsView {
    
    NSMutableArray *viewsArray = [NSMutableArray arrayWithCapacity:3];
    
    UIView *countLabelsView = [[UIView alloc] init];
    self.countLabelsView = countLabelsView;
    [self addSubview:countLabelsView];
    [countLabelsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.offset(28);
    }];
    
    //动态
    UIView *movementView = [UIView new];
    [viewsArray addObject:movementView];
    movementView.backgroundColor = [UIColor clearColor];
    [countLabelsView addSubview:movementView];

    UILabel *movementLabel = [UILabel labelWithColor:kWhiteColor fontSize:11 text:@"动态"];
    [movementView addSubview:movementLabel];
    [movementLabel sizeToFit];
    [movementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(10);
        make.centerY.offset(0);
    }];
    
    UILabel *movementCountLabel = [UILabel labelWithColor:kWhiteColor fontSize:11 text:@"300" alignment:NSTextAlignmentRight];
    self.movementCountLabel = movementCountLabel;
    [movementView addSubview:movementCountLabel];
    [movementCountLabel sizeToFit];
    [movementCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(movementLabel.mas_left).offset(-6);
        make.centerY.offset(0);
    }];
    
    
    //评论
    UIView *commentView = [UIView new];
    [viewsArray addObject:commentView];
    commentView.backgroundColor = [UIColor clearColor];
    [countLabelsView addSubview:commentView];
    
    UILabel *commentLabel = [UILabel labelWithColor:kWhiteColor fontSize:11 text:@"评论"];
    [commentView addSubview:commentLabel];
    [commentLabel sizeToFit];
    [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(10);
        make.centerY.offset(0);
    }];
    
    UILabel *commentCountLabel = [UILabel labelWithColor:kWhiteColor fontSize:11 text:@"200"];
    self.commentCountLabel = commentCountLabel;
    [commentView addSubview:commentCountLabel];
    [commentCountLabel sizeToFit];
    [commentCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(commentLabel.mas_left).offset(-6);
        make.centerY.offset(0);
    }];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = kWhiteColor;
    line2.alpha = 0.33;
    [commentView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(0);
        make.width.offset(1);
        make.height.offset(9);
    }];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = kWhiteColor;
    line1.alpha = 0.33;
    [commentView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.offset(0);
        make.width.offset(1);
        make.height.offset(9);
    }];
    
    //7天访客
    UIView *sevenDaysView = [UIView new];
    [viewsArray addObject:sevenDaysView];
    sevenDaysView.backgroundColor = [UIColor clearColor];
    [countLabelsView addSubview:sevenDaysView];
    
    UILabel *sevenDaysLabel = [UILabel labelWithColor:kWhiteColor fontSize:11 text:@"7天访客"];
    [sevenDaysView addSubview:sevenDaysLabel];
    [sevenDaysLabel sizeToFit];
    [sevenDaysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(10);
        make.centerY.offset(0);
    }];
    
    UILabel *sevenDaysCountLabel = [UILabel labelWithColor:kWhiteColor fontSize:11 text:@"200"];
    self.sevenDaysCountLabel = sevenDaysCountLabel;
    [sevenDaysView addSubview:sevenDaysCountLabel];
    [sevenDaysCountLabel sizeToFit];
    [sevenDaysCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sevenDaysLabel.mas_left).offset(-6);
        make.centerY.offset(0);
    }];
    
    
    [viewsArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [viewsArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(28);
        make.bottom.offset(0);
    }];
}

// 收藏 评论 消息
- (void)setupMenuView {
    
    UIView *collectionView = [self creatMenuViewImageName:(ISNightMode?@"收藏-白色-夜间":@"收藏-白色") title:@"收藏"];
    [self addSubview:collectionView];
    UITapGestureRecognizer *collectionTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collectionTap)];
    [collectionView addGestureRecognizer:collectionTap];
    
    UIView *commentView = [self creatMenuViewImageName:(ISNightMode?@"评论-白色-夜间":@"评论-白色") title:@"评论"];
    [self addSubview:commentView];
    UITapGestureRecognizer *commentTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTap)];
    [commentView addGestureRecognizer:commentTap];
    
    UIView *messageView = [self creatMenuViewImageName:(ISNightMode?@"消息-白色-夜间":@"消息-白色") title:@"消息"];
    [self addSubview:messageView];
    UITapGestureRecognizer *messageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageTap)];
    [messageView addGestureRecognizer:messageTap];
    
    UIView *nightView = [self creatMenuViewImageName:(!ISNightMode?@"夜间-白色":@"我的菜单-日间") title:(!ISNightMode?@"夜间":@"日间")];
    [self addSubview:nightView];
    UITapGestureRecognizer *nightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nightTap)];
    [nightView addGestureRecognizer:nightTap];
    
    NSArray *viewsArray = @[collectionView, commentView, messageView, nightView];
    [viewsArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [viewsArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.height.offset(66);
    }];
    
}

- (UIView *)creatMenuViewImageName:(NSString *)imageName title:(NSString *)title {
    
    UIView *view = [UIView new];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.userInteractionEnabled = YES;
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(16);
    }];
    
    JstyleNewsBaseTitleLabel *titleLabel = [JstyleNewsBaseTitleLabel new];
    titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:12];
    titleLabel.text = title;
    titleLabel.userInteractionEnabled = YES;
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.offset(-8);
    }];
    
    if ([title isEqualToString:@"收藏"]) {
        self.collectionImageView = imageView;
    }
    
    if ([title isEqualToString:@"评论"]) {
        self.commentImageView = imageView;
    }
    
    if ([title isEqualToString:@"消息"]) {
        self.messageImageView = imageView;
    }
    
    if ([title isEqualToString:@"夜间"] || [title isEqualToString:@"日间"]) {
        self.nightImageView = imageView;
        self.nightTitleLabel = titleLabel;
    }
    
    return view;
}

- (void)setUserInfoModel:(JstyleNewsMineLoginUserInfoModel *)userInfoModel {
    _userInfoModel = userInfoModel;
    
    if ([[JstyleToolManager sharedManager] isTourist]) {
        
        self.countLabelsView.hidden = YES;
        [self.posterBtn setImage:[UIImage imageNamed:@"登录头像"] forState:UIControlStateNormal];
        self.userNameLabel.text = @"点击登录";
        
    } else {
        
        if ([[[JstyleToolManager sharedManager] getUniqueId] isEqualToString:@""]) {
            self.countLabelsView.hidden = YES;
        } else {
            self.countLabelsView.hidden = NO;
        }
        
        [self.posterBtn setImageWithURL:[NSURL URLWithString:userInfoModel.poster] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"登录头像"]];
        [self.backgroundPosterImageView setImageWithURL:[NSURL URLWithString:userInfoModel.poster]  placeholder:[UIImage imageNamed:@"登录头像"]];
        self.userNameLabel.text = userInfoModel.nick_name;
    }
    
    
    self.movementCountLabel.text = (userInfoModel == nil || userInfoModel.content_num == nil ? @"0" : userInfoModel.content_num);
    self.commentCountLabel.text = (userInfoModel == nil || userInfoModel.comment_num == nil ? @"0" : userInfoModel.comment_num);
    self.sevenDaysCountLabel.text = (userInfoModel == nil || userInfoModel.browse_num == nil ? @"0" : userInfoModel.browse_num);
}

- (void)posterBtnClick {
    if (self.loginBlock) {
        self.loginBlock();
    }
}

- (void)collectionTap {
    if (self.headerMenuCollectionBlock) {
        self.headerMenuCollectionBlock();
    }
}

- (void)commentTap {
    if (self.headerMenuCommentBlock) {
        self.headerMenuCommentBlock();
    }
}

- (void)messageTap {
    if (self.headerMenuMessageBlock) {
        self.headerMenuMessageBlock();
    }
}

- (void)nightTap {
    if (self.headerMenuNightBlock) {
        self.headerMenuNightBlock(self.nightImageView,self.nightTitleLabel,self.collectionImageView,self.commentImageView,self.messageImageView);
    }
}

@end
