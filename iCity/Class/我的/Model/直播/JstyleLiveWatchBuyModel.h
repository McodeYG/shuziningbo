//
//  JstyleLiveWatchBuyModel.h
//  Exquisite
//
//  Created by 数字宁波 on 16/10/14.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JstyleLiveWatchBuyModel : NSObject

/**商品的id*/
@property (nonatomic, copy) NSString *gid;
/**商品的图片*/
@property (nonatomic, copy) NSString *poster;
/**商品的名字*/
@property (nonatomic, copy) NSString *gname;
/**商品的品牌名*/
@property (nonatomic, copy) NSString *rname;
/**创建时间*/
@property (nonatomic, copy) NSString *ctime;
/**商品的自增id*/
@property (nonatomic, copy) NSString *ID;
/**商品的售价*/
@property (nonatomic, copy) NSString *sale_price;
/**商品分享的链接*/
@property (nonatomic, copy) NSString *shareurl;
/**第三方平台商品的链接*/
@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *spu_change_links;

@end
