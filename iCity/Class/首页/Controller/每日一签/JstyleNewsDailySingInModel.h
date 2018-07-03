//
//  JstyleNewsDailySingInModel.h
//  JstyleNews
//
//  Created by 王磊 on 2018/2/5.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JstyleNewsDailySingInModel : NSObject

///每日一签模板
@property (nonatomic, copy) NSString *template_type;
///客服账号
@property (nonatomic, copy) NSString *username;
///客服职位
@property (nonatomic, copy) NSString *job;
///用户openfire账号
@property (nonatomic, copy) NSString *openfire_id;
///客服昵称
@property (nonatomic, copy) NSString *nickname;
///客服头像
@property (nonatomic, copy) NSString *avator;
///签到图片
@property (nonatomic, copy) NSString *image;
///签到id
@property (nonatomic, copy) NSString *id;

@end
