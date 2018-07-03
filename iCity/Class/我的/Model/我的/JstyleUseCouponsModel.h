//
//  JstyleUseCouponsModel.h
//  Exquisite
//
//  Created by 赵涛 on 2017/3/14.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JstyleAvailableCouponsModel : NSObject

/**优惠券名字*/
@property (nonatomic, copy) NSString *name;
/**优惠券类型*/
@property (nonatomic, copy) NSString *type;
/**有效期开始时间*/
@property (nonatomic, copy) NSString *start_time;
/**有效期结束时间*/
@property (nonatomic, copy) NSString *end_time;
/**编号*/
@property (nonatomic, copy) NSString *number;
/**有效图片*/
@property (nonatomic, copy) NSString *valid_img;
/**面值*/
@property (nonatomic, copy) NSString *discount_price;

@end


@interface JstyleUnAvailableCouponsModel : NSObject

/**优惠券名字*/
@property (nonatomic, copy) NSString *name;
/**优惠券类型*/
@property (nonatomic, copy) NSString *type;
/**有效期开始时间*/
@property (nonatomic, copy) NSString *start_time;
/**有效期结束时间*/
@property (nonatomic, copy) NSString *end_time;
/**编号*/
@property (nonatomic, copy) NSString *number;
/**有效图片*/
@property (nonatomic, copy) NSString *valid_img;
/**面值*/
@property (nonatomic, copy) NSString *discount_price;


@end
