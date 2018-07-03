//
//  ICityKnowledgeBaseModel.h
//  iCity
//
//  Created by 王磊 on 2018/4/30.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICityKnowledgeBaseModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *ctime;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *torder;

@property (nonatomic, copy) NSString *source_num;
@property (nonatomic, copy) NSString *follow_num;//知识库关注
//@property (nonatomic, copy) NSString *folow_num;//城市百科关注

@property (nonatomic, copy) NSString *field_id;
@property (nonatomic, copy) NSString *html;

@end
