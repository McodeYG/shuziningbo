//
//  HotBooksCell.h
//  iCity
//
//  Created by mayonggang on 2018/6/14.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "JstyleNewsBaseTableViewCell.h"
#import "JstyleNewsHomeModel.h"

@interface HotBooksCell : JstyleNewsBaseTableViewCell

+(instancetype)initWithTableView:(UITableView *)tableView;


@property (nonatomic, strong) JstyleNewsHomePageModel * model;

@end
