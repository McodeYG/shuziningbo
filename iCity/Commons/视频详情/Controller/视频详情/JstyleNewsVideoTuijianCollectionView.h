//
//  JstyleNewsVideoTuijianCollectionView.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/4.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JstyleNewsVideoTuijianCollectionView : JstyleNewsBaseCollectionView

@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) CGRect rect;

/**
 *  @frame: 外界传来的frame 即collectionView的大小
 *
 *  @itemSize: 即collectionViewCell上的Item大小
 *
 */
- (instancetype)initWithFrame:(CGRect)frame collectionViewItemSize:(CGSize)itemSize;

- (void)reloadDataWithDataArray:(NSArray *)dataArray;

@end
