//
//  JMMyJiFenModel.h
//  Exquisite
//
//  Created by 赵涛 on 16/6/15.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMMyJiFenModel : NSObject

/**得到积分的路径名称*/
@property (nonatomic, copy) NSString *way;
/**得到积分的时间*/
@property (nonatomic, copy) NSString *create_date;
/**得到积分的数量*/
@property (nonatomic, copy) NSString *integral_change;
/**积分的变化情况*/
@property (nonatomic, copy) NSString *types;
/**用户id*/
@property (nonatomic, copy) NSString *user_id;
/***/
@property (nonatomic, copy) NSString *integral_total;
/**总积分*/
@property (nonatomic, copy) NSString *integral_num;
/**标识符*/
@property (nonatomic, copy) NSString *ID;

@end
