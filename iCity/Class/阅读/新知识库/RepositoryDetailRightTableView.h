//
//  RepositoryDetailRightTableView.h
//  iCity
//
//  Created by mayonggang on 2018/6/22.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "JstyleNewsBaseTableView.h"

@interface RepositoryDetailRightTableView : JstyleNewsBaseTableView

@property (nonatomic, strong) NSArray *dataArray;

- (void)reloadDataWithDataArray:(NSArray *)dataArray;

@property (nonatomic, copy) void(^scrollDidScrollBlock)(NSString * str);

@end
