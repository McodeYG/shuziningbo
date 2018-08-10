//
//  JMMyFootPrintModel.h
//  Exquisite
//
//  Created by 数字宁波 on 16/6/15.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 商品model
 */
@interface JMMyFootPrintGoodsModel : NSObject

/**封面:图片*/
@property (nonatomic, copy) NSString *poster;
/**内容*/
@property (nonatomic, copy) NSString *comments;
/**标题*/
@property (nonatomic, copy) NSString *gname;
/**创建时间*/
@property (nonatomic, copy) NSString *ctime;
/**结束时间*/
@property (nonatomic, copy) NSString *etime;
/**价格*/
@property (nonatomic, copy) NSString *sale_price;
/**商品id*/
@property (nonatomic, copy) NSString *gid;
/**自增id*/
@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *nums;
/**商品是否失效*/
@property (nonatomic, copy) NSString *upstatus;
/**商品是否亿售完*/
@property (nonatomic, copy) NSString *numstatus;

@end

/**
 * 资讯model
 */
@interface JMMyFootPrintZixunModel : NSObject

/**封面:图片*/
@property (nonatomic, copy) NSString *poster;
/**内容描述*/
@property (nonatomic, copy) NSString *describes;
/**标题*/
@property (nonatomic, copy) NSString *title;
/**创建时间*/
@property (nonatomic, copy) NSString *ctime;
/**资讯id*/
@property (nonatomic, copy) NSString *sid;
/**自增id*/
@property (nonatomic, copy) NSString *ID;
/**文章详情分享链接*/
@property (nonatomic, copy) NSString *ashareurl;
/**是否图集*/
@property (nonatomic, copy) NSString *isimagearticle;
/**是否是VIP*/
@property (nonatomic, copy) NSString *is_vip;

@end


/**
 * 点播model
 */
@interface JMMyFootPrintDianboModel : NSObject

@property (nonatomic, copy) NSString *poster;
/**内容介绍*/
@property (nonatomic, copy) NSString *intro;
/**创建时间*/
@property (nonatomic, copy) NSString *ctime;
/**标清视频*/
@property (nonatomic, copy) NSString *url_sd;
/**商品id*/
@property (nonatomic, copy) NSString *gid;
/**自增id*/
@property (nonatomic, copy) NSString *ID;
/**视频名字*/
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *numstatus;
/**直播聊天室房间号*/
@property (nonatomic, copy) NSString *roomid;
/**直播房间号*/
@property (nonatomic, copy) NSString *liveroomid;
/**判断状态*/
@property (nonatomic, copy) NSString *isvideo;

@property (nonatomic, copy) NSString *sale_price;

@property (nonatomic, copy) NSString *time_length;

@end


