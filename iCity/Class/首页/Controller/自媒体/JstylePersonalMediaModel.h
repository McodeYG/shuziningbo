//
//  JstylePersonalMediaModel.h
//  Exquisite
//
//  Created by 赵涛 on 2017/8/7.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JstylePersonalMediaListModel : NSObject

@property (nonatomic, copy) NSString *did;

@property (nonatomic, copy) NSString *pen_name;

@property (nonatomic, copy) NSString *head_img;

@property (nonatomic, copy) NSString *instruction;

@property (nonatomic, copy) NSString *follow_num;

@property (nonatomic, copy) NSString *article_num;

@end

@interface JstylePersonalMediaIntroModel : NSObject

@property (nonatomic, copy) NSString *instruction;

@property (nonatomic, copy) NSString *head_img;

@property (nonatomic, copy) NSString *pen_name;

@property (nonatomic, copy) NSString *time_length;

@property (nonatomic, copy) NSString *did;

@property (nonatomic, copy) NSString *is_follow;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) BOOL isOpen;

@end

@interface JstylePersonalMediaDetailModel : NSObject

@property (nonatomic, copy) NSString *attach_id;
@property (nonatomic, copy) NSString *attach_type;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *poster;
@property (nonatomic, copy) NSString *rname;
@property (nonatomic, copy) NSString *air_time;
@property (nonatomic, copy) NSString *play_num;
@property (nonatomic, copy) NSString *url_sd;
@property (nonatomic, copy) NSString *isimagearticle;
@property (nonatomic, copy) NSString *is_open_buy;
@property (nonatomic, copy) NSString *isvideo;
@property (nonatomic, copy) NSString *liveroomid;
@property (nonatomic, copy) NSString *roomid;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *browsenum;
@property (nonatomic, copy) NSString *praisenum;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *videoType;



@property (nonatomic, copy) NSString *author_img;
@property (nonatomic, copy) NSString *author_did;
@property (nonatomic, copy) NSString *author_name;
@property (nonatomic, copy) NSString *ctime;
@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSString *isShowAuthor;
@property (nonatomic, copy) NSString *torFOriginal;


@end

@interface JstyleJmNumsDetailTitleModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *status;

@end
