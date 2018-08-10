//
//  JstylePartyHomeViewCell.m
//  Exquisite
//
//  Created by 数字宁波 on 2017/7/5.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstylePartyHomeViewCell.h"

@implementation JstylePartyHomeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.partyNameLabel.textColor = kDarkTwoColor;
    self.partyPriceLabel.textColor = kNormalRedColor;
    self.partyPeapleLabel.textColor = kDarkNineColor;
    self.partyTimeLabel.textColor = kDarkNineColor;
    self.partyAddressLabel.textColor = kDarkNineColor;
    self.partyLookNumLabel.textColor = kDarkNineColor;
    self.singleLine1.backgroundColor = [kLightLineColor colorWithAlphaComponent:0.15];
    self.singleLine2.backgroundColor = [kLightLineColor colorWithAlphaComponent:0.15];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.partyAddressLabel addGestureRecognizer:tap];
}

- (void)setModel:(JstylePartyHomeModel *)model
{
    _model = model;
    [self.partyImageView setImageWithURL:[NSURL URLWithString:model.image] placeholder:SZ_Place_S_N options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.partyNameLabel.attributedText = [model.name attributedStringWithlineSpace:3 textColor:kDarkTwoColor font:[UIFont systemFontOfSize:13]];
    self.partyPriceLabel.attributedText = [[NSString stringWithFormat:@"￥%@",model.sale_price] attributedStringWithTextColor:kNormalRedColor range:NSMakeRange(0, 1) textFont:10];
    self.partyPeapleLabel.attributedText = [[model.enroll_num stringByAppendingString:[NSString stringWithFormat:@"人∕%@人",model.people_num]] attributedStringWithTextColor:kDarkNineColor range:NSMakeRange(0, model.enroll_num.length) fontSize:[UIFont systemFontOfSize:12]];
    self.partyTimeLabel.text = model.start_time;
    self.partyAddressLabel.text = model.address;
    self.partyLookNumLabel.text = model.browsenum;
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
