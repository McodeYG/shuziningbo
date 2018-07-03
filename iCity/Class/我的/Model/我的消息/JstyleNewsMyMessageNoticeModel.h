//
//  JstyleNewsMyMessageNoticeModel.h
//  JstyleNews
//
//  Created by 数字跃动 on 2017/10/30.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JstyleNewsMyMessageNoticeModel : NSObject

///1是发现的话题，2是发现投票，3是系统消息，4是发现测试，6是文章，7是视频，8是直播，9是活动
@property (nonatomic , copy) NSString *type;
///封面图
@property (nonatomic , copy) NSString *poster;
///创建时间
@property (nonatomic , copy) NSString *ctime;
///文章id or 视频id
@property (nonatomic , copy) NSString *id;
///标题（文章 or 视频）
@property (nonatomic , copy) NSString *title;
///图片数量
@property (nonatomic , copy) NSString *posternum;
///栏目名称
@property (nonatomic , copy) NSString *cname;
///1是图片集，2不是图片集
@property (nonatomic , copy) NSString *isImageArticle;
///视频 or 直播 URL
@property (nonatomic , copy) NSString *url_sd;
///文章详情content
@property (nonatomic , copy) NSString *content;
//1.VR.2普通
@property (nonatomic , copy) NSString *videoType;

@end
