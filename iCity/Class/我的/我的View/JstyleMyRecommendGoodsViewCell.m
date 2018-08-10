//
//  JstyleMyRecommendGoodsViewCell.m
//  Exquisite
//
//  Created by 数字宁波 on 2016/11/24.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import "JstyleMyRecommendGoodsViewCell.h"

@implementation JstyleMyRecommendGoodsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = kSingleLineColor;
    [self addSubview:_lineView];
}

- (void)setViewWithModel:(JstyleMyRecommendGoodsModel *)model
{
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.poster] placeholderImage:[UIImage imageNamed:@"180*180"]];
    self.goodsBrandLabel.text = model.rname;
    self.goodsTitleLabel.text = model.gname;
    self.goodsPriceLabel.text = model.sale_price;
}

@end
