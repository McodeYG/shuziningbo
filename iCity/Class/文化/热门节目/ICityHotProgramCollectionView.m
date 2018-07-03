//
//  ICityHotProgramCollectionViewController.m
//  iCity
//
//  Created by 王磊 on 2018/5/1.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityHotProgramCollectionView.h"
#import "ICityHotProgramCollectionViewCell.h"

static NSString * const ICityHotProgramCollectionViewCellID = @"ICityHotProgramCollectionViewCellID";
static CGFloat middleMargin = 5;
static CGFloat sideMargin = 8;

@interface ICityHotProgramCollectionView () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation ICityHotProgramCollectionView

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        
        CGFloat itemWidth = (kScreenWidth - sideMargin*2 - middleMargin)/ 2.0;
        _layout.itemSize = CGSizeMake(itemWidth, itemWidth * 111.0/177.0);
        _layout.minimumLineSpacing = middleMargin -1;
        _layout.minimumInteritemSpacing = middleMargin -1;
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
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
    [self setCollectionViewLayout:self.layout];
    self.backgroundColor = kNightModeBackColor;
    self.dataSource = self;
    self.delegate = self;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.scrollEnabled = NO;
    self.contentInset = UIEdgeInsetsMake(0, sideMargin, 0, sideMargin);
    [self registerClass:[ICityHotProgramCollectionViewCell class] forCellWithReuseIdentifier:ICityHotProgramCollectionViewCellID];
    
    [self applyTheme];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ICityHotProgramCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ICityHotProgramCollectionViewCellID forIndexPath:indexPath];
    cell.model = self.hotProgramArray[indexPath.item];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"跳转热门节目WebView");
    if (self.hotProgramClickBlock) {
        
        if (self.hotProgramArray.count>indexPath.row) {
            ICityHotProgramModel *model = self.hotProgramArray[indexPath.item];
            self.hotProgramClickBlock(model.id, model.url_sd);
        }
    }
}

- (void)setHotProgramArray:(NSArray *)hotProgramArray {
    _hotProgramArray = hotProgramArray;
    
    [self reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

@end
