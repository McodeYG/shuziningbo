//
//  NewMediaCell.m
//  iCity
//
//  Created by mayonggang on 2018/6/15.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "NewMediaCell.h"

@interface NewMediaCell ()
//报纸图标
@property (weak, nonatomic)UIImageView *paperImage;
///报纸名字
@property (weak, nonatomic)UILabel *nameLabel;
///时间
@property (weak, nonatomic)UILabel *timeLabel;

@end

@implementation NewMediaCell



+(instancetype)initWithTableView:(UITableView *)tableView {
    
    static NSString * cell_id = @"NewMediaCell_id";
    NewMediaCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[NewMediaCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cell_id];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = kNightModeBackColor;
    self.contentView.backgroundColor = kNightModeBackColor;
    CGFloat item_W      = (SCREEN_W-25)/5;
    CGFloat header_W    = 90/2;
    self.collectionView = [[NewMediaCollectionView alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth, 2+(15+header_W+10+17)*2) collectionViewItemSize:CGSizeMake(item_W, 15+header_W+10+17)];
    self.collectionView.backgroundColor = kNightModeBackColor;
    [self.contentView addSubview:self.collectionView];
    
}

@end
