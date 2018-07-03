//
//  ICityPopularActivitiesTableViewCell.m
//  iCity
//
//  Created by 王磊 on 2018/5/1.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityPopularActivitiesTableViewCell.h"
#import "ICityPopularActivitiesCollectionView.h"

@interface ICityPopularActivitiesTableViewCell()

@property (nonatomic, strong) ICityPopularActivitiesCollectionView *popularActivitiesCV;

@end

@implementation ICityPopularActivitiesTableViewCell

-(void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupTableViewCell];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupTableViewCell];
    }
    return self;
}

- (void)setupTableViewCell {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = kWhiteColor;
    
    CGFloat margin = 10;
    CGFloat cellWidth = (kScreenWidth - margin*4)/3.0;
    CGFloat cellHeight = cellWidth * 149.0 / 112.0 + 50;
    
    CGRect collectionFrame = CGRectMake(0, 0, kScreenWidth, cellHeight + margin);
    
    ICityPopularActivitiesCollectionView *popularActivitiesCV = [[ICityPopularActivitiesCollectionView alloc] initWithFrame:collectionFrame collectionViewLayout:[UICollectionViewFlowLayout new]];
    self.popularActivitiesCV = popularActivitiesCV;
    __weak typeof(self) weakSelf = self;
    popularActivitiesCV.reuseSelectBlock = ^(NSString *selectID) {
        if (weakSelf.reuseSelectBlock) {
            weakSelf.reuseSelectBlock(selectID);
        }
    };
    [self.contentView addSubview:popularActivitiesCV];
    
     [self applyTheme];
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    self.popularActivitiesCV.dataArray = dataArray;
}

@end
