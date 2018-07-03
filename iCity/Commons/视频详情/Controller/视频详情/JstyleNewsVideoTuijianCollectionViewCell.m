//
//  JstyleNewsVideoTuijianCollectionViewCell.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/4.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsVideoTuijianCollectionViewCell.h"

@implementation JstyleNewsVideoTuijianCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(JstyleNewsVideoDetailTuijianModel *)model
{
    [self.backImageView setImageWithURL:[NSURL URLWithString:model.poster] placeholder:SZ_Place_S_N options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.nameLabel.attributedText = [[NSString stringWithFormat:@"%@", model.title] attributedStringWithlineSpace:3 textColor:kDarkOneColor font:JSFont(13)];
}

@end
