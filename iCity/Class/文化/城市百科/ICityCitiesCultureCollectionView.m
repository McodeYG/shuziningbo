//
//  ICityCitiesCultureCollectionView.m
//  iCity
//
//  Created by 王磊 on 2018/5/1.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityCitiesCultureCollectionView.h"
#import "ICityCitiesCultureCollectionViewCell.h"

static CGFloat middleMargin = 15;
static CGFloat sideMargin = 10;

static NSString * const ICityCitiesCultureCollectionViewCellID = @"ICityCitiesCultureCollectionViewCellID";

@interface ICityCitiesCultureCollectionView() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation ICityCitiesCultureCollectionView

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [UICollectionViewFlowLayout new];
        CGFloat cellWidth = (kScreenWidth - sideMargin*4)/3.0;
        CGFloat cellHeight = cellWidth *70.0 / 112.0;
        _layout.itemSize = CGSizeMake(cellWidth, cellHeight);
        _layout.minimumLineSpacing = middleMargin-1;
        _layout.minimumInteritemSpacing = sideMargin-1;
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:self.layout]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    [self setCollectionViewLayout:self.layout];
    self.backgroundColor = kWhiteColor;
    self.dataSource = self;
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.scrollEnabled = NO;
    self.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    [self registerClass:[ICityCitiesCultureCollectionViewCell class] forCellWithReuseIdentifier:ICityCitiesCultureCollectionViewCellID];
    [self applyTheme];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ICityCitiesCultureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ICityCitiesCultureCollectionViewCellID forIndexPath:indexPath];
    if (indexPath.item < self.citiesCultureDataArray.count) {
        cell.model = self.citiesCultureDataArray[indexPath.item];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.citiesCultureSelectBlock) {
        if (indexPath.item < self.citiesCultureDataArray.count) {
            
            ICityKnowledgeBaseModel * model = self.citiesCultureDataArray[indexPath.item];
            self.citiesCultureSelectBlock(model.id,model.name);
        }
    }
}

- (void)setCitiesCultureDataArray:(NSArray *)citiesCultureDataArray {
    _citiesCultureDataArray = citiesCultureDataArray;
    
    [self reloadSections:[NSIndexSet indexSetWithIndex:0]];
}



@end
