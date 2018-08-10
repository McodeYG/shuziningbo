//
//  JstyleMediaPersonalTableViewCell.m
//  Exquisite
//
//  Created by 数字宁波 on 2017/8/29.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleMediaPersonalTableViewCell.h"

@implementation JstyleMediaPersonalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.followNumLabel.textColor = kDarkNineColor;
    self.backImageView.layer.cornerRadius = 5;
    self.backImageView.layer.masksToBounds = YES;
    self.holdView.layer.cornerRadius = 5;
}

- (void)setModel:(JstylePersonalMediaListModel *)model
{
    [self.backImageView setImageWithURL:[NSURL URLWithString:model.head_img] placeholder:SZ_Place_Header options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.nameLabel.text = model.pen_name;
    self.introLabel.attributedText = [model.instruction attributedStringWithlineSpace:3 textColor:kDarkFiveColor font:[UIFont systemFontOfSize:12]];
    self.followNumLabel.text = [NSString stringWithFormat:@"%@人关注",model.follow_num];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
