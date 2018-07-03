//
//  JstyleManagementCommentModel.h
//  Exquisite
//
//  Created by 数字跃动 on 2017/10/13.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JstyleManagementCommentModel : NSObject

///内容
@property (nonatomic, copy) NSString *content;
///评论时间
@property (nonatomic, copy) NSString *ctime;
///头像
@property (nonatomic, copy) NSString *avator;
///用户uid
@property (nonatomic, copy) NSString *uid;
///文章标题
@property (nonatomic, copy) NSString *title;
///昵称
@property (nonatomic, copy) NSString *nick_name;
///id
@property (nonatomic, copy) NSString *id;
///地址
@property (nonatomic, copy) NSString *address;
///文章图片
@property (nonatomic, copy) NSString *poster;

@end
