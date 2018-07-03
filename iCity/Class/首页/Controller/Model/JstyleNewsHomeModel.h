//
//  JstyleNewsHomeModel.h
//  JstyleNews
//
//  Created by 赵涛 on 2017/10/25.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JstyleNewsHomePageModel : NSObject

@property (nonatomic , copy) NSString              * url_sd;
@property (nonatomic , copy) NSString              * ctime;
@property (nonatomic , copy) NSString              * poster;
//轮播图文章对应的
@property (nonatomic , copy) NSString              * article_poster;
@property (nonatomic , copy) NSArray               * poster_imgs;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * cname;
@property (nonatomic , copy) NSString              * type;//
@property (nonatomic , copy) NSString              * video_type;
/**1是VR,2不是*/
@property (nonatomic , copy) NSString              * videoType;
@property (nonatomic , copy) NSString              * cid;
/**是啥*/
@property (nonatomic , copy) NSString              * head_type;
/**（三图布局）1是图集 2是文章*/
@property (nonatomic , copy) NSString              * isImageArticle;
@property (nonatomic , copy) NSString              * posternum;
@property (nonatomic , copy) NSString              * timestamp;

@property (nonatomic , copy) NSString              * banner_type;
@property (nonatomic , strong) NSArray             * otherBanner;

@property (nonatomic , copy) NSString              * h5url;
@property (nonatomic , copy) NSString              * rid;
@property (nonatomic , copy) NSString              * play_num;
@property (nonatomic , copy) NSString              * content;

@property (nonatomic , copy) NSString              * isShowAuthor;
@property (nonatomic , copy) NSString              * author_img;
@property (nonatomic , copy) NSString              * author_did;
@property (nonatomic , copy) NSString              * author_name;
@property (nonatomic , copy) NSString              * TOrFOriginal;

@property (nonatomic , copy) NSString              * ashareurl;
@property (nonatomic , copy) NSString              * describes;

@property (nonatomic , copy) NSString              * isShare;


@end


//推荐图书
@interface OtherBannerModel : NSObject

@property (nonatomic , copy) NSString              * h5url;
@property (nonatomic , copy) NSString              * sendid;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * poster;
@property (nonatomic , copy) NSString              * isShare;

@end
