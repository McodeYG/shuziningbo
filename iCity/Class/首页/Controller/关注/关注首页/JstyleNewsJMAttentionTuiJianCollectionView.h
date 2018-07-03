//
//  JstyleNewsJMAttentionTuiJianCollectionView.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/3/28.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JstyleNewsJMAttentionTuiJianCollectionView : JstyleNewsBaseCollectionView

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
