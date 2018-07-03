//
//  JstyleNewsMyCollectionModel.h
//  JstyleNews
//
//  Created by 数字跃动 on 2017/12/22.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JstyleNewsMyCollectionModel : NSObject

///封面图
@property (nonatomic, copy) NSString *poster;
///视频播放地址
@property (nonatomic, copy) NSString *url_sd;
///视频或文章id
@property (nonatomic, copy) NSString *id;
///标题
@property (nonatomic, copy) NSString *title;
///栏目名称
@property (nonatomic, copy) NSString *cname;
///是否是图集
@property (nonatomic, copy) NSString *isImageArticle;
///播放量
@property (nonatomic, copy) NSString *play_num;
///自媒体头像
@property (nonatomic, copy) NSString *author_img;
///自媒体id
@property (nonatomic, copy) NSString *author_did;
///自媒体名称
@property (nonatomic, copy) NSString *author_name; 
//视频类型
@property (nonatomic, copy) NSString *videoType;

/**h5*/
@property (nonatomic, copy) NSString *content;
///栏目名称
@property (nonatomic, copy) NSString *ctime;
//足迹时间（收藏、阅读）
@property (nonatomic, copy) NSString *action_time;
@property (nonatomic, copy) NSString *isShowAuthor;
//标签
@property (nonatomic, copy) NSString *torFOriginal;
@property (nonatomic, copy) NSString *TOrFOriginal;



@end
