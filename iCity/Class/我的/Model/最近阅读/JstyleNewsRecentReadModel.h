//
//  JstyleNewsRecentReadModel.h
//  JstyleNews
//
//  Created by 数字跃动 on 2017/12/12.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JstyleNewsRecentReadModel : NSObject

///播放地址
@property (nonatomic, copy) NSString *url_sd;
///封面图
@property (nonatomic, copy) NSString *poster;
///标题
@property (nonatomic, copy) NSString *title;
///播放量
@property (nonatomic, copy) NSString *play_num;
///栏目名称
@property (nonatomic, copy) NSString *cname;
///id
@property (nonatomic, copy) NSString *id;
///自媒体头像
@property (nonatomic, copy) NSString *author_img;
///自媒体id
@property (nonatomic, copy) NSString *author_did;
///自媒体名称
@property (nonatomic, copy) NSString *author_name;
@property (nonatomic, copy) NSString *action_time;

@end
