//
//  JstyleNewsJMAttentionTuiJianTableViewCell.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/3/28.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsJMAttentionTuiJianTableViewCell.h"

@implementation JstyleNewsJMAttentionTuiJianTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _tuiJianCollectionView = [[JstyleNewsJMAttentionTuiJianCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 205) collectionViewItemSize:CGSizeMake((kScreenWidth - 20)/2.3, 205)];
        [self.contentView addSubview:_tuiJianCollectionView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
