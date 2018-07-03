//
//  ICityBoradcastModel.h
//  HSQiCITY
//
//  Created by chunzheng wang on 2018/5/1.
//  Copyright © 2018年 chunzheng wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICityBoradcastModel : NSObject
///id
@property (nonatomic, copy) NSString *id;
///节目名称:1028交通服务热线
@property (nonatomic, copy) NSString *showname;
///宁波电视台 电视台名字
@property (nonatomic, copy) NSString *radioname;
///主播名
@property (nonatomic, copy) NSString *anchor;
///电视台大标志
@property (nonatomic, copy) NSString *picture;
///人数
@property (nonatomic, copy) NSString *packagenum;
///状态
@property (nonatomic, copy) NSString *playstate;
///播放地址
@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *end_time;

@end
