//
//  JstyleNewsArticleDetailModel.h
//  JstyleNews
//
//  Created by 数字跃动 on 2017/12/29.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JstyleNewsArticleDetailModel : NSObject

///iCity号名字
@property (nonatomic, copy) NSString *author_name;
///iCity号id
@property (nonatomic, copy) NSString *author_did;
///"#原创"标签
@property (nonatomic, copy) NSString *TOrFOriginal;
///iCity号头像
@property (nonatomic, copy) NSString *author_img;
///栏目名称
@property (nonatomic, copy) NSString *cname;
///创建时间
@property (nonatomic, copy) NSString *ctime;
///文章id
@property (nonatomic, copy) NSString *id;
///文章标题
@property (nonatomic, copy) NSString *title;
///文章封面
@property (nonatomic, copy) NSString *poster;
///是否显示iCity号（0.不显示iCity号信息；1.显示，状态为已经订阅；2.显示，状态为未订阅）
@property (nonatomic, copy) NSString *isShowAuthor;
///文章内容
@property (nonatomic, copy) NSString *content;

///cellTitle高度
@property (nonatomic, assign) CGFloat cellHeight;

@end
