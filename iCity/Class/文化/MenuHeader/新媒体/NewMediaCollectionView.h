//
//  NewMediaCollectionView.h
//  iCity
//
//  Created by mayonggang on 2018/6/15.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewMediaCollectionView : UICollectionView


- (instancetype)initWithFrame:(CGRect)frame collectionViewItemSize:(CGSize)itemSize;

- (void)reloadDataWithDataArray:(NSArray *)dataArray;

@end
