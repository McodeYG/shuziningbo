//
//  JMLiveIntroduceModel.h
//  Exquisite
//
//  Created by 数字宁波 on 16/6/14.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMLiveIntroduceModel : NSObject

/**头像*/
@property (nonatomic, copy) NSString *cover_list;
/**视频占位图*/
@property (nonatomic, copy) NSString *cover_detail;
/**标题*/
@property (nonatomic, copy) NSString *name;
/**介绍*/
@property (nonatomic, copy) NSString *intro;
/**时间*/
@property (nonatomic, copy) NSString *ctime;
/**收藏次数*/
@property (nonatomic, copy) NSString *follow_num;
/**播放次数*/
@property (nonatomic, copy) NSString *play_num;
/**评论次数*/
@property (nonatomic, copy) NSString *comment_num;
/**评论内容*/
@property (nonatomic, copy) NSString *content;
/**高清视频*/
@property (nonatomic, copy) NSString *url_hd;
/**标清视频*/
@property (nonatomic, copy) NSString *url_sd;
/**视频播放状态*/
@property (nonatomic, copy) NSString *isvideo;


@end
