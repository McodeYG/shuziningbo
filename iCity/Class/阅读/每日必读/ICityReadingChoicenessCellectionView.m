//
//  ICityReadingChoicenessCellectionView.m
//  iCity
//
//  Created by 王磊 on 2018/4/27.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityReadingChoicenessCellectionView.h"
#import "ICityReadingChoicenessCollectionViewCell.h"
#import "ICityLifeBannerModel.h"

static NSString *const ICityReadingChoicenessCollectionViewCellID = @"ICityReadingChoicenessCollectionViewCellID";

@interface ICityReadingChoicenessCellectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, assign) CGFloat offer;

@end

@implementation ICityReadingChoicenessCellectionView

#pragma mark - Property

- (UICollectionViewFlowLayout *)layout {
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemWidth = kScreenWidth - 30;    //670 *278
        _layout.itemSize = CGSizeMake(itemWidth, (kScreenWidth - 40)*190.0/335.0+20);
        _layout.minimumLineSpacing = 0.1;
        _layout.minimumInteritemSpacing = 0.1;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    }
    return _layout;
}

#pragma mark - CollectionView Init

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:self.layout]) {
        [self setupCollectionView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:NightModeManagerNotification object:nil];
    }
    return self;
}

- (void)setupCollectionView {
    
    
    self.backgroundColor = [UIColor redColor];
    self.delegate = self;
    self.dataSource = self;
//    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    //                                  上  左  下  右
    self.contentInset = UIEdgeInsetsMake(0, 10, 0, 0);
    self.decelerationRate = 10;
    self.bounces = NO;
    
    [self registerClass:[ICityReadingChoicenessCollectionViewCell class] forCellWithReuseIdentifier:ICityReadingChoicenessCollectionViewCellID];
    [self applyTheme];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.readingChoicenessDataArray.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ICityReadingChoicenessCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ICityReadingChoicenessCollectionViewCellID forIndexPath:indexPath];
    if (indexPath.item < self.readingChoicenessDataArray.count) {
        cell.model = self.readingChoicenessDataArray[indexPath.item];
        NSLog(@"%@--%@",self.readingChoicenessDataArray,cell.model.author_img);
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"每日必读跳转H5");
    if (self.readingBlock) {
        ICityLifeBannerModel *model = self.readingChoicenessDataArray[indexPath.item];
        self.readingBlock(model);
    }
}

- (void)setReadingChoicenessDataArray:(NSArray *)readingChoicenessDataArray {
    _readingChoicenessDataArray = readingChoicenessDataArray;
    
    [self reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    _offer = scrollView.contentOffset.x;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    if (fabs(scrollView.contentOffset.x -_offer) > 10) {
        
        if (scrollView.contentOffset.x > _offer) {
            
            int i = scrollView.contentOffset.x/([UIScreen mainScreen].bounds.size.width - 30)+1;
            
            NSIndexPath * index = [NSIndexPath indexPathForRow:i inSection:0];
            
            [self scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            
        }else{
            
            int i = scrollView.contentOffset.x/([UIScreen mainScreen].bounds.size.width - 30)+1;
            
            NSIndexPath * index = [NSIndexPath indexPathForRow:i-1 inSection:0];
            
            [self scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    if (fabs(scrollView.contentOffset.x -_offer) > 20) {
        
        if (scrollView.contentOffset.x > _offer) {
            
            int i = scrollView.contentOffset.x/([UIScreen mainScreen].bounds.size.width - 30)+1;
            
            NSIndexPath * index = [NSIndexPath indexPathForRow:i inSection:0];
            
            [self scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            
        }else{
            
            int i = scrollView.contentOffset.x/([UIScreen mainScreen].bounds.size.width - 30)+1;
            
            NSIndexPath * index = [NSIndexPath indexPathForRow:i-1 inSection:0];
            
            [self scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
    }
}

- (void)applyTheme {
    
    self.backgroundColor = kNightModeBackColor;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
