//
//  ICityWeeklyReadModel.h
//  iCity
//
//  Created by 王磊 on 2018/4/28.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICityWeeklyReadModel : NSObject

///id
@property (nonatomic, copy) NSString *id;
///书名
@property (nonatomic, copy) NSString *bookname;
///H5连接
@property (nonatomic, copy) NSString *h5_url;
///作者
@property (nonatomic, copy) NSString *author;
///封面图
@property (nonatomic, copy) NSString *picture;
/**类型*/
@property (nonatomic, copy) NSString *type;

@end
