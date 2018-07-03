//
//  JstyleNewsRankingListLeftViewCell.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/4/24.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsRankingListLeftViewCell.h"

@implementation JstyleNewsRankingListLeftViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = kDarkNineColor;
        _nameLabel.font = JSFont(15);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    _nameLabel.frame = self.bounds;
}

- (void)setModel:(JstyleNewsJMAttentionLeftCateModel *)model
{
    _model = model;
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        _nameLabel.textColor = kDarkTwoColor;
        _nameLabel.backgroundColor = kWhiteColor;
    }else{
        _nameLabel.textColor = kDarkNineColor;
        _nameLabel.backgroundColor = kBackGroundColor;
    }
}

@end
