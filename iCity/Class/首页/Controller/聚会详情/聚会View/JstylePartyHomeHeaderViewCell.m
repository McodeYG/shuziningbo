//
//  JstylePartyHomeHeaderViewCell.m
//  Exquisite
//
//  Created by 数字宁波 on 2017/7/18.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstylePartyHomeHeaderViewCell.h"

@implementation JstylePartyHomeHeaderViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.partyAddressLabel addGestureRecognizer:tap];
}

- (void)setModel:(JstylePartyHomeModel *)model
{
    _model = model;
    [self.partyImageView setImageWithURL:[NSURL URLWithString:model.image] placeholder:SZ_Place_S_N options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.partyNameLabel.text = model.name;
    self.partyAddressLabel.text = [[NSString stringWithFormat:@"%@ ",model.address] stringByAppendingString:model.start_time];
}

- (void)tapAction
{
    _addressBlock(_model.long_address);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
