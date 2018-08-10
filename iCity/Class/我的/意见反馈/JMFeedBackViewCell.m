//
//  JMFeedBackViewCell.m
//  Exquisite
//
//  Created by 数字宁波 on 2016/11/24.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import "JMFeedBackViewCell.h"

@implementation JMFeedBackViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _menuNameLabel.textColor = kDarkTwoColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
