//
//  ICityWeeklyReadCollectionViewCell.h
//  iCity
//
//  Created by 王磊 on 2018/4/27.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICityWeeklyReadModel.h"

#define ReadImg_w  ((kScreenWidth - 50)/3.0)
#define ReadImg_h  (ReadImg_w*144.0/108.0)

@interface ICityWeeklyReadCollectionViewCell : JstyleNewsBaseCollectionViewCell

@property (nonatomic, strong) ICityWeeklyReadModel *model;

- (void)setModel:(ICityWeeklyReadModel *)model isTop:(BOOL)istop;

@end
