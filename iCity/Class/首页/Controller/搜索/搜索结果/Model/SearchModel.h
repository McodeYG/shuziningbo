//
//  SearchModel.h
//  iCity
//
//  Created by mayonggang on 2018/6/12.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchModel : NSObject
@property (nonatomic , copy) NSString              * poster;
@property (nonatomic , copy) NSString              * ctime;
@property (nonatomic , copy) NSString              * url_sd;
@property (nonatomic , copy) NSString              * sendId;
@property (nonatomic , copy) NSString              * posternum;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * cname;
/** 1.文章；2.图集；3.视频；4.直播；5.百度百科;6.相关搜索；7.相关人物；8.iCity号 */
@property (nonatomic , copy) NSString              * type;
/**1.一图；2.三图*/
@property (nonatomic , copy) NSString              * head_type;
/**搜索内容*/
@property (nonatomic , copy) NSString              * key;
@property (nonatomic , copy) NSString              * isImageArticle;

@property (nonatomic , copy) NSString              * did;
@property (nonatomic , copy) NSString              * head_img;
@property (nonatomic , copy) NSString              * pen_name;
@property (nonatomic , copy) NSString              * isFollow;
@property (nonatomic , copy) NSString              * instruction;
@property (nonatomic , copy) NSString              * content;

@property (nonatomic , copy) NSString              * isShowAuthor;
@property (nonatomic , copy) NSString              * author_img;
@property (nonatomic , copy) NSString              * author_did;
@property (nonatomic , copy) NSString              * author_name;
@property (nonatomic , copy) NSString              * TOrFOriginal;//原创标签
@property (nonatomic , copy) NSString              * torFOriginal;//原创标签
/**H5标题*/
@property (nonatomic , copy) NSString              * name;
/**H5url*/
@property (nonatomic , copy) NSString              * url;
//是不是VR 1是，2不是
@property (nonatomic , copy) NSString              * videoType;
@property (nonatomic , strong) NSArray             * imgs;
/**搜索---相关人物*/
@property (nonatomic , strong) NSArray             * searchRsResult;
/**iCity号*/
@property (nonatomic , strong) NSArray             * authorList;

/**百度百科*/
@property (nonatomic , strong) NSString             * h5_url;




@end


//搜索——相关人物


@interface SearchAboutPersonModel : NSObject

@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * poster;
@property (nonatomic , copy) NSString              * url;

//搜索--推荐iCity号
@property (nonatomic, copy) NSString *did;
@property (nonatomic, copy) NSString *head_img;
@property (nonatomic, copy) NSString *pen_name;
@property (nonatomic, copy) NSString *isFollow;
@property (nonatomic, copy) NSString *instruction;


@end
