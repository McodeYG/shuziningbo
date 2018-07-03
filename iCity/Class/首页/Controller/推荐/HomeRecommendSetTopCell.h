//
//  HomeRecommendSetTopCell.h
//  iCity
//
//  Created by mayonggang on 2018/6/4.
//  Copyright © 2018年 LongYuan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "JstyleNewsBaseTableViewCell.h"
#import "JstyleNewsHomeModel.h"

@interface HomeRecommendSetTopCell : JstyleNewsBaseTableViewCell

+ (instancetype)initWithTableView:(UITableView *)tableView;


- (void)setModel:(JstyleNewsHomePageModel *)model withIndex:(NSIndexPath *)index;

@end
