//
//  JstyleNewsMyCommentTableViewCell.h
//  JstyleNews
//
//  Created by 数字跃动 on 2017/10/25.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsMyCommentListModel.h"

@interface JstyleNewsMyCommentTableViewCell : JstyleNewsBaseTableViewCell

///点击文章标题跳转Block
@property (nonatomic, copy) void(^titleTapBlock)();

@property (nonatomic, strong) JstyleNewsMyCommentListModel *model;

@end
