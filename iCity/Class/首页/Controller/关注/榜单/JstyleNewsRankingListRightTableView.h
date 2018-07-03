//
//  JstyleNewsRankingListRightTableView.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/4/24.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JstyleNewsRankingListRightTableView : JstyleNewsBaseTableView

@property (nonatomic, strong) NSArray *dataArray;

- (void)reloadDataWithDataArray:(NSArray *)dataArray;

@end
