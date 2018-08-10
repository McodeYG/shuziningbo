//
//  JstyleMediaPersonalNumCollectionView.m
//  Exquisite
//
//  Created by 数字宁波 on 2017/8/29.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleMediaPersonalNumCollectionView.h"
#import "JstylePersonalMediaSquareViewCell.h"
#import "JstyleNewsJMNumDetailsViewController.h"

@interface JstyleMediaPersonalNumCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation JstyleMediaPersonalNumCollectionView

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
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
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            self.scrollIndicatorInsets = self.contentInset;
        }
        [self registerNib:[UINib nibWithNibName:@"JstylePersonalMediaSquareViewCell" bundle:nil] forCellWithReuseIdentifier:@"JstylePersonalMediaSquareViewCell"];
    }
    return self;
}

- (void)reloadDataWithDataArray:(NSArray *)dataArray
{
    self.dataArray = dataArray;
    [self reloadData];
    [self setContentOffset:CGPointMake(0, 0)];
}

#pragma mark - UICollectionViewDelegate --- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JstylePersonalMediaSquareViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JstylePersonalMediaSquareViewCell" forIndexPath:indexPath];
    
    if (indexPath.row < self.dataArray.count) {
        cell.model = self.dataArray[indexPath.row];
    }
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return _itemSize;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:(UICollectionViewScrollPositionNone)];
    JstylePersonalMediaListModel *model = self.dataArray[indexPath.row];
    JstyleNewsJMNumDetailsViewController *jstylePersonalMediaVC = [JstyleNewsJMNumDetailsViewController new];
    jstylePersonalMediaVC.did = model.did;
    [[self viewController].navigationController pushViewController:jstylePersonalMediaVC animated:YES];
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


@end
