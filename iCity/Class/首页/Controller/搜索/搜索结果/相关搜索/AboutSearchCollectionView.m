//
//  AboutSearchCollectionView.m
//  iCity
//
//  Created by mayonggang on 2018/6/13.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "AboutSearchCollectionView.h"
#import "JstyleNewsActivityWebViewController.h"
#import "AboutSearchCollectionViewCell.h"


@interface AboutSearchCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation AboutSearchCollectionView

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 0.5;
        _flowLayout.minimumInteritemSpacing = 0.5;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
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
        self.backgroundColor = kNightModeLineColor;
        self.scrollEnabled = NO;
        [self registerClass:[AboutSearchCollectionViewCell class] forCellWithReuseIdentifier:@"AboutSearchCollectionViewCell"];
        
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
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AboutSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AboutSearchCollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.row < self.dataArray.count) {
        cell.key = _key;
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
    SearchModel *model = self.dataArray[indexPath.row];
    JstyleNewsActivityWebViewController *webVC = [JstyleNewsActivityWebViewController new];
    webVC.urlString = model.url;
    webVC.navigationTitle = model.name;
    [self.viewController.navigationController pushViewController:webVC animated:YES];
}



@end
