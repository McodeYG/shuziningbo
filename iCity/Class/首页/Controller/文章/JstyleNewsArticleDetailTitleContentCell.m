//
//  JstyleNewsArticleDetailTitleContentCell.m
//  JstyleNews
//
//  Created by 数字跃动 on 2017/12/29.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsArticleDetailTitleContentCell.h"

@interface JstyleNewsArticleDetailTitleContentCell()

@property (weak, nonatomic) IBOutlet JstyleNewsBaseTitleLabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *originalLabel;
@property (weak, nonatomic) IBOutlet UILabel *ctimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cnameLabel;


@end

@implementation JstyleNewsArticleDetailTitleContentCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
    [self setupUI];
}

- (void)setupUI {
    
    self.posterImageView.layer.cornerRadius = 35 / 2.0;
    self.posterImageView.layer.masksToBounds = YES;
    self.posterImageView.layer.borderWidth = 1;
    self.posterImageView.layer.borderColor = JSColor(@"#E7E4E4").CGColor;
    self.posterImageView.userInteractionEnabled = YES;
    
    [self.subscribeButton addTarget:self action:@selector(subscribeBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tapPerson = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPersonAction)];
    UITapGestureRecognizer *tapPerson2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPersonAction)];
    [self.personNameLabel addGestureRecognizer:tapPerson];
    [self.posterImageView addGestureRecognizer:tapPerson2];
    
    self.titleLabel.sd_layout
    .leftSpaceToView(self.contentView, 30)
    .rightSpaceToView(self.contentView, 30)
    .topSpaceToView(self.contentView, 22)
    .autoHeightRatio(0);
    

    
    self.posterImageView.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.titleLabel, 25)
    .widthIs(35)
    .heightIs(35);
    
    self.subscribeButton.sd_layout
    .rightSpaceToView(self.contentView, 15)
    .centerYEqualToView(self.posterImageView)
    .widthIs(70)
    .heightIs(30);
    
    self.personNameLabel.sd_layout
    .leftSpaceToView(self.posterImageView, 5)
    .rightSpaceToView(self.subscribeButton, 5)
    .centerYEqualToView(self.posterImageView)
    .heightIs(15);
    //时间
    self.ctimeLabel.sd_layout
    .topSpaceToView(self.personNameLabel, 30)
    .centerXEqualToView(self.contentView)
    .heightIs(12);
    [self.ctimeLabel setSingleLineAutoResizeWithMaxWidth:250];
    //媒体号名字
    self.originalLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.ctimeLabel, 10)
    .centerYEqualToView(self.ctimeLabel)
    .heightIs(12);
    
    self.cnameLabel.sd_layout
    .leftSpaceToView(self.ctimeLabel, 10)
    .rightSpaceToView(self.contentView, 15)
    .centerYEqualToView(self.ctimeLabel)
    .heightIs(12);
}

- (void)tapPersonAction {
    if ([[JstyleToolManager sharedManager] getCurrentNetStatus] == NotReachable) {
        ZTShowAlertMessage(@"当前无网络,请检查网络");
        return;
    }
    if (self.tapPersonBlock) {
        self.tapPersonBlock(self.model.author_did);
    }
}

- (void)setModel:(JstyleNewsArticleDetailModel *)model {
    _model = model;
    
    self.titleLabel.text = model.title;
    [self.posterImageView setImageWithURL:[NSURL URLWithString:model.author_img] placeholder:[UIImage imageNamed:@"登录头像"]];
    self.personNameLabel.text = model.author_name;
    self.subscribeButton.selected = (model.isShowAuthor.integerValue == 1 && model.isShowAuthor.integerValue != 0 ? NO : YES);
    self.originalLabel.text = model.TOrFOriginal;
    
    NSString *ctimeString = [NSString stringWithFormat:@"•   %@   •" ,(model == nil ? @"" : model.ctime)];
    self.ctimeLabel.text = ([model.ctime isEqualToString:@""] ? @"" : ctimeString);
    self.cnameLabel.text = model.cname;
    
    if ([model.isShowAuthor integerValue] == 1) {
        self.subscribeButton.selected = YES;
        self.posterImageView.hidden = NO;
        self.personNameLabel.hidden = NO;
        self.subscribeButton.hidden = NO;
    } else if ([model.isShowAuthor integerValue] == 2) {
        self.subscribeButton.selected = NO;
        self.posterImageView.hidden = NO;
        self.personNameLabel.hidden = NO;
        self.subscribeButton.hidden = NO;
    } else if ([model.isShowAuthor integerValue] == 0) {
        self.posterImageView.hidden = YES;
        self.personNameLabel.hidden = YES;
        self.subscribeButton.hidden = YES;
    }

    if ([model.isShowAuthor integerValue] == 0) {
        self.ctimeLabel.sd_layout
        .topSpaceToView(self.titleLabel, 30)
        .centerXEqualToView(self.contentView)
        .heightIs(12);
    }else{
        self.ctimeLabel.sd_layout
        .topSpaceToView(self.personNameLabel, 30)
        .centerXEqualToView(self.contentView)
        .heightIs(12);
    }
    
    [self setupAutoHeightWithBottomView:self.ctimeLabel bottomMargin:20];
}

- (void)subscribeBtnDidClicked:(UIButton *)sender {
    __weak typeof(self)weakSelf = self;
    if (self.subscribeBlock) {
        self.subscribeBlock(weakSelf.model.author_did);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;

    self.subscribeButton.layer.cornerRadius = self.subscribeButton.height / 2.0;
    self.subscribeButton.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:14];
}

@end
