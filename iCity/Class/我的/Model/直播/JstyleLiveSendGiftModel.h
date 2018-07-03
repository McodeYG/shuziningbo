//
//  JstyleLiveSendGiftModel.h
//  Exquisite
//
//  Created by 赵涛 on 2017/2/10.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JstyleLiveSendGiftModel : NSObject

/**礼物的名字*/
@property (nonatomic, copy) NSString *name;
/**礼物的图片url*/
@property (nonatomic, copy) NSString *img;
/**礼物的id*/
@property (nonatomic, copy) NSString *ID;
/**礼物的积分价格*/
@property (nonatomic, copy) NSString *integral;

@property (nonatomic, copy) NSString *is_vip;

@end
