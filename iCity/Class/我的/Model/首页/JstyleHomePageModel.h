//
//  JstyleHomePageModel.h
//  Exquisite
//
//  Created by 赵涛 on 2016/11/28.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JstyleHomePageLiveModel : NSObject

/**视频列表封面:图片*/
@property (nonatomic, copy) NSString *cover_list;
/**视频id*/
@property (nonatomic, copy) NSString *ID;
/**介绍*/
@property (nonatomic, copy) NSString *intro;
/**视频播放状态*/
@property (nonatomic, copy) NSString *isvideo;
/**直播房间号*/
@property (nonatomic, copy) NSString *liveroomid;
/**视频内容*/
@property (nonatomic, copy) NSString *name;
/**播放次数*/
@property (nonatomic, copy) NSString *play_num;
/**直播聊天室号*/
@property (nonatomic, copy) NSString *roomid;
/**是否有边看边买*/
@property (nonatomic, copy) NSString *is_open_buy;
/**判断横竖屏*/
@property (nonatomic, copy) NSString *video_type;
/**视频地址*/
@property (nonatomic, copy) NSString *url_sd;
@property (nonatomic, copy) NSString *url_hd;
/**vip*/
@property (nonatomic, copy) NSString *is_vip;

@end

@interface JstyleHomePageMenuModel : NSObject

/**菜单图片*/
@property (nonatomic, copy) NSString *image;
/**菜单名字*/
@property (nonatomic, copy) NSString *name;

@end

@interface JstyleHomePageVideoModel : NSObject

/**视频列表封面:图片*/
@property (nonatomic, copy) NSString *cover_list;
/**视频id*/
@property (nonatomic, copy) NSString *ID;
/**视频内容*/
@property (nonatomic, copy) NSString *name;
/**视频地址*/
@property (nonatomic, copy) NSString *url_sd;
/**是否是VIP*/
@property (nonatomic, copy) NSString *is_vip;

@end

@interface JstyleHomePageArticleModel : NSObject

/**文章id*/
@property (nonatomic, copy) NSString *rid;
/**文章列表封面:大图片*/
@property (nonatomic, copy) NSString *poster;
/**二级分类小标题*/
@property (nonatomic, copy) NSString *rname;
/**栏目id*/
@property (nonatomic, copy) NSString *cid;
/**文章标题*/
@property (nonatomic, copy) NSString *rtitle;
/**判断文章类型*/
@property (nonatomic, copy) NSString *isimagearticle;
/**浏览数*/
@property (nonatomic, copy) NSString *browsenum;
/**点赞数*/
@property (nonatomic, copy) NSString *praisenum;

@end

@interface JstyleHomePageGoodsModel : NSObject

/**商品gid*/
@property (nonatomic, copy) NSString *gid;
/**商品名称*/
@property (nonatomic, copy) NSString *gname;
/**商品id*/
@property (nonatomic, copy) NSString *ID;
/**商品封面:图片*/
@property (nonatomic, copy) NSString *poster;
/**商品价格*/
@property (nonatomic, copy) NSString *sale_price;
/**商品品牌*/
@property (nonatomic, copy) NSString *rname;

@property (nonatomic, copy) NSString *spu_change_links;

@end

@interface JstyleHomePageDayLookModel : NSObject

/**搭配描述*/
@property (nonatomic, copy) NSString *describes;
/**搭配图片*/
@property (nonatomic, copy) NSString *img;
/**搭配链接*/
@property (nonatomic, copy) NSString *lurl;
/**搭配类型*/
@property (nonatomic, copy) NSString *type;

@end

@interface JstyleArticleCategoryModel : NSObject

/**二级分类id*/
@property (nonatomic, copy) NSString *cid;
/**创建时间*/
@property (nonatomic, copy) NSString *ctime;
/**文章小标题*/
@property (nonatomic, copy) NSString *original;
/**文章id*/
@property (nonatomic, copy) NSString *rid;
/**文章列表封面:图片*/
@property (nonatomic, copy) NSString *poster;
/**文章标题*/
@property (nonatomic, copy) NSString *rtitle;
/**是否是图集*/
@property (nonatomic, copy) NSString *isimagearticle;

@end

@interface JstyleHomeAriClassModel : NSObject
/**二级分类id*/
@property (nonatomic, copy) NSString *cid;
/**创建时间*/
@property (nonatomic, copy) NSString *ctime;
/**文章小标题*/
@property (nonatomic, copy) NSString *original;
/**文章id*/
@property (nonatomic, copy) NSString *rid;
/**文章列表封面:图片*/
@property (nonatomic, copy) NSString *poster;
/**文章标题*/
@property (nonatomic, copy) NSString *rtitle;
/**专题ID*/
@property (nonatomic, copy) NSString *ID;
/**专题名字*/
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *icon_img;

@property (nonatomic, copy) NSString *icon_click_img;

@end


@interface JstyleArticleTuiJianModel : NSObject

/**文章id*/
@property (nonatomic, copy) NSString *ID;
/**文章关键字*/
@property (nonatomic, copy) NSString *keywords;
/**文章列表封面:大图片*/
@property (nonatomic, copy) NSString *poster;
/**文章标题*/
@property (nonatomic, copy) NSString *title;
/**文章列表封面:小图片*/
@property (nonatomic, copy) NSString *poster_app_min;

@end


@interface JstyleHomeAllArticleModel : NSObject

/**文章id*/
@property (nonatomic, copy) NSString *rid;
/**文章列表封面:大图片*/
@property (nonatomic, copy) NSString *poster;
/**二级分类小标题*/
@property (nonatomic, copy) NSString *rname;
/**栏目id*/
@property (nonatomic, copy) NSString *cid;
/**文章标题*/
@property (nonatomic, copy) NSString *rtitle;
/**判断文章类型*/
@property (nonatomic, copy) NSString *isimagearticle;
/**浏览数*/
@property (nonatomic, copy) NSString *browsenum;
/**点赞数*/
@property (nonatomic, copy) NSString *praisenum;
/**分享链接*/
@property (nonatomic, copy) NSString *ashareurl;
/**文章描述*/
@property (nonatomic, copy) NSString *describes;

@end


@interface JstyleHomeArticleSubjectModel : NSObject

/**内容专题的ID*/
@property (nonatomic, copy) NSString *ID;
/**内容专题图片*/
@property (nonatomic, copy) NSString *img;
/**内容名字*/
@property (nonatomic, copy) NSString *name;
/**内容时间*/
@property (nonatomic, copy) NSString *ctime;

@end

@interface JstyleHomeGoodsSubjectModel : NSObject

/**商品专题的ID*/
@property (nonatomic, copy) NSString *ID;
/**商品专题图片*/
@property (nonatomic, copy) NSString *img;
/**商品名字*/
@property (nonatomic, copy) NSString *name;

@end

@interface JstylePersonalMediaGoodsModel : NSObject

/**商品gid*/
@property (nonatomic, copy) NSString *gid;
/**商品名称*/
@property (nonatomic, copy) NSString *gname;
/**商品id*/
@property (nonatomic, copy) NSString *ID;
/**商品封面:图片*/
@property (nonatomic, copy) NSString *poster;
/**商品价格*/
@property (nonatomic, copy) NSString *sale_price;
/**商品品牌*/
@property (nonatomic, copy) NSString *rname;

@property (nonatomic, copy) NSString *spu_change_links;

@end

@interface JstylePersonalMediaModel : NSObject

@property (nonatomic, copy) NSString *did;

@property (nonatomic, copy) NSString *head_img;

@property (nonatomic, copy) NSString *pen_name;

@end

@interface JstyleHomeCateRecommendModel : NSObject

@property (nonatomic, copy) NSString *display_type;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *poster;

@property (nonatomic, copy) NSString *rname;

@property (nonatomic, copy) NSString *air_time;

@property (nonatomic, copy) NSString *play_num;

@property (nonatomic, copy) NSString *is_open_buy;

@property (nonatomic, copy) NSString *roomid;

@property (nonatomic, copy) NSString *liveroomid;

@property (nonatomic, copy) NSString *isvideo;

@property (nonatomic, copy) NSString *url_sd;

@property (nonatomic, copy) NSString *isimagearticle;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *browsenum;

@property (nonatomic, copy) NSString *praisenum;

@property (nonatomic, copy) NSString *attach_type;

@end

