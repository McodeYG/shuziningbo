//
//  JMLiveHomeModel.h
//  Exquisite
//
//  Created by 数字宁波 on 16/6/8.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMLiveHomeModel : NSObject

/**图片*/
@property (nonatomic, copy) NSString *headimg;
/**直播列表封面:图片*/
@property (nonatomic, copy) NSString *cover_list;
/**直播内容*/
@property (nonatomic, copy) NSString *intro;
/**直播标题*/
@property (nonatomic, copy) NSString *name;
/**阅读数*/
@property (nonatomic, copy) NSString *share_num;
/**收藏数*/
@property (nonatomic, copy) NSString *follows_num;
/**播放数*/
@property (nonatomic, copy) NSString *play_num;
/**内容是否推荐到首页（0,不推到首页,  1推送到首页)*/
@property (nonatomic, copy) NSString *ishome;
/**创建时间*/
@property (nonatomic, copy) NSString *ctime;
/**直播id*/
@property (nonatomic, copy) NSString *ID;
/**排序*/
@property (nonatomic, copy) NSString *torder;
/**类型*/
@property (nonatomic, copy) NSString *type;
/**视频地址*/
@property (nonatomic, copy) NSString *url_hd;
/**标清地址*/
@property (nonatomic, copy) NSString *url_sd;
/**直播状态*/
@property (nonatomic, copy) NSString *status;
/**开播时间*/
@property (nonatomic, copy) NSString *air_time;
/**判断视频类型*/
@property (nonatomic, copy) NSString *isvideo;
/**是否有边看边买*/
@property (nonatomic, copy) NSString *is_open_buy;

@property (nonatomic, copy) NSString *aurl;

/**房间聊天室roomid*/
@property (nonatomic, copy) NSString *roomid;

/**直播房间号liveroomid*/
@property (nonatomic, copy) NSString *liveroomid;

/**是否已经点击提醒我*/
@property (nonatomic, copy) NSString *is_remind;

/**直播界面的头像*/
@property (nonatomic, copy) NSString *albumimg;
/**分享链接*/
@property (nonatomic, copy) NSString *vshareurl;
/**系列名字*/
@property (nonatomic, copy) NSString *aname;
/**专辑图片*/
@property (nonatomic, copy) NSString *bgimg;
/**iCity号名字*/
@property (nonatomic, copy) NSString *author;
///
@property (nonatomic, copy) NSString *is_vip;

@end
