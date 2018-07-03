//
//  ICityCitiesCultureTableViewCell.m
//  iCity
//
//  Created by 王磊 on 2018/5/1.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityCitiesCultureTableViewCell.h"
#import "ICityCitiesCultureCollectionView.h"

@interface ICityCitiesCultureTableViewCell()

@property (nonatomic, strong) ICityCitiesCultureCollectionView *citiesCultureCV;

@end

@implementation ICityCitiesCultureTableViewCell

-(void)awakeFromNib {
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
    self.backgroundColor = kWhiteColor;
    
    CGFloat middleMargin = 15;
    CGFloat sideMargin = 10;
    CGFloat cellWidth = (kScreenWidth - sideMargin*4)/3.0;
    CGFloat cellHeight = cellWidth * 70.0/ 112.0;
    
    CGRect collectionFrame = CGRectMake(0, 0, kScreenWidth, cellHeight*2 + middleMargin);
    
    ICityCitiesCultureCollectionView *citiesCultureCV = [[ICityCitiesCultureCollectionView alloc] initWithFrame:collectionFrame collectionViewLayout:[UICollectionViewFlowLayout new]];
    self.citiesCultureCV = citiesCultureCV;
    __weak typeof(self) weakSelf = self;
    citiesCultureCV.citiesCultureSelectBlock = ^(NSString *selectID, NSString *title) {
        if (weakSelf.citiesCultureSelectBlock) {
            weakSelf.citiesCultureSelectBlock(selectID ,title);
        }
    };
    [self.contentView addSubview:citiesCultureCV];
    
}

- (void)setCitiesCultureDataArray:(NSArray *)citiesCultureDataArray {
    _citiesCultureDataArray = citiesCultureDataArray;
    
    self.citiesCultureCV.citiesCultureDataArray = citiesCultureDataArray;
}

@end
