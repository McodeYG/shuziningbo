//
//  RepositoryCell.h
//  iCity
//
//  Created by mayonggang on 2018/6/14.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICityKnowledgeBaseModel.h"


@interface RepositoryCell : UITableViewCell

+(instancetype)initWithTableView:(UITableView *)tableView;



@property (nonatomic, strong) NSArray<ICityKnowledgeBaseModel *> *collcetionCatagroyArray;
@property (nonatomic, copy) void(^repositoryCellBlock)(NSString *title, NSString *selectID);

@property (nonatomic, copy) void(^refreshCellHeightBlock)(NSInteger cell_count);

@end
