//
//  JMStarHomeModel.h
//  Exquisite
//
//  Created by 赵涛 on 16/6/8.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMStarHomeModel : NSObject

/**文章列表封面:图片*/
@property (nonatomic, copy) NSString *poster;
/**文章内容*/
@property (nonatomic, copy) NSString *rname;
/**文章标题*/
@property (nonatomic, copy) NSString *rtitle;
/**阅读数*/
@property (nonatomic, copy) NSString *share_num;
/**收藏数*/
@property (nonatomic, copy) NSString *follows_num;
/**内容是否推荐到首页（0,不推到首页,  1推送到首页)*/
@property (nonatomic, copy) NSString *ishome;
/**创建时间*/
@property (nonatomic, copy) NSString *ctime;
/**文章的id*/
@property (nonatomic, copy) NSString *rid;
/**栏目的id*/
@property (nonatomic, copy) NSString *cid;
/**id*/
@property (nonatomic, copy) NSString *ID;
/**排序*/
@property (nonatomic, copy) NSString *torder;
/**类型*/
@property (nonatomic, copy) NSString *type;
/**文章分享链接*/
@property (nonatomic, copy) NSString *ashareurl;
/**文章内容*/
@property (nonatomic, copy) NSString *describes;
@end
