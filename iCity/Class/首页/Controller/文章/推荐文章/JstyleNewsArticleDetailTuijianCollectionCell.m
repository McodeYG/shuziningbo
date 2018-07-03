//
//  JstyleNewsArticleDetailTuijianCollectionCell.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/29.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsArticleDetailTuijianCollectionCell.h"

@implementation JstyleNewsArticleDetailTuijianCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(JstyleNewsArticleDetailTuijianModel *)model
{
    [self.backImageView setImageWithURL:[NSURL URLWithString:model.poster] placeholder:SZ_Place_S_N options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.nameLabel.attributedText = [[NSString stringWithFormat:@"%@", model.title] attributedStringWithlineSpace:3 font:JSFont(13)];
}

@end
