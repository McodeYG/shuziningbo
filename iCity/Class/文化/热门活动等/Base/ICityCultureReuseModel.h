//
//  ICityCultureReuseModel.h
//  iCity
//
//  Created by 王磊 on 2018/5/1.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICityCultureReuseModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *long_address;
/**总人数*/
@property (nonatomic, copy) NSString *people_num;
/**报名人数*/
@property (nonatomic, copy) NSString *enroll_num;
@property (nonatomic, copy) NSString *sale_price;
/**浏览数*/
@property (nonatomic, copy) NSString *browsenum;

@property (nonatomic, copy) NSString *shareurl;
@property (nonatomic, copy) NSString *describes;

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *ctime;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *torder;
@property (nonatomic, copy) NSString *source_num;
@property (nonatomic, copy) NSString *folow_num;
@property (nonatomic, copy) NSString *field_id;

/*预加载文化详情*/
///内容
@property (nonatomic, copy) NSString *content;
///详情封面
@property (nonatomic, copy) NSString *poster;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *isShowAuthor;
@property (nonatomic, copy) NSString *author_did;
@property (nonatomic, copy) NSString *author_img;
@property (nonatomic, copy) NSString *author_name;

@property (nonatomic, strong) UIImage *posterImage;

@property (nonatomic, assign) CGFloat cellHeight;

@end

@interface ICityCultureMorePopularActivitiesModel : NSObject

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sale_price;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *field_id;

@end

@interface ICityCultureMoreMapModel : NSObject

@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *scenic_type;
@property (nonatomic, copy) NSString *scenic_season;
@property (nonatomic, copy) NSString *scenic_time;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *field_id;

///iCity号名字
@property (nonatomic, copy) NSString *author_name;
///iCity号id
@property (nonatomic, copy) NSString *author_did;
///"#原创"标签
@property (nonatomic, copy) NSString *TOrFOriginal;
///iCity号头像
@property (nonatomic, copy) NSString *author_img;
///栏目名称
@property (nonatomic, copy) NSString *cname;
///创建时间
@property (nonatomic, copy) NSString *ctime;

///文章标题
@property (nonatomic, copy) NSString *title;
///文章封面
@property (nonatomic, copy) NSString *poster;
///是否显示iCity号（0.不显示iCity号信息；1.显示，状态为已经订阅；2.显示，状态为未订阅）
@property (nonatomic, copy) NSString *isShowAuthor;
///文章内容
@property (nonatomic, copy) NSString *content;




@end
