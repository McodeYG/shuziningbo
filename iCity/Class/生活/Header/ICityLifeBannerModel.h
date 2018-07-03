//
//  ICityLifeBannerModel.h
//  iCity
//
//  Created by 王磊 on 2018/4/28.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICityLifeBannerModel : NSObject

@property (nonatomic , copy) NSString *url_sd;
@property (nonatomic , copy) NSString *ctime;
@property (nonatomic , copy) NSString *poster;
@property (nonatomic , copy) NSString *article_poster;
@property (nonatomic , copy) NSArray  *poster_imgs;
@property (nonatomic , copy) NSString *id;
@property (nonatomic , copy) NSString *title;
@property (nonatomic , copy) NSString *cname;
@property (nonatomic , copy) NSString *type;
@property (nonatomic , copy) NSString *video_type;
@property (nonatomic , copy) NSString *cid;
@property (nonatomic , copy) NSString *head_type;
@property (nonatomic , copy) NSString *isImageArticle;
@property (nonatomic , copy) NSString *posternum;
@property (nonatomic , copy) NSString *timestamp;

@property (nonatomic , copy) NSString *banner_type;
@property (nonatomic , copy) NSString *h5url;
@property (nonatomic , copy) NSString *rid;
@property (nonatomic , copy) NSString *play_num;
@property (nonatomic , copy) NSString *content;

@property (nonatomic , copy) NSString *isShowAuthor;
@property (nonatomic , copy) NSString *author_img;
@property (nonatomic , copy) NSString *author_did;
@property (nonatomic , copy) NSString *author_name;
@property (nonatomic , copy) NSString *TOrFOriginal;

@property (nonatomic , copy) NSString *ashareurl;
@property (nonatomic , copy) NSString *describes;

@property (nonatomic , copy) NSString *isShare;

@property (nonatomic , copy) NSString *remark;
//1是VR,2不是
@property (nonatomic, copy) NSString * videoType;

@end

@interface ICityLifeMenuModel : NSObject

@property (nonatomic , copy) NSString *html;
@property (nonatomic , copy) NSString *icon;
@property (nonatomic , copy) NSString *name;
@property (nonatomic , copy) NSString *id;

@end

