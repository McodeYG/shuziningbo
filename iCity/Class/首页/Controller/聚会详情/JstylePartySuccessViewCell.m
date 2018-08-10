//
//  JstylePartySuccessViewCell.m
//  Exquisite
//
//  Created by 数字宁波 on 2017/7/7.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstylePartySuccessViewCell.h"

@implementation JstylePartySuccessViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.singleLine.backgroundColor = kSingleLineColor;
    
    _nameLabel.sd_layout
    .leftSpaceToView(self.iconImageView, 10)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(self.contentView, 15)
    .autoHeightRatio(0);
    _nameLabel.isAttributedContent = YES;
    
    self.singleLine.sd_layout
    .bottomEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(0.5);
}

- (void)setModel:(JstylePartySuccessInfoModel *)model
{
    _model = model;
    if ([model.type integerValue] == 3) {
        self.nameLabel.font = [UIFont boldSystemFontOfSize:15];
        self.nameLabel.attributedText = [[NSString stringWithFormat:@"￥%@",model.name] attributedStringWithlineSpace:3 textColor:kDarkTwoColor font:[UIFont systemFontOfSize:15]];
        self.singleLine.sd_resetLayout
        .bottomEqualToView(self.contentView)
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .heightIs(0.5);
    }else{
        self.nameLabel.font = [UIFont systemFontOfSize:13];
        self.nameLabel.attributedText = [model.name attributedStringWithlineSpace:3 textColor:kDarkTwoColor font:[UIFont systemFontOfSize:13]];
        self.singleLine.sd_layout
        .bottomEqualToView(self.contentView)
        .leftSpaceToView(self.contentView, 15)
        .rightSpaceToView(self.contentView, 0)
        .heightIs(0.5);
    }
    [self setupAutoHeightWithBottomView:self.nameLabel bottomMargin:15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
