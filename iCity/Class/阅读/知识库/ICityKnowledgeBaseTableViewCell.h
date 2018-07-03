//
//  ICityKnowledgeBaseTableViewCell.h
//  iCity
//
//  Created by 王磊 on 2018/4/27.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICityKnowledgeBaseTableViewCell : UITableViewCell

@property (nonatomic, copy) void(^knowledgeSelectBlock)(NSString *selectID);

@property (nonatomic, strong) NSArray *knowledgeDataArray;

@end
