//
//  JstyleEarningListViewCell.m
//  Exquisite
//
//  Created by JingHongMuYun on 2018/3/6.
//  Copyright © 2018年 JstyleStar. All rights reserved.
//

#import "JstyleEarningListViewCell.h"

@implementation JstyleEarningListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.rankLabel.textColor = kDarkThreeColor;
    self.nameLabel.textColor = kDarkThreeColor;
    self.numberLabel.textColor = kDarkThreeColor;
    self.incomeLabel.textColor = kNormalRedColor;
}

- (void)setModel:(JstyleEarningListModel *)model
{
    _model = model;
    if ([model.ranking integerValue] < 4) {
        NSString *img = [NSString stringWithFormat:@"收益总榜-%@",model.ranking];
        self.rankImageView.image = JSImage(img);
        self.rankImageView.hidden = NO;
        self.rankLabel.hidden = YES;
    }else{
        self.rankLabel.text = [NSString stringWithFormat:@"%@",model.ranking];
        self.rankImageView.hidden = YES;
        self.rankLabel.hidden = NO;
    }
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.nick_name];
    self.numberLabel.text = [NSString stringWithFormat:@"%@",model.vip_invite_num];
    self.incomeLabel.text = [NSString stringWithFormat:@"%@",model.all_price];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
