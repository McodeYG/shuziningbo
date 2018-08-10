//
//  JstyleMyRecommendGoodsViewCell.h
//  Exquisite
//
//  Created by 数字宁波 on 2016/11/24.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleMyRecommendGoodsModel.h"

@interface JstyleMyRecommendGoodsViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;

@property (weak, nonatomic) IBOutlet UILabel *goodsBrandLabel;

@property (weak, nonatomic) IBOutlet JstyleLabel *goodsTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;

@property (strong, nonatomic) UIView *lineView;

- (void)setViewWithModel:(JstyleMyRecommendGoodsModel *)model;

@end
