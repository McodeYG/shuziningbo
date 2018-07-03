//
//  ICityPopularActivitiesTableViewCell.h
//  iCity
//
//  Created by 王磊 on 2018/5/1.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICityPopularActivitiesTableViewCell : JstyleNewsBaseTableViewCell

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, copy) void(^reuseSelectBlock)(NSString *selectID);

@end
