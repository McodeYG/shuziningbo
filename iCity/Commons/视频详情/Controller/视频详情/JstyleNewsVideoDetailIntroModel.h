//
//  JstyleNewsVideoDetailIntroModel.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/12.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JstyleNewsVideoDetailIntroModel : NSObject

@property (nonatomic , copy) NSString              * cname;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * play_num;
@property (nonatomic , copy) NSString              * cid;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * ctime;
@property (nonatomic , copy) NSString              * keywords;
@property (nonatomic , copy) NSString              * author_img;
@property (nonatomic , copy) NSString              * author_did;
@property (nonatomic , copy) NSString              * author_name;
@property (nonatomic , copy) NSString              * poster;
@property (nonatomic , copy) NSString              * time_length;
/**视频名字*/
@property (nonatomic , copy) NSString              * videoname;
//是否显示自媒体信息
@property (nonatomic , copy) NSString              * isShowAuthor;

@end



@interface JstyleNewsVideoDetailTuijianModel : NSObject

@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * poster;
@property (nonatomic , copy) NSString              * url_sd;

@end
