//
//  JstyleNewsAdvertisementModel.h
//  JstyleNews
//
//  Created by 数字跃动 on 2018/1/9.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JstyleNewsAdvertisementModel : NSObject

///H5链接
@property (nonatomic, copy) NSString *h5url;
///视频播放地址
@property (nonatomic, copy) NSString *url_sd;
///1.文章；2.视频；3.直播
@property (nonatomic, copy) NSString *banner_type;
///是否是图片集；1.是；2.否
@property (nonatomic, copy) NSString *isImageArticle;
///适配iphoneX 封面
@property (nonatomic, copy) NSString *welcome_iphonexImg;
///广告id
@property (nonatomic, copy) NSString *id;
///标题
@property (nonatomic, copy) NSString *title;
///文章id/视频id
@property (nonatomic, copy) NSString *rid;
///封面
@property (nonatomic, copy) NSString *poster;
/**是否分享 (0不显示 1显示)*/
@property (nonatomic, copy) NSString *isShare;

@property (nonatomic, copy) NSString *content;

/**注释*/
@property (nonatomic, copy) NSString * videoType;

@end
