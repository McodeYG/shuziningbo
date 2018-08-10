//
//  JstyleMyHomeViewCell.m
//  Exquisite
//
//  Created by 数字宁波 on 2017/6/12.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleMyHomeViewCell.h"

@implementation JstyleMyHomeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.textColor = kDarkTwoColor;
    self.detailLabel.textColor = kDarkNineColor;
    self.singleLine = [[UIView alloc]init];
    self.singleLine.backgroundColor = kSingleLineColor;
    [self.contentView addSubview:self.singleLine];
    self.singleLine.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .heightIs(0.5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
