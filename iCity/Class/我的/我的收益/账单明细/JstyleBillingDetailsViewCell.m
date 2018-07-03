//
//  JstyleBillingDetailsViewCell.m
//  Exquisite
//
//  Created by JingHongMuYun on 2018/3/6.
//  Copyright © 2018年 JstyleStar. All rights reserved.
//

#import "JstyleBillingDetailsViewCell.h"

@implementation JstyleBillingDetailsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(JstyleBillingDetailsModel *)model
{
    _model = model;
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.type];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.ctime];
    self.incomeLabel.text = [NSString stringWithFormat:@"%@",model.price];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
