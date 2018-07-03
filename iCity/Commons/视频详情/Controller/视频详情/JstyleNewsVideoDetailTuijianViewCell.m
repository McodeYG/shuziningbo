//
//  JstyleNewsVideoTuijianViewCell.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/4.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsVideoDetailTuijianViewCell.h"

@implementation JstyleNewsVideoDetailTuijianViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _videoCollectionView = [[JstyleNewsVideoTuijianCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 170) collectionViewItemSize:CGSizeMake((kScreenWidth - 35)/2.3, 170)];
        [self.contentView addSubview:_videoCollectionView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
