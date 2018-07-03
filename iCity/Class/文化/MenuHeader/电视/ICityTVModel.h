//
//  ICityTVModel.h
//  ICityTable
//
//  Created by chunzheng wang on 2018/5/1.
//  Copyright © 2018年 chunzheng wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICityTVModel : NSObject

///视频id
@property(nonatomic,copy)NSString *vid;
///小猪配骑-66集 集数
@property(nonatomic,copy)NSString *videoname;
///宁波电视台 电视台名字
@property(nonatomic,copy)NSString *televisionname;

///播放开始时间
@property(nonatomic,copy)NSString *start_time;
///播放时间 19:30
@property(nonatomic,copy)NSString *end_time;
///tvicon 电视台小标
@property(nonatomic,copy)NSString *icon;
///电视台大标志
@property(nonatomic,copy)NSString *picture;
///url
@property(nonatomic,copy)NSString *address;

@property(nonatomic,copy)NSString *videoType;


@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *sendId;



//为关注新添加的字段
@property(nonatomic,copy)NSString *isShowAuthor;

@property(nonatomic,copy)NSString *author_did;

@end
