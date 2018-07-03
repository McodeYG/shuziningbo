//
//  JstyleNewsMineLoginUserInfoModel.h
//  JstyleNews
//
//  Created by 数字跃动 on 2017/12/22.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JstyleNewsMineLoginUserInfoModel : NSObject

///昵称
@property (nonatomic , copy) NSString *nick_name;
///账户头像
@property (nonatomic , copy) NSString *poster;
///7天访客数
@property (nonatomic , copy) NSString *browse_num;
///评论数
@property (nonatomic , copy) NSString *comment_num;
///动态数
@property (nonatomic , copy) NSString *content_num;
///手机号
@property (nonatomic , copy) NSString *phone;
///是否是"荣誉内测用户"
@property (nonatomic , copy) NSString *isbetauser;

@end
