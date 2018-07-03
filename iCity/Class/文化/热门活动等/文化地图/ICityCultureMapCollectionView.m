//
//  ICityCultureMapCollectionView.m
//  iCity
//
//  Created by 王磊 on 2018/5/1.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityCultureMapCollectionView.h"
#import "ICityCultureMapCollectionViewCell.h"

static CGFloat margin = 10;
static NSString * const ICityCultureMapCollectionViewCellID = @"ICityCultureMapCollectionViewCellID";

@interface ICityCultureMapCollectionView()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation ICityCultureMapCollectionView

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [UICollectionViewFlowLayout new];
        CGFloat cellWidth = (kScreenWidth - margin*4)/3.0;
        CGFloat cellHeight = cellWidth * 149.0 / 112.0 + 50;
        _layout.itemSize = CGSizeMake(cellWidth, cellHeight);
        _layout.minimumLineSpacing = margin-1;
        _layout.minimumInteritemSpacing = margin-1;
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupCollectionView];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:self.layout]) {
        [self setupCollectionView];
    }
    return self;
}

- (void)setupCollectionView {
    
    [self setCollectionViewLayout:self.layout];
    self.backgroundColor = kWhiteColor;
    
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.scrollEnabled = NO;
    self.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.dataSource = self;
    self.delegate = self;

    [self registerClass:[ICityCultureMapCollectionViewCell class] forCellWithReuseIdentifier:ICityCultureMapCollectionViewCellID];
    
    [self applyTheme];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ICityCultureMapCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ICityCultureMapCollectionViewCellID forIndexPath:indexPath];
    
    if (indexPath.item < self.dataArray.count) {
        cell.model = self.dataArray[indexPath.item];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.reuseSelectBlock) {
        if (indexPath.item < self.dataArray.count) {
            self.reuseSelectBlock([self.dataArray[indexPath.item] field_id], self.dataArray[indexPath.item]);
        }
    }
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    [self reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

@end
