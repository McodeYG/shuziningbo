//
//  ICityTouristAttractionsTableViewCell.m
//  iCity
//
//  Created by 王磊 on 2018/5/2.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityTouristAttractionsTableViewCell.h"
#import "ICityTouristAttractionsCollectionView.h"

@interface ICityTouristAttractionsTableViewCell()

@property (nonatomic, strong) ICityTouristAttractionsCollectionView *touristAttractionsCV;

@end

@implementation ICityTouristAttractionsTableViewCell

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
    
    CGFloat margin = 10;
    CGFloat cellWidth = (kScreenWidth - margin*4)/3.0;
    CGFloat cellHeight = cellWidth * 149.0 / 112.0 + 50;
    
    CGRect collectionFrame = CGRectMake(0, 0, kScreenWidth, cellHeight + margin);
    
    ICityTouristAttractionsCollectionView *touristAttractionsCV = [[ICityTouristAttractionsCollectionView alloc] initWithFrame:collectionFrame collectionViewLayout:[UICollectionViewFlowLayout new]];
    self.touristAttractionsCV = touristAttractionsCV;
    __weak typeof(self) weakSelf = self;
    touristAttractionsCV.reuseSelectBlock = ^(NSString *selectID, ICityCultureModel *model) {
        if (weakSelf.reuseSelectBlock) {
            weakSelf.reuseSelectBlock(selectID, model);
        }
    };
    [self.contentView addSubview:touristAttractionsCV];
    
    [self applyTheme];
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    self.touristAttractionsCV.dataArray = dataArray;
}

@end
