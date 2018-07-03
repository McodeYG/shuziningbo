//
//  ICityWeeklyReadTableViewCell.h
//  iCity
//
//  Created by 王磊 on 2018/4/27.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICityWeeklyReadCollectionView.h"

@interface ICityWeeklyReadTableViewCell : JstyleNewsBaseTableViewCell

@property (nonatomic, strong) NSArray *topDataArray;
@property (nonatomic, strong) NSArray *bottomDataArray;

@property (nonatomic, copy) void(^topReadCellBlock)(NSIndexPath *indexPath);

@property (nonatomic, copy) void(^bottomReadCellBlock)(NSIndexPath *indexPath);

@end
