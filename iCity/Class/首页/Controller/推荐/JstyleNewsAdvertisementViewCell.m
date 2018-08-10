//
//  JstyleNewsAdvertisementViewCell.m
//  JstyleNews
//
//  Created by 数字宁波 on 2017/10/24.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsAdvertisementViewCell.h"

@implementation JstyleNewsAdvertisementViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLabel.font = JSTitleFont;
    
    self.nameLabel.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .autoHeightRatio(0);
    self.nameLabel.isAttributedContent = YES;
    [self.nameLabel setMaxNumberOfLinesToShow:2];
    
    self.backImageView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(self.nameLabel, 10)
    .autoHeightRatio(200/355.0);
    
    self.adLabel.sd_layout
    .rightEqualToView(self.backImageView).offset(-5)
    .bottomEqualToView(self.backImageView).offset(-10)
    .heightIs(10);
    [self.adLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    self.adImageView.sd_layout
    .rightSpaceToView(self.adLabel, 10)
    .centerYEqualToView(self.adLabel)
    .widthIs(14)
    .heightIs(14);
    
    
}

- (void)setModel:(JstyleNewsJMAttentionListModel *)model
{
    _model = model;
    [self.backImageView setImageWithURL:[NSURL URLWithString:model.poster] placeholder:SZ_Place_S_N options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.nameLabel.text = model.title;
    if ([model.banner_type integerValue]==5) {
        self.adLabel.text = @"活动";
    }else{
        self.adLabel.text = @"广告";
    }
    [self setupAutoHeightWithBottomView:self.backImageView bottomMargin:10];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
