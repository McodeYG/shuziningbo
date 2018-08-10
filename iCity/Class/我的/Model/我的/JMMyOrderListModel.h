//
//  JMMyOrderListModel.h
//  Exquisite
//
//  Created by 数字宁波 on 16/6/29.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMMyAllOrderListModel : NSObject

/**商品的gid*/
@property (nonatomic, copy) NSString *gid;
/**商品品牌名字*/
@property (nonatomic, copy) NSString *rname;
/**商品的名字*/
@property (nonatomic, copy) NSString *gname;
/**商品的颜色分类*/
@property (nonatomic, copy) NSString *keystr;
/**商品的购买个数*/
@property (nonatomic, assign) NSInteger buynums;
/**商品的图片*/
@property (nonatomic, copy) NSString *poster;
/**商品的价格*/
@property (nonatomic, copy) NSString *sale_price;
/**uid*/
@property (nonatomic, copy) NSString *uid;
/**订单orderId*/
@property (nonatomic, copy) NSString *orderid;
/**订单状态*/
@property (nonatomic, copy) NSString *status;
/**所属分类:(例如所属待付款,状态为已取消等)*/
@property (nonatomic, copy) NSString *cate;
/**订单状态*/
@property (nonatomic, copy) NSString *supplyid;
/**创建时间*/
@property (nonatomic, copy) NSString *ctime;
/**自增id*/
@property (nonatomic, copy) NSString *ID;
/**商品总价*/
@property (nonatomic, copy) NSString *payamount;
/**商品购买渠道:1是积分购买,0是普通购买*/
@property (nonatomic, copy) NSString *isscorespu;
/**判断是否显示分享优惠券*/
@property (nonatomic, copy) NSString *if_cou_button;

@property (nonatomic, copy) NSString *fee;

@end


@interface JMMyDaiFuKuanModel : NSObject

/**商品的gid*/
@property (nonatomic, copy) NSString *gid;
/**商品品牌名字*/
@property (nonatomic, copy) NSString *rname;
/**商品的名字*/
@property (nonatomic, copy) NSString *gname;
/**商品的颜色分类*/
@property (nonatomic, copy) NSString *keystr;
/**商品的购买个数*/
@property (nonatomic, assign) NSInteger buynums;
/**商品的图片*/
@property (nonatomic, copy) NSString *poster;
/**商品的原价*/
@property (nonatomic, copy) NSString *sale_price;
/**商品使用积分的价格*/
@property (nonatomic, copy) NSString *amount;
/**uid*/
@property (nonatomic, copy) NSString *uid;
/**订单orderId*/
@property (nonatomic, copy) NSString *orderid;
/**订单状态*/
@property (nonatomic, copy) NSString *status;
/**订单状态*/
@property (nonatomic, copy) NSString *supplyid;
/**创建时间*/
@property (nonatomic, copy) NSString *ctime;
/**自增id*/
@property (nonatomic, copy) NSString *ID;
/**商品总价*/
@property (nonatomic, copy) NSString *payamount;
/**商品购买渠道:1是积分购买,0是普通购买*/
@property (nonatomic, copy) NSString *isscorespu;
/**判断是否显示分享优惠券*/
@property (nonatomic, copy) NSString *if_cou_button;

@property (nonatomic, copy) NSString *fee;

@end



@interface JMMyDaiFaHuoModel : NSObject

/**商品的gid*/
@property (nonatomic, copy) NSString *gid;
/**商品品牌名字*/
@property (nonatomic, copy) NSString *rname;
/**商品的名字*/
@property (nonatomic, copy) NSString *gname;
/**商品的颜色分类*/
@property (nonatomic, copy) NSString *keystr;
/**商品的购买个数*/
@property (nonatomic) NSInteger buynums;
/**商品的图片*/
@property (nonatomic, copy) NSString *poster;
/**商品的价格*/
@property (nonatomic, copy) NSString *sale_price;
/**uid*/
@property (nonatomic, copy) NSString *uid;
/**订单orderId*/
@property (nonatomic, copy) NSString *orderid;
/**运费*/
@property (nonatomic, copy) NSString *fee;
/**订单状态*/
@property (nonatomic, copy) NSString *status;
/**创建时间*/
@property (nonatomic, copy) NSString *ctime;
/**自增id*/
@property (nonatomic, copy) NSString *ID;
/**商品总价*/
@property (nonatomic, copy) NSString *payamount;
/**商品购买渠道:1是积分购买,0是普通购买*/
@property (nonatomic, copy) NSString *isscorespu;
/**判断是否显示分享优惠券*/
@property (nonatomic, copy) NSString *if_cou_button;

@end



@interface JMMyDaiShouHuoModel : NSObject

/**商品的gid*/
@property (nonatomic, copy) NSString *gid;
/**商品品牌名字*/
@property (nonatomic, copy) NSString *rname;
/**商品的名字*/
@property (nonatomic, copy) NSString *gname;
/**商品的颜色分类*/
@property (nonatomic, copy) NSString *keystr;
/**商品的购买个数*/
@property (nonatomic) NSInteger buynums;
/**商品的图片*/
@property (nonatomic, copy) NSString *poster;
/**商品的价格*/
@property (nonatomic, copy) NSString *sale_price;
/**uid*/
@property (nonatomic, copy) NSString *uid;
/**订单orderId*/
@property (nonatomic, copy) NSString *orderid;
/**订单状态*/
@property (nonatomic, copy) NSString *status;
/**创建时间*/
@property (nonatomic, copy) NSString *ctime;
/**自增id*/
@property (nonatomic, copy) NSString *ID;
/**商品总价*/
@property (nonatomic, copy) NSString *payamount;
/**商品购买渠道:1是积分购买,0是普通购买*/
@property (nonatomic, copy) NSString *isscorespu;
/**判断是否显示分享优惠券*/
@property (nonatomic, copy) NSString *if_cou_button;

@property (nonatomic, copy) NSString *fee;

@end



@interface JMMyYiChengJiaoModel : NSObject

/**商品的gid*/
@property (nonatomic, copy) NSString *gid;
/**商品品牌名字*/
@property (nonatomic, copy) NSString *rname;
/**商品的名字*/
@property (nonatomic, copy) NSString *gname;
/**商品的颜色分类*/
@property (nonatomic, copy) NSString *keystr;
/**商品的购买个数*/
@property (nonatomic) NSInteger buynums;
/**商品的图片*/
@property (nonatomic, copy) NSString *poster;
/**商品的价格*/
@property (nonatomic, copy) NSString *sale_price;
/**uid*/
@property (nonatomic, copy) NSString *uid;
/**订单orderId*/
@property (nonatomic, copy) NSString *orderid;
/**订单状态*/
@property (nonatomic, copy) NSString *status;
/**创建时间*/
@property (nonatomic, copy) NSString *ctime;
/**自增id*/
@property (nonatomic, copy) NSString *ID;
/**商品总价*/
@property (nonatomic, copy) NSString *payamount;
/**商品购买渠道:1是积分购买,0是普通购买*/
@property (nonatomic, copy) NSString *isscorespu;
/**判断是否显示分享优惠券*/
@property (nonatomic, copy) NSString *if_cou_button;

@property (nonatomic, copy) NSString *fee;

@end





