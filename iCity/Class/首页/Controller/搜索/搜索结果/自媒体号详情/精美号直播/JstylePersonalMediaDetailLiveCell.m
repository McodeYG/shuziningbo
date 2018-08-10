//
//  JstylePersonalMediaDetailLiveCell.m
//  Exquisite
//
//  Created by 数字宁波 on 2017/8/8.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstylePersonalMediaDetailLiveCell.h"

@implementation JstylePersonalMediaDetailLiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.timeLabel.textColor = kDarkNineColor;
    self.lookNumLabel.textColor = kDarkNineColor;
}

- (void)setModel:(JstylePersonalMediaDetailModel *)model
{
    [self.backImageView setImageWithURL:[NSURL URLWithString:model.poster] placeholder:SZ_Place_S_N options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.introLabel.attributedText = [model.title attributedStringWithlineSpace:3 font:[UIFont systemFontOfSize:15]];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.air_time];
    
    if (model.play_num.integerValue >= 10000) {
        self.lookNumLabel.text = [NSString stringWithFormat:@"%.1f万",model.play_num.floatValue/10000];
    } else {
        self.lookNumLabel.text = [NSString stringWithFormat:@"%@",model.play_num];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
