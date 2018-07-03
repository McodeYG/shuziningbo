//
//  JstyleMyInvitedMembersViewCell.m
//  Exquisite
//
//  Created by JingHongMuYun on 2018/3/6.
//  Copyright © 2018年 JstyleStar. All rights reserved.
//

#import "JstyleMyInvitedMembersViewCell.h"

@implementation JstyleMyInvitedMembersViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headerImageView.layer.cornerRadius = 10;
    self.headerImageView.layer.masksToBounds = YES;
    self.nameLabel.textColor = kDarkThreeColor;
    self.timeLabel.textColor = kDarkNineColor;
    self.incomeLabel.textColor = kNormalRedColor;
}

- (void)setModel:(JstyleMyInvitedMembersModel *)model
{
    _model = model;
    [self.headerImageView setImageWithURL:[NSURL URLWithString:model.avator] placeholder:nil options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.nick_name];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.invite_time];
    self.incomeLabel.text = [NSString stringWithFormat:@"%@",model.price];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
