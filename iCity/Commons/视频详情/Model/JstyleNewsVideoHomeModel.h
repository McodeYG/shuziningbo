//
//  JstyleNewsVideoHomeModel.h
//  JstyleNews
//
//  Created by 赵涛 on 2017/10/30.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JstyleNewsVideoHomeModel : NSObject

@property (nonatomic , copy) NSString              * poster;
@property (nonatomic , copy) NSString              * ctime;
@property (nonatomic , copy) NSString              * url_sd;
@property (nonatomic , copy) NSString              * sendId;
//是否是vr; 1.是；2.否
@property (nonatomic , copy) NSString              * videoType;
@property (nonatomic , copy) NSString              * keywords;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * play_num;
//
@property (nonatomic , copy) NSString              * video_type;

@property (nonatomic , copy) NSString              * h5url;
@property (nonatomic , copy) NSString              * banner_type;
@property (nonatomic , copy) NSString              * rid;
@property (nonatomic , copy) NSString              * isImageArticle;
@property (nonatomic , copy) NSString              * content;

@property (nonatomic , copy) NSString              * isShowAuthor;
@property (nonatomic , copy) NSString              * author_img;
@property (nonatomic , copy) NSString              * author_did;
@property (nonatomic , copy) NSString              * author_name;

@property (nonatomic , copy) NSString              *describes;
@property (nonatomic , copy) NSString              *ashareurl;

@property (nonatomic , copy) NSString              *isShare;

@end
