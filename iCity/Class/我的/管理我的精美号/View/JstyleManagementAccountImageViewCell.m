//
//  JstyleManagementAccountImageViewCell.m
//  Exquisite
//
//  Created by 赵涛 on 2017/10/16.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleManagementAccountImageViewCell.h"

@implementation JstyleManagementAccountImageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.textColor = ISNightMode?kDarkNineColor:kDarkOneColor;
    self.headerImageView.layer.cornerRadius = 23;
}

- (void)setModel:(JstyleManagementAccountInfoModel *)model
{
    self.nameLabel.attributedText = [[NSString stringWithFormat:@"＊%@:",model.name] attributedStringWithTextColor:kPinkColor range:NSMakeRange(0, 1) textFont:14];
    [self.headerImageView setImageWithURL:[NSURL URLWithString:model.detail] placeholder:[UIImage imageNamed:@"placeholder"] options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
