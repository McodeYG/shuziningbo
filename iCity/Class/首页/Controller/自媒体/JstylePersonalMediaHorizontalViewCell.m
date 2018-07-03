//
//  JstylePersonalMediaHorizontalViewCell.m
//  Exquisite
//
//  Created by 赵涛 on 2017/8/4.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstylePersonalMediaHorizontalViewCell.h"

@implementation JstylePersonalMediaHorizontalViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.textColor = kLightBlueColor;
    self.followNumLabel.textColor = kDarkNineColor;
    self.backImageView.layer.cornerRadius = 5;
    self.backImageView.layer.masksToBounds = YES;
    self.holdView.layer.cornerRadius = 5;
}

- (void)setModel:(JstylePersonalMediaListModel *)model
{
    [self.backImageView setImageWithURL:[NSURL URLWithString:model.head_img] placeholder:SZ_Place_Header options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.nameLabel.text = model.pen_name;
    self.introLabel.attributedText = [model.instruction attributedStringWithlineSpace:3 textColor:kDarkTwoColor font:[UIFont systemFontOfSize:13]];
    self.followNumLabel.text = [NSString stringWithFormat:@"%@人关注",model.follow_num];
}

@end
