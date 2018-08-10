//
//  JstyleLiveAnchorTalkModel.h
//  Exquisite
//
//  Created by 数字宁波 on 16/10/11.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JstyleLiveAnchorTalkModel : NSObject

/**主播的id*/
@property (nonatomic, copy) NSString *aid;
/**主播的头像*/
@property (nonatomic, copy) NSString *head_img;
/**主播发的内容*/
@property (nonatomic, copy) NSString *content;
/**创建时间*/
@property (nonatomic, copy) NSString *ctime;
/**主播评论的id*/
@property (nonatomic, copy) NSString *ID;
/**主播评论的图片*/
@property (nonatomic, copy) NSString *img;
/**主播的昵称*/
@property (nonatomic, copy) NSString *nick_name;
/**当前直播的视频id*/
@property (nonatomic, copy) NSString *vid;
/**主播评论的id*/
@property (nonatomic, copy) NSString *fid;
/**商品的链接*/
@property (nonatomic, copy) NSString *goodsurl;

@property (nonatomic, assign) CGFloat whScale;

@end
