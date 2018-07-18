//
//  ICityWeeklyReadCollectionViewController.m
//  iCity
//
//  Created by 王磊 on 2018/4/28.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityWeeklyReadCollectionView.h"

#import "ICityWeeklyReadModel.h"

static NSString *const ICityWeeklyReadCollectionViewCellID = @"ICityWeeklyReadCollectionViewCellID";

@interface ICityWeeklyReadCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
//数据源
@property (nonatomic, strong) NSArray *dataArray;
/**是否是顶部的*/
@property (nonatomic, assign) BOOL isTop;

@end

@implementation ICityWeeklyReadCollectionView

#pragma mark - Propertys

- (void)setDataArray:(NSArray *)dataArray isTop:(BOOL)isTop{
    _dataArray = dataArray;
    _isTop = isTop;
    [self reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake(ReadImg_w, ReadImg_h+71);
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.minimumLineSpacing = 10;//滑动方向间距
        _layout.minimumInteritemSpacing = 0.01;
        _layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    return _layout;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:self.layout]) {
        [self setupCollectionView];
    }
    return self;
}

- (void)setupCollectionView {
    
    self.backgroundColor = kNightModeBackColor;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.scrollEnabled = YES;
    self.delegate = self;
    self.dataSource = self;
    
    
    [self registerClass:[ICityWeeklyReadCollectionViewCell class] forCellWithReuseIdentifier:ICityWeeklyReadCollectionViewCellID];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ICityWeeklyReadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ICityWeeklyReadCollectionViewCellID forIndexPath:indexPath];
    if (indexPath.item < self.dataArray.count) {
        //赋值
        [cell setModel:self.dataArray[indexPath.item] isTop:_isTop];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"每周必读跳转H5");
    
    if (self.weeklyReadCollectionViewBlock) {
        self.weeklyReadCollectionViewBlock(indexPath);
    }
}




@end
