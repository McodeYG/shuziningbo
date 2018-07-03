//
//  JstyleNewsMineTableHeaderView.m
//  JstyleNews
//
//  Created by 数字跃动 on 2017/10/24.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsMineTableHeaderView.h"
#import "UIView+JSDraggable.h"

@interface JstyleNewsMineTableHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *avatorButton;
@property (weak, nonatomic) IBOutlet UILabel *loginNameLabel;

@property (nonatomic, strong) UIView *countLabelsView;
@property (nonatomic, weak) UILabel *movementCountLabel;
@property (nonatomic, weak) UILabel *commentCountLabel;
@property (nonatomic, weak) UILabel *sevenDaysCountLabel;

@property (nonatomic, weak) UIImageView *collectionImageView;
@property (nonatomic, weak) UIImageView *commentImageView;
@property (nonatomic, weak) UIImageView *messageImageView;

@property (nonatomic, weak) UIImageView *nightImageView;
@property (nonatomic, weak) UILabel *nightTitleLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginNameLabelTopToBottomConstraint;

@end

@implementation JstyleNewsMineTableHeaderView

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
    
    self.backgroundImageView.image = [[UIImage imageNamed:@"背景渐变"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.layer.masksToBounds = YES;
    __weak typeof(self)weakSelf = self;
    self.backgroundImageView.lee_theme
    .LeeCustomConfig(ThemeMineHeaderBackgroundImage, ^(id item, id value) {
        UIImage *bgImage = [value resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
        [weakSelf.backgroundImageView setImage:bgImage];
        UIView *maskView = [[UIView alloc] initWithFrame:weakSelf.backgroundImageView.bounds];
        maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.02];
        if ([[LEETheme currentThemeTag] isEqualToString:ThemeName_White]) {
            [weakSelf.backgroundImageView addSubview:maskView];
            [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.offset(0);
                make.height.equalTo(weakSelf.backgroundImageView);
            }];
            weakSelf.loginNameLabel.textColor = kDarkTwoColor;
        } else {
            [maskView removeFromSuperview];
            weakSelf.loginNameLabel.textColor = kWhiteColor;
        }
    });
    self.avatorButton.layer.cornerRadius = 70 / 2.0;
    self.avatorButton.layer.masksToBounds = YES;
    [self.avatorButton addTarget:self action:@selector(avatorButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.avatorButton makeDraggable];
    
    [self setupCountLabelsView];
    [self setupMenuView];
    
    if ([[JstyleToolManager sharedManager] isTourist]) {
        self.countLabelsView.hidden = YES;
    } else {
        self.countLabelsView.hidden = NO;
    }
}

///数量View
- (void)setupCountLabelsView {
    
    NSMutableArray *viewsArray = [NSMutableArray arrayWithCapacity:3];
    
    UIView *countLabelsView = [[UIView alloc] init];
    self.countLabelsView = countLabelsView;
    [self addSubview:countLabelsView];
    [countLabelsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.loginNameLabel.mas_bottom).offset(10);
        make.height.offset(19+14);
    }];
    
    //动态
    UIView *movementView = [UIView new];
    [viewsArray addObject:movementView];
    movementView.backgroundColor = [UIColor clearColor];
    [countLabelsView addSubview:movementView];
    
    UILabel *movementCountLabel = [UILabel labelWithColor:kWhiteColor fontSize:11 text:@"100"];
    self.movementCountLabel = movementCountLabel;;
    [movementView addSubview:movementCountLabel];
    [movementCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(0);
    }];
    
    UILabel *movementLabel = [UILabel labelWithColor:kWhiteColor fontSize:11 text:@"动态"];
    [movementView addSubview:movementLabel];
    [movementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.offset(-5);
    }];
    
    //评论
    UIView *commentView = [UIView new];
    [viewsArray addObject:commentView];
    commentView.backgroundColor = [UIColor clearColor];
    [countLabelsView addSubview:commentView];
    
    UILabel *commentCountLabel = [UILabel labelWithColor:kWhiteColor fontSize:11 text:@"200"];
    self.commentCountLabel = commentCountLabel;
    [commentView addSubview:commentCountLabel];
    [commentCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(0);
    }];
    
    UILabel *commentLabel = [UILabel labelWithColor:kWhiteColor fontSize:11 text:@"评论"];
    [commentView addSubview:commentLabel];
    [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.offset(-5);
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
    
    UILabel *sevenDaysCountLabel = [UILabel labelWithColor:kWhiteColor fontSize:11 text:@"200"];
    self.sevenDaysCountLabel = sevenDaysCountLabel;
    [sevenDaysView addSubview:sevenDaysCountLabel];
    [sevenDaysCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(0);
    }];
    
    UILabel *sevenDaysLabel = [UILabel labelWithColor:kWhiteColor fontSize:11 text:@"7天访客"];
    [sevenDaysView addSubview:sevenDaysLabel];
    [sevenDaysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.offset(-5);
    }];
    
    [viewsArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [viewsArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(33);
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
        [self.avatorButton setImage:[UIImage imageNamed:@"登录头像"] forState:UIControlStateNormal];
        self.loginNameLabel.text = @"点击登录";
        self.loginNameLabelTopToBottomConstraint.constant = -33;
        
    } else {
        
        if ([[[JstyleToolManager sharedManager] getUniqueId] isEqualToString:@""]) {
            self.countLabelsView.hidden = YES;
            self.loginNameLabelTopToBottomConstraint.constant = -33;
        } else {
            self.countLabelsView.hidden = NO;
            self.loginNameLabelTopToBottomConstraint.constant = -63;
        }
        
        [self.avatorButton setImageWithURL:[NSURL URLWithString:userInfoModel.poster] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"登录头像"]];
        self.loginNameLabel.text = userInfoModel.nick_name;
    }
    
    self.movementCountLabel.text = userInfoModel.content_num;
    self.commentCountLabel.text = userInfoModel.comment_num;
    self.sevenDaysCountLabel.text = userInfoModel.browse_num;
    
}

- (void)avatorButtonClick {
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
