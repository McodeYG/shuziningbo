//
//  NewspaperModel.h
//  iCity
//
//  Created by mayonggang on 2018/6/14.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewspaperModel : NSObject


@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *sendId;

@property (nonatomic, copy) NSString *h5_url;
/**封面图*/
@property (nonatomic, copy) NSString *poster;

/**发布时间*/
@property (nonatomic, copy) NSString *start_time;





//新媒体----------

@property (nonatomic, copy) NSString *head_img;

@property (nonatomic, copy) NSString *instruction;

@property (nonatomic, copy) NSString *isFollow;
/**姓名*/
@property (nonatomic, copy) NSString *pen_name;
@property (nonatomic, copy) NSString *did;

@end
