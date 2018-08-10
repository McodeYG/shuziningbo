//
//  JstyleMyRecommendGoodsModel.h
//  Exquisite
//
//  Created by 数字宁波 on 2016/11/24.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JstyleMyRecommendGoodsModel : NSObject

/**商品图片*/
@property (nonatomic, copy) NSString *poster;
/**商品价格*/
@property (nonatomic, copy) NSString *sale_price;
/**商品名称*/
@property (nonatomic, copy) NSString *gname;
/**商品id*/
@property (nonatomic, copy) NSString *gid;
/**自增id*/
@property (nonatomic, copy) NSString *ID;
/**品牌名称*/
@property (nonatomic, copy) NSString *rname;


///**商品简介*/
//@property (nonatomic, copy) NSString *detailshow;
///**商品数量*/
//@property (nonatomic, copy) NSString *nums;
///**供货商*/
//@property (nonatomic, copy) NSString *supplyid;
///**分享链接*/
//@property (nonatomic, copy) NSString *shareurl;
///**分享商品简介*/
//@property (nonatomic, copy) NSString *keywords;

@end

@interface JstyleGoodsTuijianBrandModel : NSObject

@property (nonatomic, copy) NSString *rname;
@property (nonatomic, copy) NSString *rid;
@property (nonatomic, copy) NSString *rpicture;

@end
