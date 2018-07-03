//
//  SearchAboutPersonCollectionView.h
//  iCity
//
//  Created by mayonggang on 2018/6/13.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "JstyleNewsBaseCollectionView.h"

@interface SearchAboutPersonCollectionView : JstyleNewsBaseCollectionView

@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) CGRect rect;

@property (nonatomic, copy) NSString * key;

/**
 *  @frame: 外界传来的frame 即collectionView的大小
 *
 *  @itemSize: 即collectionViewCell上的Item大小
 *
 */
- (instancetype)initWithFrame:(CGRect)frame collectionViewItemSize:(CGSize)itemSize;

- (void)reloadDataWithDataArray:(NSArray *)dataArray;

@end
