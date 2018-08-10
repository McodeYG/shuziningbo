//
//  JstyleManagementAccountInfoViewCell.m
//  Exquisite
//
//  Created by 数字宁波 on 2017/10/16.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleManagementAccountInfoViewCell.h"

@implementation JstyleManagementAccountInfoViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLabel.textColor = ISNightMode?kDarkNineColor:kDarkOneColor;
    self.detailLabel.textColor = ISNightMode?kDarkNineColor:kDarkFiveColor;
    
    self.detailLabel.sd_layout
    .topSpaceToView(self.contentView, 15)
    .leftSpaceToView(self.nameLabel, 30)
    .rightSpaceToView(self.contentView, 15)
    .autoHeightRatio(0);
}

- (void)setModel:(JstyleManagementAccountInfoModel *)model
{
    self.nameLabel.attributedText = [[NSString stringWithFormat:@"＊%@:",model.name] attributedStringWithTextColor:kPinkColor range:NSMakeRange(0, 1) textFont:14];
    self.detailLabel.text = [NSString stringWithFormat:@"%@",model.detail];
    
    [self setupAutoHeightWithBottomView:self.detailLabel bottomMargin:15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
