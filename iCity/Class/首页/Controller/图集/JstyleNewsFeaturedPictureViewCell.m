//
//  JstyleNewsFeaturedPictureViewCell.m
//  JstyleNews
//
//  Created by 赵涛 on 2017/10/25.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsFeaturedPictureViewCell.h"

@implementation JstyleNewsFeaturedPictureViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.subjectLabel.textColor = kDarkNineColor;
    self.timeLabel.textColor = kDarkNineColor;
    self.holdView.backgroundColor = [kDarkZeroColor colorWithAlphaComponent:0.33];
    self.holdView.layer.cornerRadius = 10;
    self.columnView.backgroundColor = kBackGroundColor;
    
    self.backImageView.sd_layout
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .topSpaceToView(self.contentView, 0)
    .autoHeightRatio(10/16.0);
    
    self.nameLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(self.backImageView, 15)
    .autoHeightRatio(0);
    self.nameLabel.isAttributedContent = YES;
    //[self.nameLabel setMaxNumberOfLinesToShow:2];
    
    self.imageNumLabel.sd_layout
    .rightEqualToView(self.backImageView).offset(- 22)
    .bottomEqualToView(self.backImageView).offset(- 20)
    .heightIs(11);
    [self.imageNumLabel setSingleLineAutoResizeWithMaxWidth:50];
    
    self.iconImageView.sd_layout
    .rightSpaceToView(self.imageNumLabel, 5)
    .centerYEqualToView(self.imageNumLabel)
    .widthIs(11)
    .heightIs(11);
    
    self.holdView.sd_layout
    .rightEqualToView(self.imageNumLabel).offset(7)
    .centerYEqualToView(self.imageNumLabel)
    .leftEqualToView(self.iconImageView).offset(-7)
    .heightIs(20);
    
    self.subjectLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.nameLabel, 7)
    .heightIs(12);
    [self.subjectLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    self.timeLabel.sd_layout
    .leftSpaceToView(self.subjectLabel, 7)
    .centerYEqualToView(self.subjectLabel)
    .heightIs(12);
    [self.timeLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    self.columnView.sd_layout
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .topSpaceToView(self.subjectLabel, 15)
    .heightIs(10);
}

- (void)setModel:(JstyleNewsHomePageModel *)model
{
    _model = model;
    [self.backImageView setImageWithURL:[NSURL URLWithString:model.poster] placeholder:SZ_Place_S_N options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.nameLabel.attributedText = [[NSString stringWithFormat:@"%@",model.title] attributedStringWithlineSpace:3 font:JSTitleFont];
    self.subjectLabel.text = [NSString stringWithFormat:@"%@",model.author_name];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.ctime];
    self.imageNumLabel.text = [NSString stringWithFormat:@"%@图",model.posternum];
    
    [self setupAutoHeightWithBottomView:self.columnView bottomMargin:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
