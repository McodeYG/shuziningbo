//
//  JstyleNewsJMAttentionVideoLiveCell.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/3/29.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsJMAttentionVideoLiveCell.h"
#import "JstyleNewsJMNumDetailsViewController.h"

@implementation JstyleNewsJMAttentionVideoLiveCell

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
    
    self.nameLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(self.authorImageView, 15)
    .autoHeightRatio(0);
    self.nameLabel.isAttributedContent = YES;
    
    self.backImageView.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(self.nameLabel, 10)
    .autoHeightRatio(9/16.0);
    
    self.statusImageView.sd_layout
    .rightEqualToView(self.backImageView).offset(- 15)
    .bottomEqualToView(self.backImageView).offset(- 15)
    .widthIs(50)
    .heightIs(20);
    
    self.playNumLabel.sd_layout
    .rightEqualToView(self.backImageView).offset(- 18)
    .bottomEqualToView(self.backImageView).offset(- 15)
    .heightIs(10);
    [self.playNumLabel setSingleLineAutoResizeWithMaxWidth:50];
    
    self.iconImageView.sd_layout
    .rightSpaceToView(self.playNumLabel, 5)
    .centerYEqualToView(self.playNumLabel)
    .widthIs(10)
    .heightIs(10);
    
    self.holdView.sd_layout
    .rightEqualToView(self.playNumLabel).offset(7)
    .centerYEqualToView(self.playNumLabel)
    .leftEqualToView(self.iconImageView).offset(-7)
    .heightIs(20);
    
    self.videoPlayBtn.sd_layout
    .centerXEqualToView(self.backImageView)
    .centerYEqualToView(self.backImageView)
    .widthIs(41)
    .heightIs(41);
}

- (void)setModel:(JstyleNewsJMAttentionListModel *)model
{
    _model = model;
    [self.authorImageView setImageWithURL:[NSURL URLWithString:model.author_img] placeholder:SZ_Place_Header options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.authorNameLabel.text = [NSString stringWithFormat:@"%@",model.author_name];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.ctime];
    [self.backImageView setImageWithURL:[NSURL URLWithString:model.poster] placeholder:SZ_Place_S_N options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.nameLabel.attributedText = [[NSString stringWithFormat:@"%@",model.title] attributedStringWithlineSpace:3 font:JSTitleFont];
    
//    if ([model.play_num integerValue] > 9999) {
//        self.playNumLabel.text = [NSString stringWithFormat:@"%.1fw",[model.play_num floatValue]/10000.0];
//    }else{
//        if ([model.play_num integerValue] > 999) {
//            self.playNumLabel.text = [NSString stringWithFormat:@"%.1fk",[model.play_num floatValue]/1000.0];
//        }else{
//            self.playNumLabel.text = model.play_num;
//        }
//    }
    self.playNumLabel.text = [model.play_num dealNumberStr];
    
    if ([model.video_type integerValue] == 1) {
        [self.videoPlayBtn setImage:JSImage(@"直播按钮") forState:(UIControlStateNormal)];
        self.holdView.hidden = YES;
        self.playNumLabel.hidden = YES;
        self.iconImageView.hidden = YES;
        self.statusImageView.hidden = NO;
    }else{
        [self.videoPlayBtn setImage:JSImage(@"播放按钮") forState:(UIControlStateNormal)];
        self.holdView.hidden = NO;
        self.playNumLabel.hidden = NO;
        self.iconImageView.hidden = NO;
        self.statusImageView.hidden = YES;
    }
    
    if ([model.isFollow integerValue] == 1) {
        self.focusBtn.selected = YES;
    }else{
        self.focusBtn.selected = NO;
    }
    self.focusBtn.selected = (model.isShowAuthor.integerValue == 1);
    [self setupAutoHeightWithBottomView:self.backImageView bottomMargin:15];
}

- (void)focusBtnClick {
    if (self.focusBtnBlock) {
        self.focusBtnBlock(_model.author_did);
    }
}

@end
