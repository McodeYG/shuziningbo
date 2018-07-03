//
//  JstyleJiFenDetailViewCell.m
//  Exquisite
//
//  Created by 赵涛 on 2017/2/28.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleJiFenDetailViewCell.h"

@implementation JstyleJiFenDetailViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineView.backgroundColor = kSingleLineColor;
}

- (void)setViewWithModel:(JMMyJiFenModel *)model
{
    self.title.text = model.way;
    self.timeLabel.text = model.create_date;
    self.scoreLabel.text = model.types;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
