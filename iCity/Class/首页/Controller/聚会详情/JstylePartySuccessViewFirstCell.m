//
//  JstylePartySuccessViewFirstCell.m
//  Exquisite
//
//  Created by 赵涛 on 2017/7/7.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstylePartySuccessViewFirstCell.h"

@implementation JstylePartySuccessViewFirstCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews
{
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.textColor = kDarkTwoColor;
    _nameLabel.font = [UIFont boldSystemFontOfSize:15];
    _nameLabel.numberOfLines = 0;
    [self.contentView addSubview:_nameLabel];
    _nameLabel.sd_layout
    .topSpaceToView(self.contentView, 15)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .bottomSpaceToView(self.contentView, 15);
    
    _singleLine1 = [[UIView alloc]init];
    _singleLine1.backgroundColor = kSingleLineColor;
    [self.contentView addSubview:_singleLine1];
    _singleLine1.sd_layout
    .topEqualToView(self.contentView)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(0.5);
    
    _singleLine2 = [[UIView alloc]init];
    _singleLine2.backgroundColor = kSingleLineColor;
    [self.contentView addSubview:_singleLine2];
    _singleLine2.sd_layout
    .bottomEqualToView(self.contentView)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(0.5);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
