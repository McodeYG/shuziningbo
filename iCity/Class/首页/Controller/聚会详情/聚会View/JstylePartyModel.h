//
//  JstylePartyModel.h
//  Exquisite
//
//  Created by 赵涛 on 2017/7/5.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JstylePartyHomeModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *long_address;
/**总人数*/
@property (nonatomic, copy) NSString *people_num;
/**报名人数*/
@property (nonatomic, copy) NSString *enroll_num;
@property (nonatomic, copy) NSString *sale_price;
/**浏览数*/
@property (nonatomic, copy) NSString *browsenum;

@property (nonatomic, copy) NSString *shareurl;
@property (nonatomic, copy) NSString *describes;

@end

@interface JstyleMyPartyModel : NSObject

@property (nonatomic, copy) NSString *orderid;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *sale_price;
/**总人数*/
@property (nonatomic, copy) NSString *people_num;
/**报名人数*/
@property (nonatomic, copy) NSString *enroll_num;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *address;
/**浏览数*/
@property (nonatomic, copy) NSString *browsenum;
/**支付状态*/
@property (nonatomic, copy) NSString *type;
/**聚会状态*/
@property (nonatomic, copy) NSString *party_type;

@property (nonatomic, copy) NSString *mobile;

@end

@interface JstylePartySuccessInfoModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;

@end

