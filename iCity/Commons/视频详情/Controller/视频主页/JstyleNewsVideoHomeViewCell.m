//
//  JstyleNewsVideoHomeViewself.m
//  JstyleNews
//
//  Created by 赵涛 on 2017/10/30.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsVideoHomeViewCell.h"
#import "JstyleNewsTagsVideoViewController.h"
#import "JstyleNewsJMNumDetailsViewController.h"

@implementation JstyleNewsVideoHomeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
    self.holdView.backgroundColor = [kDarkZeroColor colorWithAlphaComponent:0.33];
    self.holdView.layer.cornerRadius = 10;
    self.holdView.layer.masksToBounds = YES;
    self.authorNameLabel.textColor = kDarkNineColor;
    self.authorImageView.layer.cornerRadius = 18;
    self.authorImageView.layer.masksToBounds = YES;
    [self.shareBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    
    [self.videoPlayBtn addTarget:self action:@selector(startPlayVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    [self.backImageView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *authorTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if ([[JstyleToolManager sharedManager] getCurrentNetStatus] == NotReachable) {
            ZTShowAlertMessage(@"当前无网络,请检查网络");
            return;
        }
        JstyleNewsJMNumDetailsViewController *jstyleNewsJmNumsDVC = [JstyleNewsJMNumDetailsViewController new];
        jstyleNewsJmNumsDVC.did = _model.author_did;
        [[self viewController].navigationController pushViewController:jstyleNewsJmNumsDVC animated:YES];
    }];
    [self.authorImageView addGestureRecognizer:authorTap];
    
    self.backImageView.sd_layout
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .topSpaceToView(self.contentView, 0)
    .autoHeightRatio(9/16.0);
    
    self.statusImageView.sd_layout
    .rightEqualToView(self.backImageView).offset(-15)
    .bottomEqualToView(self.backImageView).offset(-15)
    .widthIs(50)
    .heightIs(20);
    
    self.videoPlayBtn.sd_layout
    .centerXEqualToView(self.backImageView)
    .centerYEqualToView(self.backImageView)
    .widthIs(41)
    .heightIs(41);
    
    self.imageNumLabel.sd_layout
    .rightEqualToView(self.backImageView).offset(- 20)
    .bottomEqualToView(self.backImageView).offset(- 20)
    .heightIs(10);
    [self.imageNumLabel setSingleLineAutoResizeWithMaxWidth:50];
    
    self.iconImageView.sd_layout
    .rightSpaceToView(self.imageNumLabel, 5)
    .centerYEqualToView(self.imageNumLabel)
    .widthIs(10)
    .heightIs(10);
    
    self.holdView.sd_layout
    .rightEqualToView(self.imageNumLabel).offset(7)
    .centerYEqualToView(self.imageNumLabel)
    .leftEqualToView(self.iconImageView).offset(-7)
    .heightIs(20);
}

- (void)setModel:(JstyleNewsVideoHomeModel *)model
{
    _model = model;
    [self.backImageView setImageWithURL:[NSURL URLWithString:model.poster] placeholder:SZ_Place_S_N options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    
    self.imageNumLabel.text = [model.play_num dealNumberStr];
    
    if ([model.video_type integerValue] == 1) {
        [self.videoPlayBtn setImage:JSImage(@"直播按钮") forState:(UIControlStateNormal)];
        self.holdView.hidden = YES;
        self.imageNumLabel.hidden = YES;
        self.iconImageView.hidden = YES;
        self.statusImageView.hidden = NO;
    }else{
        [self.videoPlayBtn setImage:JSImage(@"播放按钮") forState:(UIControlStateNormal)];
        self.holdView.hidden = NO;
        self.imageNumLabel.hidden = NO;
        self.iconImageView.hidden = NO;
        self.statusImageView.hidden = YES;
    }
    
    //
    if ([model.isShowAuthor integerValue] == 0) {
        self.authorImageView.hidden = YES;
        self.authorNameLabel.hidden = YES;
        self.nameLabel.attributedText = [[NSString stringWithFormat:@"%@",model.title] attributedStringWithlineSpace:3 font:JSTitleFont];
        
        self.nameLabel.sd_resetNewLayout
        .leftSpaceToView(self.contentView, 10)
        .rightSpaceToView(self.contentView, 32)
        .topSpaceToView(self.backImageView, 13)
        .autoHeightRatio(0);
        self.nameLabel.isAttributedContent = YES;
        
        self.shareBtn.sd_resetNewLayout
        .rightSpaceToView(self.contentView, 15)
        .centerYEqualToView(self.nameLabel)
        .widthIs(17)
        .heightIs(17);
        
        _columnView.sd_resetNewLayout
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .topSpaceToView(_nameLabel, 10)
        .heightIs(10);
    }else{
        self.authorImageView.hidden = NO;
        self.authorNameLabel.hidden = NO;
        [self.authorImageView setImageWithURL:[NSURL URLWithString:model.author_img] placeholder:SZ_Place_Header options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
        self.authorNameLabel.text = [NSString stringWithFormat:@"%@", model.author_name];
        self.nameLabel.font = JSTitleFont;
        self.nameLabel.text = [NSString stringWithFormat:@"%@",model.title];
        
        self.authorImageView.sd_layout
        .leftSpaceToView(self.contentView, 10)
        .topSpaceToView(self.backImageView, 15)
        .widthIs(36)
        .heightIs(36);
        
        self.shareBtn.sd_resetNewLayout
        .rightSpaceToView(self.contentView, 15)
        .centerYEqualToView(self.authorImageView)
        .widthIs(17)
        .heightIs(17);
        
        self.authorNameLabel.sd_layout
        .leftSpaceToView(self.authorImageView, 10)
        .rightSpaceToView(self.contentView, 10)
        .bottomEqualToView(self.authorImageView)
        .heightIs(12);
        
        self.nameLabel.sd_resetNewLayout
        .leftSpaceToView(self.authorImageView, 10)
        .rightSpaceToView(self.shareBtn, 10)
        .topEqualToView(self.authorImageView)
        .heightIs(JSTitleFont.pointSize);
        self.nameLabel.isAttributedContent = NO;
        self.nameLabel.numberOfLines = 1;
        
        _columnView.sd_resetNewLayout
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .topSpaceToView(_authorImageView, 15)
        .heightIs(10);
    }
    
    [self setupAutoHeightWithBottomView:_columnView bottomMargin:0];
}

- (void)singleTap:(UITapGestureRecognizer *)tap
{
    [self.videoPlayBtn sendActionsForControlEvents:(UIControlEventTouchUpInside)];
}

- (void)startPlayVideo:(UIButton *)sender
{
    if (_startPlayVideoBlock) {
        _startPlayVideoBlock(sender);
    }
}

- (void)shareBtnClicked:(UIButton *)sender
{
    if (_videoShareBlock) {
        _videoShareBlock(_model.poster, _model.ashareurl, _model.title, _model.describes);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
