//
//  NewMediaCollectionView.m
//  iCity
//
//  Created by mayonggang on 2018/6/15.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "NewMediaCollectionView.h"
#import "NewMediaCollectionCell.h"
#import "JstyleNewsActivityWebViewController.h"
#import "JstyleNewsJMNumDetailsViewController.h"


@interface NewMediaCollectionView ()<UICollectionViewDelegate,
UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *dataArray;


@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGRect rect;

@end


@implementation NewMediaCollectionView

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //
        _flowLayout.minimumLineSpacing = 1.0;//最小间距
        _flowLayout.minimumInteritemSpacing = 0.1;//竖直方向最小间距
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 12, 0, 12);
    }
    return _flowLayout;
}


- (instancetype)initWithFrame:(CGRect)frame collectionViewItemSize:(CGSize)itemSize{
    _rect = frame;
    _itemSize = itemSize;
    if (self = [super initWithFrame:frame collectionViewLayout:self.flowLayout]) {
        self.pagingEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[NewMediaCollectionCell class] forCellWithReuseIdentifier:@"NewMediaCollectionCell"];
        
    }
    return self;
}

- (void)reloadDataWithDataArray:(NSArray *)dataArray
{
    self.dataArray = dataArray;
    [self reloadData];
    //[self setContentOffset:CGPointMake(0, 0)];
}


#pragma mark - UICollectionViewDelegate --- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return 10;
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewMediaCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewMediaCollectionCell" forIndexPath:indexPath];
    
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
    

    NewspaperModel *model = self.dataArray[indexPath.row];
    JstyleNewsJMNumDetailsViewController *jstylePersonalMediaVC = [JstyleNewsJMNumDetailsViewController new];
    jstylePersonalMediaVC.did = model.did;
    [self.viewController.navigationController pushViewController:jstylePersonalMediaVC animated:YES];
}

@end
