//
//  JMMyInformationViewCell.m
//  Exquisite
//
//  Created by 赵涛 on 16/5/5.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import "JMMyInformationViewCell.h"

@implementation JMMyInformationViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.verticalAlignment = VerticalAlignmentMiddle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
