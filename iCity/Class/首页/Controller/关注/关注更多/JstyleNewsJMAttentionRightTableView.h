//
//  JstyleNewsJMAttentionRightTableView.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/4/2.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JstyleNewsJMAttentionRightTableView : JstyleNewsBaseTableView

@property (nonatomic, strong) NSArray *dataArray;

- (void)reloadDataWithDataArray:(NSArray *)dataArray;

@property (nonatomic, copy) void(^scrollDidScrollBlock)();

@end
