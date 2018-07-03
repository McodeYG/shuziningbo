//
//  JstyleLiveAllTalkModel.h
//  Exquisite
//
//  Created by 赵涛 on 16/10/11.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JstyleLiveAllTalkFatherModel : NSObject

/**一级评论头像*/
@property (nonatomic, copy) NSString *avator;
/**一级评论内容*/
@property (nonatomic, copy) NSString *content;
/**一级评论创建时间*/
@property (nonatomic, copy) NSString *ctime;
/**一级评论id*/
@property (nonatomic, copy) NSString *ID;
/**一级评论添加的图片*/
@property (nonatomic, copy) NSString *img;
/**一级评论的昵称*/
@property (nonatomic, copy) NSString *nick_name;
/**当前直播的id*/
@property (nonatomic, copy) NSString *vid;
/**一级评论的id*/
@property (nonatomic, copy) NSString *fid;
/**一级评论的商品url*/
@property (nonatomic, copy) NSString *goodsurl;

@property (nonatomic, assign) CGFloat whScale;

@end

@interface JstyleLiveAllTalkChildModel : NSObject

/**主播id*/
@property (nonatomic, copy) NSString *aid;
/**头像*/
@property (nonatomic, copy) NSString *avator;
/**内容*/
@property (nonatomic, copy) NSString *content;
/**创建时间*/
@property (nonatomic, copy) NSString *ctime;
/**id*/
@property (nonatomic, copy) NSString *ID;
/**二级评论添加的图片*/
@property (nonatomic, copy) NSString *img;
/**二级评论的昵称*/
@property (nonatomic, copy) NSString *nick_name;
/**二级评论的uid*/
@property (nonatomic, copy) NSString *uid;
/**当前直播的id*/
@property (nonatomic, copy) NSString *vid;
/**一级评论的数据*/
@property (nonatomic, strong) JstyleLiveAllTalkFatherModel *father;
/**一级评论的id*/
@property (nonatomic, copy) NSString *fid;

@property (nonatomic, assign) CGFloat whScale;

@end

