//
//  JMMyShippingAddressModel.h
//  Exquisite
//
//  Created by 数字宁波 on 16/6/12.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMMyShippingAddressModel : NSObject

/**id*/
@property (nonatomic, copy) NSString *ID;
/**登陆人id*/
@property (nonatomic, copy) NSString *userid;
/**收货人姓名*/
@property (nonatomic, copy) NSString *uname;
/**联系电话*/
@property (nonatomic, copy) NSString *phone;
/**省*/
@property (nonatomic, copy) NSString *province;
/**市*/
@property (nonatomic, copy) NSString *city;
/**县*/
@property (nonatomic, copy) NSString *county;
/**具体地址*/
@property (nonatomic, copy) NSString *addr;
/**完整地址*/
@property (nonatomic, copy) NSString *address;
/**是否是默认地址*/
@property (nonatomic, copy) NSString *isdefault;
/**创建时间*/
@property (nonatomic, copy) NSString *ctime;
/**修改时间*/
@property (nonatomic, copy) NSString *etime;

/**能否使用积分*/
@property (nonatomic, copy) NSString *isscore;
/**积分数量*/
@property (nonatomic, copy) NSString *paymount;
/**运费*/
@property (nonatomic,copy) NSString *fee;
/**用户积分*/
@property (nonatomic,copy) NSString *allscore;
/**加上运费后的总价*/
@property (nonatomic,copy) NSString *payamount;
/**可用优惠券数量*/
@property (nonatomic,copy) NSString *couponnum;

@property (nonatomic,copy) NSString *not_group_price;

@end
