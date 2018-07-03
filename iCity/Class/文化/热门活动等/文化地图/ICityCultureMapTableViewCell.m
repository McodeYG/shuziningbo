//
//  ICityCultureMapTableViewCell.m
//  iCity
//
//  Created by 王磊 on 2018/5/1.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityCultureMapTableViewCell.h"
#import "ICityCultureMapCollectionView.h"

@interface ICityCultureMapTableViewCell()

@property (nonatomic, strong) ICityCultureMapCollectionView *cultureMapCV;

@end

@implementation ICityCultureMapTableViewCell

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
    
    ICityCultureMapCollectionView *cultureMapCV = [[ICityCultureMapCollectionView alloc] initWithFrame:collectionFrame collectionViewLayout:[UICollectionViewFlowLayout new]];
    self.cultureMapCV = cultureMapCV;
    __weak typeof(self) weakSelf = self;
    cultureMapCV.reuseSelectBlock = ^(NSString *selectID, ICityCultureModel *model) {
        if (weakSelf.reuseSelectBlock) {
            weakSelf.reuseSelectBlock(selectID, model);
        }
    };
    [self.contentView addSubview:cultureMapCV];
    
    [self applyTheme];
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    self.cultureMapCV.dataArray = dataArray;
}
@end
