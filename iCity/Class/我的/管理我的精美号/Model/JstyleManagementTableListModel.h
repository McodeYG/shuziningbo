//
//  JstyleManagementTableListModel.h
//  Exquisite
//
//  Created by 数字跃动 on 2017/10/11.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JstyleManagementTableListModel : NSObject

///播出时间
@property (nonatomic, copy) NSString *air_time;
///VR直播地址
@property (nonatomic, copy) NSString *url;
///视频,普通直播地址
@property (nonatomic, copy) NSString *url_sd;
///封面图片地址
@property (nonatomic, copy) NSString *poster;
///主播名字
@property (nonatomic, copy) NSString *author;
///主播头像
@property (nonatomic, copy) NSString *avator;
///收藏数
@property (nonatomic, copy) NSString *follow_num;
///是否边看边买
@property (nonatomic, copy) NSString *is_open_buy;
///播放数
@property (nonatomic, copy) NSString *play_num;
///直播状态
@property (nonatomic, copy) NSString *isvideo;
///直播房间id
@property (nonatomic, copy) NSString *liveroomid;
///房间id
@property (nonatomic, copy) NSString *roomid;
///二级栏目
@property (nonatomic, copy) NSString *rname;
///标题
@property (nonatomic, copy) NSString *title;
///是否是图集
@property (nonatomic, copy) NSString *isImageArticle;
///阅读数
@property (nonatomic, copy) NSString *com_num;
///点赞数
@property (nonatomic, copy) NSString *praise_num;
///分享数
@property (nonatomic, copy) NSString *share_num;
///粉丝数
@property (nonatomic, copy) NSString *fans_num;
///评论数
@property (nonatomic, copy) NSString *comment_num;
///打赏积分
@property (nonatomic, copy) NSString *integral_num;
///观看数
@property (nonatomic, copy) NSString *see_num;
///id
@property (nonatomic, copy) NSString *id;

@end


//iCity号--我的消息
@interface JstyleManagementMyMessageModel : NSObject

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *result;

@property (nonatomic, copy) NSString *reason;

@property (nonatomic, copy) NSString *ctime;

@property (nonatomic, copy) NSString *vid;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *ID;

@end



