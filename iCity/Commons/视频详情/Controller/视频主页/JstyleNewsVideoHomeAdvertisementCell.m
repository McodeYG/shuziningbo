//
//  JstyleNewsVideoHomeAdvertisementCell.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/7.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsVideoHomeAdvertisementCell.h"

@implementation JstyleNewsVideoHomeAdvertisementCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLabel.font = JSTitleFont;
    
    self.backImageView.sd_layout
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .topSpaceToView(self.contentView, 0)
    .autoHeightRatio(130/345.0);
    
    self.nameLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(self.backImageView, 15)
    .autoHeightRatio(0);
    self.nameLabel.isAttributedContent = YES;
//    [self.nameLabel setMaxNumberOfLinesToShow:2];
    
    self.columnView.sd_layout
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .topSpaceToView(self.nameLabel, 15)
    .heightIs(10);
    
    self.adLabel.sd_layout
    .rightEqualToView(self.backImageView).offset(- 15)
    .bottomEqualToView(self.backImageView).offset(- 10)
    .heightIs(10);
    [self.adLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    self.adImageView.sd_layout
    .rightSpaceToView(self.adLabel, 10)
    .centerYEqualToView(self.adLabel)
    .widthIs(14)
    .heightIs(14);
}

- (void)setModel:(JstyleNewsVideoHomeModel *)model
{
    _model = model;
    NSLog(@"好像没有用到吧~");
    [self.backImageView setImageWithURL:[NSURL URLWithString:model.poster] placeholder:SZ_Place_S_N options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.nameLabel.text = model.title;
    
    [self setupAutoHeightWithBottomView:self.columnView bottomMargin:10];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

