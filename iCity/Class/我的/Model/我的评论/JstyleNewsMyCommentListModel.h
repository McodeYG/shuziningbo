//
//  JstyleNewsMyCommentListModel.h
//  JstyleNews
//
//  Created by 数字跃动 on 2017/12/25.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JstyleNewsMyCommentListModel : NSObject

///昵称
@property (nonatomic, copy) NSString *nick_name;
///发评论的时间
@property (nonatomic, copy) NSString *ctime;
///id
@property (nonatomic, copy) NSString *id;
///标题
@property (nonatomic, copy) NSString *title;
///url
@property (nonatomic, copy) NSString *url_sd;
///类型（1是文章，2是视频，3是发现
@property (nonatomic, copy) NSString *type;
///发现类型
@property (nonatomic, copy) NSString *find_type;
///头像
@property (nonatomic, copy) NSString *avator;
///评论内容
@property (nonatomic, copy) NSString *content;

@end
