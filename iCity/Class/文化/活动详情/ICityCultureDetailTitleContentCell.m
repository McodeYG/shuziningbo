//
//  JstyleNewsArticleDetailTitleContentCell.m
//  JstyleNews
//
//  Created by 数字跃动 on 2017/12/29.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "ICityCultureDetailTitleContentCell.h"

@interface ICityCultureDetailTitleContentCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ctimeLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation ICityCultureDetailTitleContentCell

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
    
    
    UITapGestureRecognizer *tapPerson = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPersonAction)];
    UITapGestureRecognizer *tapPerson2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPersonAction)];
    [self.personNameLabel addGestureRecognizer:tapPerson];
    [self.posterImageView addGestureRecognizer:tapPerson2];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(10);
        make.right.offset(-10);
    }];
    
    [self.posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.height.width.offset(35);
    }];
    
    [self.personNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.posterImageView.mas_right).offset(10);
        make.top.equalTo(self.posterImageView);
    }];
    
    [self.ctimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.personNameLabel);
        make.top.equalTo(self.personNameLabel.mas_bottom).offset(3);
    }];
    
    [self.subscribeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.posterImageView);
        make.right.offset(-10);
        make.width.offset(55);
        make.height.offset(24);
    }];
    
    [self.subscribeButton addTarget:self action:@selector(subscribeBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.subscribeButton.layer.cornerRadius = 12.0;
    self.subscribeButton.layer.masksToBounds = YES;
    self.subscribeButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.subscribeButton.layer.borderWidth = 0.5;
    [self.subscribeButton setTitle:@"关注" forState:UIControlStateNormal];
    [self.subscribeButton setTitle:@"已关注" forState:UIControlStateSelected];
    [self.subscribeButton setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor]] forState:UIControlStateNormal];
    [self.subscribeButton setBackgroundImage:[UIImage imageWithColor:kWhiteColor] forState:UIControlStateSelected];
    [self.subscribeButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self.subscribeButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    self.subscribeButton.selected = NO;
    
    self.backView.backgroundColor = kNightModeBackColor;
    [self applyTheme];
}

- (void)tapPersonAction {
    if (self.tapPersonBlock) {
        self.tapPersonBlock(self.model.author_did);
    }
}

- (void)setModel:(JstyleNewsArticleDetailModel *)model {
    _model = model;
    
    self.titleLabel.text = model.title;
    [self.posterImageView setImageWithURL:[NSURL URLWithString:model.author_img] placeholder:[UIImage imageNamed:@"placeholder_small"]];
    self.personNameLabel.text = model.author_name;
    self.subscribeButton.selected = (model.isShowAuthor.integerValue == 1);
    
    if (model==nil) {
        self.ctimeLabel.text = @"";
    } else {
        if (model.ctime.length>12) {
            self.ctimeLabel.text = [model.ctime dealTimeStr];
        } else {
            self.ctimeLabel.text = model.ctime;
        }
    }
     
    
    [self.titleLabel sizeToFit];
    [self.personNameLabel sizeToFit];
    [self.ctimeLabel sizeToFit];
}

- (void)subscribeBtnDidClicked:(UIButton *)sender {
    __weak typeof(self)weakSelf = self;
    if (self.subscribeBlock) {
        self.subscribeBlock(weakSelf.model.author_did);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.model.cellHeight = CGRectGetMaxY(self.posterImageView.frame) + 30;
}

@end
