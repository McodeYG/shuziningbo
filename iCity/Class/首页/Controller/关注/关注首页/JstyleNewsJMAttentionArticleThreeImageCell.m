//
//  JstyleNewsJMAttentionArticleThreeImageCell.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/3/29.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsJMAttentionArticleThreeImageCell.h"
#import "JstyleNewsJMNumDetailsViewController.h"

@implementation JstyleNewsJMAttentionArticleThreeImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.authorImageView.layer.cornerRadius = 15;
    self.authorImageView.layer.masksToBounds = YES;
    self.authorImageView.layer.borderColor = JSColor(@"#DEDEDE").CGColor;
    self.authorImageView.layer.borderWidth = 0.5;
    
    self.holdView.backgroundColor = [kDarkZeroColor colorWithAlphaComponent:0.33];
    self.holdView.layer.cornerRadius = 10;
    self.holdView.layer.masksToBounds = YES;
    
    [self.focusBtn addTarget:self action:@selector(focusBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        JstyleNewsJMNumDetailsViewController *jstylePersonalMediaVC = [JstyleNewsJMNumDetailsViewController new];
        jstylePersonalMediaVC.did = _model.author_did;
        [self.viewController.navigationController pushViewController:jstylePersonalMediaVC animated:YES];
    }];
    [self.authorImageView addGestureRecognizer:tap];
    
    _photosContainerView = [[JstylePhotosContainerView alloc] initWithMaxItemsCount:3 verticalMargin:0 horizontalMargin:1.5 verticalEdgeInset:0 horizontalEdgeInset:15];
    _photosContainerView.delegate = self;
    [self.contentView insertSubview:_photosContainerView belowSubview:_holdView];
    
    self.nameLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(self.authorImageView, 15)
    .autoHeightRatio(0);
    self.nameLabel.isAttributedContent = YES;
    
    self.photosContainerView.sd_layout
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .topSpaceToView(self.nameLabel, 10);
    
    self.imageNumLabel.sd_layout
    .rightEqualToView(self.photosContainerView).offset(- 32)
    .bottomEqualToView(self.photosContainerView).offset(- 15)
    .heightIs(11);
    [self.imageNumLabel setSingleLineAutoResizeWithMaxWidth:50];
    
    self.iconImageView.sd_layout
    .rightSpaceToView(self.imageNumLabel, 5)
    .centerYEqualToView(self.imageNumLabel)
    .widthIs(11)
    .heightIs(11);
    
    self.holdView.sd_layout
    .rightEqualToView(self.imageNumLabel).offset(7)
    .leftEqualToView(self.iconImageView).offset(-7)
    .centerYEqualToView(self.imageNumLabel)
    .heightIs(20);
}

- (void)setModel:(JstyleNewsJMAttentionListModel *)model
{
    _model = model;
    [self.authorImageView setImageWithURL:[NSURL URLWithString:model.author_img] placeholder:SZ_Place_Header options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.authorNameLabel.text = [NSString stringWithFormat:@"%@",model.author_name];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.ctime];
    self.nameLabel.attributedText = [[NSString stringWithFormat:@"%@",model.title] attributedStringWithlineSpace:3 font:JSTitleFont];
    self.photosContainerView.photoNamesArray = model.poster_imgs;
    
    self.focusBtn.selected = (model.isShowAuthor.integerValue == 1);
    
    if ([model.posternum integerValue] > 0) {
        self.holdView.hidden = NO;
        self.iconImageView.hidden = NO;
        self.imageNumLabel.hidden = NO;
        self.imageNumLabel.text = [NSString stringWithFormat:@"%@图",model.posternum];
    }else{
        self.holdView.hidden = YES;
        self.iconImageView.hidden = YES;
        self.imageNumLabel.hidden = YES;
    }
    
    [self setupAutoHeightWithBottomView:self.photosContainerView bottomMargin:15];
}

- (void)focusBtnClick {
    if (self.focusBtnBlock) {
        self.focusBtnBlock(_model.author_did);
    }
}

@end
