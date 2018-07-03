//
//  JstyleNewsArticleDetailTuijianCollectionView.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/29.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsArticleDetailTuijianCollectionView.h"
#import "JstyleNewsArticleDetailTuijianCollectionCell.h"
#import "JstyleNewsArticleDetailViewController.h"

@interface JstyleNewsArticleDetailTuijianCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation JstyleNewsArticleDetailTuijianCollectionView

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //_flowLayout.minimumLineSpacing = 15.0;
        _flowLayout.minimumInteritemSpacing = 10.0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    }
    return _flowLayout;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewItemSize:(CGSize)itemSize withDataArray:(NSArray *)dataArray{
    _rect = frame;
    _itemSize = itemSize;
    if (self = [super initWithFrame:frame collectionViewLayout:self.flowLayout]) {
        _dataArray = dataArray;
        self.pagingEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"JstyleNewsArticleDetailTuijianCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"JstyleNewsArticleDetailTuijianCollectionCell"];
    }
    return self;
}

- (void)reloadDataWithDataArray:(NSArray *)dataArray
{
    self.dataArray = dataArray;
    [self reloadData];
//    [self setContentOffset:CGPointMake(0, 0)];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewItemSize:(CGSize)itemSize{
    _rect = frame;
    _itemSize = itemSize;
    if (self = [super initWithFrame:frame collectionViewLayout:self.flowLayout]) {
        self.pagingEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"JstyleNewsArticleDetailTuijianCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"JstyleNewsArticleDetailTuijianCollectionCell"];
    }
    return self;
}

#pragma mark - UICollectionViewDelegate --- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JstyleNewsArticleDetailTuijianCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JstyleNewsArticleDetailTuijianCollectionCell" forIndexPath:indexPath];
    
    if (indexPath.row < self.dataArray.count) {
        cell.model = self.dataArray[indexPath.row];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return _itemSize;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:(UICollectionViewScrollPositionNone)];
    if (indexPath.row < self.dataArray.count) {\
        JstyleNewsArticleDetailTuijianModel *model = self.dataArray[indexPath.row];
        JstyleNewsArticleDetailViewController *jstyleNewsArticleDVC = [JstyleNewsArticleDetailViewController new];
        jstyleNewsArticleDVC.rid = model.id;
        [self.viewController.navigationController pushViewController:jstyleNewsArticleDVC animated:YES];
    }
}

@end

