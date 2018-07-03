//
//  ICityKnowledgeBaseCollectionView.m
//  iCity
//
//  Created by 王磊 on 2018/4/27.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityKnowledgeBaseCollectionView.h"
#import "ICityKnowledgeBaseCollectionViewCell.h"

static NSString *ICityKnowledgeBaseCollectionViewCellID = @"ICityKnowledgeBaseCollectionViewCellID";

@interface ICityKnowledgeBaseCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation ICityKnowledgeBaseCollectionView

- (void)setKnowledgeDataArray:(NSArray *)knowledgeDataArray {
    _knowledgeDataArray = knowledgeDataArray;
    
    [self reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake((kScreenWidth - 40)/3.0, (((kScreenWidth - 40)/3.0 * 70.0) / 112.0));
        _layout.minimumLineSpacing = 15;
        _layout.minimumInteritemSpacing = 9;
    }
    return _layout;
}

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:self.layout]) {
        [self setupCollection];
    }
    return self;
}

- (void)setupCollection {
    
    self.backgroundColor = kWhiteColor;
    self.dataSource = self;
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.scrollEnabled = NO;
    
    [self registerClass:[ICityKnowledgeBaseCollectionViewCell class] forCellWithReuseIdentifier:ICityKnowledgeBaseCollectionViewCellID];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.knowledgeDataArray.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ICityKnowledgeBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ICityKnowledgeBaseCollectionViewCellID forIndexPath:indexPath];
    if (indexPath.item < self.knowledgeDataArray.count) {    
        cell.model = self.knowledgeDataArray[indexPath.item];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"知识库详情");
    if (self.knowledgeSelectBlock) {
        self.knowledgeSelectBlock([self.knowledgeDataArray[indexPath.item] field_id]);
    }
}

@end
