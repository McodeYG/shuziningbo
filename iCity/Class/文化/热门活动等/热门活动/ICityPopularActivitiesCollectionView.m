//
//  ICityPopularActivitiesCollectionView.m
//  iCity
//
//  Created by 王磊 on 2018/5/1.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityPopularActivitiesCollectionView.h"
#import "ICityPopularActivitiesCollectionViewCell.h"

static CGFloat margin = 10;
static NSString * const ICityPopularActivitiesCollectionViewCellID = @"ICityPopularActivitiesCollectionViewCellID";

@interface ICityPopularActivitiesCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation ICityPopularActivitiesCollectionView

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

    [self registerClass:[ICityPopularActivitiesCollectionViewCell class] forCellWithReuseIdentifier:ICityPopularActivitiesCollectionViewCellID];
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
    ICityPopularActivitiesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ICityPopularActivitiesCollectionViewCellID forIndexPath:indexPath];
    
    if (indexPath.item < self.dataArray.count) {
        cell.model = self.dataArray[indexPath.item];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.reuseSelectBlock) {
        if (indexPath.item < self.dataArray.count) {
            self.reuseSelectBlock([self.dataArray[indexPath.item] id]);
        }
    }
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    [self reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

@end
