//
//  JstylePersonalMediaSquareViewCell.m
//  Exquisite
//
//  Created by 数字宁波 on 2017/8/4.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstylePersonalMediaSquareViewCell.h"

@implementation JstylePersonalMediaSquareViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.followNumLabel.textColor = kDarkNineColor;
    self.introLabel.textColor = kDarkFiveColor;
    self.alphaView.layer.cornerRadius = 40;
}

- (void)setModel:(JstylePersonalMediaListModel *)model
{
    [self.backImageView setImageWithURL:[NSURL URLWithString:model.head_img] placeholder:SZ_Place_Header options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.nameLabel.text = model.pen_name;
    self.introLabel.attributedText = [model.instruction attributedStringWithlineSpace:3 textColor:kDarkFiveColor font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentCenter];
    self.followNumLabel.text = [NSString stringWithFormat:@"%@人关注",model.follow_num];
    if (model.follow_num.integerValue >= 10000) {
        self.followNumLabel.text = [NSString stringWithFormat:@"%.1f万人关注",model.follow_num.floatValue / 10000];
    } else {
        self.followNumLabel.text = [NSString stringWithFormat:@"%@人关注",model.follow_num];
    }
    self.articleNumLabel.text = model.article_num;
}

@end
