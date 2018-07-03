//
//  JstyleManagementPingLunCell.h
//  Exquisite
//
//  Created by 数字跃动 on 2017/10/11.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleManagementCommentModel.h"

@interface JstyleManagementPingLunCell : JstyleNewsBaseTableViewCell

@property (nonatomic, strong) JstyleManagementCommentModel *model;

///点击文章标题跳转Block
@property (nonatomic, copy) void(^titleTapBlock)();

@end
