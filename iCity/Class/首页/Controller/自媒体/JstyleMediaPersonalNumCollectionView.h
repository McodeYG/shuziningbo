//
//  JstyleMediaPersonalNumCollectionView.h
//  Exquisite
//
//  Created by 数字宁波 on 2017/8/29.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JstyleMediaPersonalNumCollectionView : JstyleNewsBaseCollectionView

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
