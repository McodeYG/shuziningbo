//
//  JstyleMyHomeUserInfoModel.h
//  Exquisite
//
//  Created by 王磊 on 2018/3/7.
//  Copyright © 2018年 JstyleStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JstyleMyHomeUserInfoModel : NSObject

///是否是内测用户:1.内测;2.普通;3.活动;4.付费
@property (nonatomic, copy) NSString *isbetauser;
///总收益
@property (nonatomic, copy) NSString *all_price;
///收藏数
@property (nonatomic, copy) NSString *follownum;
///登录方式(1是手机号密码登录，2是验证码登录，3是第三方登录)
@property (nonatomic, copy) NSString *login_type;
///昵称
@property (nonatomic, copy) NSString *nick_name;
///头像
@property (nonatomic, copy) NSString *avator;
///可提现收益
@property (nonatomic, copy) NSString *now_price;
///足迹数
@property (nonatomic, copy) NSString *browsenum;
///订阅数
@property (nonatomic, copy) NSString *medianum;

@end
