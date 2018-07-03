//
//  RepositoryDetailLeftTableView.h
//  iCity
//
//  Created by mayonggang on 2018/6/22.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "JstyleNewsBaseTableView.h"

@interface RepositoryDetailLeftTableView : JstyleNewsBaseTableView

@property (nonatomic, strong) NSArray *dataArray;

- (void)reloadDataWithDataArray:(NSArray *)dataArray;

@property (nonatomic, copy) void(^selectedIndex)(NSString *field_id);

@property (nonatomic, copy) NSString *selectID;

@end
