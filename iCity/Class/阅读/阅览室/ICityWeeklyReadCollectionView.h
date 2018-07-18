//
//  ICityWeeklyReadCollectionViewController.h
//  iCity
//
//  Created by 王磊 on 2018/4/28.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICityWeeklyReadCollectionViewCell.h"

@interface ICityWeeklyReadCollectionView : JstyleNewsBaseCollectionView



@property (nonatomic, copy) void(^weeklyReadCollectionViewBlock)(NSIndexPath *indexPath);

- (void)setDataArray:(NSArray *)dataArray isTop:(BOOL)isTop;
    
@end
