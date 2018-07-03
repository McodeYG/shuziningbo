//
//  ICityWeeklyReadTableViewCell.m
//  iCity
//
//  Created by 王磊 on 2018/4/27.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityWeeklyReadTableViewCell.h"


@interface ICityWeeklyReadTableViewCell()

@property (nonatomic, strong) ICityWeeklyReadCollectionView *readRoomTopView;

@property (nonatomic, strong) ICityWeeklyReadCollectionView *readRoomBottomView;

@end

@implementation ICityWeeklyReadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //顶部的
    ICityWeeklyReadCollectionView *readRoomTop = [[ICityWeeklyReadCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ReadImg_h+70) collectionViewLayout:[UICollectionViewFlowLayout new]];
    self.readRoomTopView = readRoomTop;
    readRoomTop.tag = 110;
    __weak typeof(self) weakSelf = self;
    readRoomTop.weeklyReadCollectionViewBlock = ^(NSIndexPath *indexPath) {
        if (weakSelf.topReadCellBlock) {
            weakSelf.topReadCellBlock(indexPath);
        }
    };
    [self.contentView addSubview:readRoomTop];
    
    //底部的
    ICityWeeklyReadCollectionView *readRoombottom = [[ICityWeeklyReadCollectionView alloc] initWithFrame:CGRectMake(0, ReadImg_h+71, kScreenWidth, ReadImg_h+71) collectionViewLayout:[UICollectionViewFlowLayout new]];
    
    self.readRoomBottomView = readRoombottom;
    
    readRoombottom.tag = 120;
    readRoombottom.weeklyReadCollectionViewBlock = ^(NSIndexPath *indexPath) {
        if (weakSelf.bottomReadCellBlock) {
            weakSelf.bottomReadCellBlock(indexPath);
        }
    };
    [self.contentView addSubview:readRoombottom];
    
}

#pragma mark - 区分数据源——顶部数据
- (void)setTopDataArray:(NSArray *)topDataArray {
    _topDataArray = topDataArray;
    self.readRoomTopView.dataArray = topDataArray;
    
}

-(void)setBottomDataArray:(NSArray *)bottomDataArray {
    _bottomDataArray = bottomDataArray;
    self.readRoomBottomView.dataArray = bottomDataArray;
    
}

@end
