//
//  JstyleMediaPersonalSquareHoldViewCell.m
//  Exquisite
//
//  Created by 数字宁波 on 2017/8/29.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleMediaPersonalSquareHoldViewCell.h"

@implementation JstyleMediaPersonalSquareHoldViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.collectionView = [[JstyleMediaPersonalNumCollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 440) collectionViewItemSize:CGSizeMake(kScreenWidth/2.0, 220)];
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
