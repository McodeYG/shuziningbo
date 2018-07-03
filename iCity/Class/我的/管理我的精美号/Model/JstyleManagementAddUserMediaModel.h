//
//  JstyleManagementAddUserMediaModel.h
//  Exquisite
//
//  Created by 数字跃动 on 2017/10/18.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JstyleManagementAddUserMediaModel : NSObject

///用户uid(必传)
@property (nonatomic, copy) NSString *uid;
///验证手机号(必传)
@property (nonatomic, copy) NSString *validphone;
///验证码（必传）
@property (nonatomic, copy) NSString *validcode;
///媒体类型（1是个人，2是企业）（只传1、2）
@property (nonatomic, copy) NSString *type;
///媒体名称
@property (nonatomic, copy) NSString *pen_name;
///媒体简介
@property (nonatomic, copy) NSString *instruction;
///媒体头像
@property (nonatomic, copy) NSString *head_img;
///真实姓名
@property (nonatomic, copy) NSString *operate_name;
///身份证号
@property (nonatomic, copy) NSString *IDcard;
///证件照
@property (nonatomic, copy) NSString *IDphoto;
///联系电话
@property (nonatomic, copy) NSString *operate_phone;
///组织名称
@property (nonatomic, copy) NSString *organization_name;
///组织机构代码证
@property (nonatomic, copy) NSString *organization_img;
///领域id（领域：另一个接口,传id）
@property (nonatomic, copy) NSString *field_id;
///所在地id （所在地：另一个接口,传id）
@property (nonatomic, copy) NSString *location_id;
///材料说明
@property (nonatomic, copy) NSString *intelligence_img;
///联系邮箱
@property (nonatomic, copy) NSString *operate_mail;

@end
