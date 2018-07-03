//
//  SearchImageArticleCell.h
//  iCity
//
//  Created by mayonggang on 2018/6/12.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "JstyleNewsBaseTableViewCell.h"
#import "SearchModel.h"

@interface SearchImageArticleCell : JstyleNewsBaseTableViewCell


+(instancetype)initWithTableView:(UITableView *)tableView;

/**模型*/
@property (nonatomic, strong) SearchModel * model;



@end
