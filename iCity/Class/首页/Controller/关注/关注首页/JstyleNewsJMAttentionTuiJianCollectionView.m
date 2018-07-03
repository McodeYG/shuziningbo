//
//  JstyleNewsJMAttentionTuiJianCollectionView.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/3/28.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsJMAttentionTuiJianCollectionView.h"
#import "JstyleNewsJMAttentionTuiJianCollectionViewCell.h"
#import "JstyleNewsJMNumDetailsViewController.h"

@interface JstyleNewsJMAttentionTuiJianCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation JstyleNewsJMAttentionTuiJianCollectionView

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 0.0;
//        _flowLayout.minimumInteritemSpacing = 10.0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
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
        [self registerNib:[UINib nibWithNibName:@"JstyleNewsJMAttentionTuiJianCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"JstyleNewsJMAttentionTuiJianCollectionViewCell"];
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
    JstyleNewsJMAttentionTuiJianCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JstyleNewsJMAttentionTuiJianCollectionViewCell" forIndexPath:indexPath];
    
    __weak typeof(self)weakSelf = self;
    [cell setFocusBtnBlock:^(NSString *did) {
        [weakSelf addJstyleNewsJmNumsFocusOnWithDid:did indexPath:indexPath];
    }];
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
    JstyleNewsJMAttentionListModel *model = self.dataArray[indexPath.row];
    JstyleNewsJMNumDetailsViewController *jstylePersonalMediaVC = [JstyleNewsJMNumDetailsViewController new];
    jstylePersonalMediaVC.did = model.did;
    [self.viewController.navigationController pushViewController:jstylePersonalMediaVC animated:YES];
}

//关注iCity号
- (void)addJstyleNewsJmNumsFocusOnWithDid:(NSString *)did indexPath:(NSIndexPath *)indexPath
{
    if ([[JstyleToolManager sharedManager] isTourist]) {
        [[JstyleToolManager sharedManager] loginInViewController];
        return;
    }
    NSDictionary *parameters = @{@"platform_type":@"2",
                                 @"did":did,
                                 @"uid":[[JstyleToolManager sharedManager] getUserId]};
    [[JstyleNewsNetworkManager shareManager] GETURL:MANAGER_SUBSCRIPTION_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            NSString *followType = responseObject[@"data"][@"follow_type"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AttentionRefresh" object:nil userInfo:@{@"followType":[NSString stringWithFormat:@"%@",followType],@"did":[NSString stringWithFormat:@"%@",did]}];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end

