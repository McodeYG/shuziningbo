//
//  JstyleManagementUserInformationModel.h
//  Exquisite
//
//  Created by 数字跃动 on 2017/10/18.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JstyleManagementUserInformationModel : NSObject

///媒体类型
@property (nonatomic, copy) NSString *type;
///运营者所在地
@property (nonatomic, copy) NSString *fullName;
///媒体头像
@property (nonatomic, copy) NSString *head_img;
///证件照
@property (nonatomic, copy) NSString *idphoto;
///媒体名称
@property (nonatomic, copy) NSString *pen_name;
///组织机构代码证图片
@property (nonatomic, copy) NSString *organization_img;
///组织机构代码证名称
@property (nonatomic, copy) NSString *organization_name;
///其他资质
@property (nonatomic, copy) NSString *intelligence_img;
///简介
@property (nonatomic, copy) NSString *instruction;
///专注领域
@property (nonatomic, copy) NSString *field_name;
///真实姓名
@property (nonatomic, copy) NSString *operate_name;
///身份证号
@property (nonatomic, copy) NSString *idcard;
///联系电话
@property (nonatomic, copy) NSString *operate_phone;
///联系邮箱
@property (nonatomic, copy) NSString *operate_email;
///领域id
@property (nonatomic, copy) NSString *field_id;
///所在地id
@property (nonatomic, copy) NSString *location_id;

@end
