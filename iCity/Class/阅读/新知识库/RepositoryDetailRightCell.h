//
//  RepositoryDetailRightCell.h
//  iCity
//
//  Created by mayonggang on 2018/6/22.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "JstyleNewsBaseTableViewCell.h"
#import "SearchModel.h"

@interface RepositoryDetailRightCell : JstyleNewsBaseTableViewCell


+(instancetype)initWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) SearchModel *model;

@property (nonatomic, copy) void(^focusBlock)(NSString *did);


@end
