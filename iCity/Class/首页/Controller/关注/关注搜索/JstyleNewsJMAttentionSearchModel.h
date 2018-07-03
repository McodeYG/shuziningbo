//
//  JstyleNewsJMAttentionSearchModel.h
//  JstyleNews
//
//  Created by 王磊 on 2018/4/2.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JstyleNewsJMAttentionSearchModel : NSObject

///自媒体id
@property (nonatomic , copy) NSString *did;
///头像
@property (nonatomic , copy) NSString *head_img;
///名称
@property (nonatomic , copy) NSString *pen_name;
///是否已关注(1:已关注 2:未关注)
@property (nonatomic , copy) NSString *isFollow;
///自媒体简介
@property (nonatomic , copy) NSString *instruction;

@end
