//
//  JMHomeMessageModel.h
//  Exquisite
//
//  Created by 数字宁波 on 16/7/5.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * 我的消息home页model
 */
@interface JMMyMsgTradingRemindModel : NSObject

/**消息时间*/
@property (nonatomic, copy) NSString *ctime;
/**消息id*/
@property (nonatomic, copy) NSString *ID;
/**消息文字信息*/
@property (nonatomic, copy) NSString *msg;
/**消息状态*/
@property (nonatomic, copy) NSString *status;
/**消息类型*/
@property (nonatomic, copy) NSString *type;
/**用户uid*/
@property (nonatomic, copy) NSString *uid;

@end

/**
 * 交易提醒
 */
@interface JMTradingRemindModel : NSObject

/**消息时间*/
@property (nonatomic, copy) NSString *ctime;
/**消息id*/
@property (nonatomic, copy) NSString *ID;
/**消息文字信息*/
@property (nonatomic, copy) NSString *msg;
/**消息状态*/
@property (nonatomic, copy) NSString *status;
/**消息类型*/
@property (nonatomic, copy) NSString *type;
/**用户uid*/
@property (nonatomic, copy) NSString *uid;

@end

/**
 * 物流提醒
 */
@interface JMLogisticsRemindModel : NSObject

/**消息时间*/
@property (nonatomic, copy) NSString *ctime;
/**消息id*/
@property (nonatomic, copy) NSString *ID;
/**消息文字信息*/
@property (nonatomic, copy) NSString *msg;
/**消息状态*/
@property (nonatomic, copy) NSString *status;
/**消息类型*/
@property (nonatomic, copy) NSString *type;
/**用户uid*/
@property (nonatomic, copy) NSString *uid;
/**商品图片*/
@property (nonatomic, copy) NSString *imgurl;

@end

/**
 * 系统提醒
 */
@interface JMSystemRemindModel : NSObject

/**消息时间*/
@property (nonatomic, copy) NSString *ctime;
/**消息id*/
@property (nonatomic, copy) NSString *ID;
/**消息文字信息*/
@property (nonatomic, copy) NSString *msg;
/**消息状态*/
@property (nonatomic, copy) NSString *status;
/**消息类型*/
@property (nonatomic, copy) NSString *type;
/**用户uid*/
@property (nonatomic, copy) NSString *uid;
/**用户msgurl*/
@property (nonatomic, copy) NSString *msgurl;
/**图片*/
@property (nonatomic, copy) NSString *imgurl;
/**文章分享链接*/
@property (nonatomic, copy) NSString *ashareurl;
@property (nonatomic, copy) NSString *describes;

@property (nonatomic, copy) NSString *title;
@end


/**
 * 直播提醒
 */
@interface JMLiveRemindModel : NSObject

/**消息时间*/
@property (nonatomic, copy) NSString *ctime;
/**消息id*/
@property (nonatomic, copy) NSString *ID;
/**消息文字信息*/
@property (nonatomic, copy) NSString *msg;
/**消息状态*/
@property (nonatomic, copy) NSString *status;
/**消息类型*/
@property (nonatomic, copy) NSString *type;
/**用户uid*/
@property (nonatomic, copy) NSString *uid;
/**用户msgurl*/
@property (nonatomic, copy) NSString *msgurl;
/**图片*/
@property (nonatomic, copy) NSString *imgurl;
/**文章分享链接*/
@property (nonatomic, copy) NSString *ashareurl;
@property (nonatomic, copy) NSString *describes;

@property (nonatomic, copy) NSString *title;
@end

/**
 * 其它提醒
 */
@interface JMOtherRemindModel : NSObject

/**消息时间*/
@property (nonatomic, copy) NSString *ctime;
/**消息id*/
@property (nonatomic, copy) NSString *ID;
/**消息文字信息*/
@property (nonatomic, copy) NSString *msg;
/**消息状态*/
@property (nonatomic, copy) NSString *status;
/**消息类型*/
@property (nonatomic, copy) NSString *type;
/**用户uid*/
@property (nonatomic, copy) NSString *uid;

@end




