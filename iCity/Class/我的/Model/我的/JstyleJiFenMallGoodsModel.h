//
//  JstyleJiFenMallGoodsModel.h
//  Exquisite
//
//  Created by 赵涛 on 2017/2/28.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JstyleJiFenMallGoodsModel : NSObject

/**商品图片*/
@property (nonatomic, copy) NSString *poster;
/**商品积分价格*/
@property (nonatomic, copy) NSString *integral_change;
/**商品名称*/
@property (nonatomic, copy) NSString *gname;
/**商品id*/
@property (nonatomic, copy) NSString *gid;
/**自增id*/
@property (nonatomic, copy) NSString *ID;
/**品牌名称*/
@property (nonatomic, copy) NSString *rname;

@end
