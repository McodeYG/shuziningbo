//
//  JMCommentModel.h
//  Exquisite
//
//  Created by 赵涛 on 16/5/26.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMCommentModel : NSObject

/**评论人的头像*/
@property (nonatomic, copy) NSString *avator;
/**评论人昵称*/
@property (nonatomic, copy) NSString *nick_name;
/**评论时间*/
@property (nonatomic, copy) NSString *ctime;
/**评论内容*/
@property (nonatomic, copy) NSString *content;
/**cid*/
@property (nonatomic, copy) NSString *cid;
/**用户id*/
@property (nonatomic, copy) NSString *userid;
/**types*/
@property (nonatomic, copy) NSString *types;
/**fid*/
@property (nonatomic, copy) NSString *fid;

@end
