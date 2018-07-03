//
//  JstyleNewsVideoDetailTuijianTableViewCell.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/29.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsVideoDetailTuijianTableViewCell.h"

@implementation JstyleNewsVideoDetailTuijianTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _articleCollectionView = [[JstyleNewsArticleDetailTuijianCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 170) collectionViewItemSize:CGSizeMake((kScreenWidth - 35)/2.3, 170)];
        [self.contentView addSubview:_articleCollectionView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
