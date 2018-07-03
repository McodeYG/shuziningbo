//
//  JMLiveGoodsTuiJianModel.h
//  Exquisite
//
//  Created by 赵涛 on 16/6/14.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMLiveGoodsTuiJianModel : NSObject

/**文章列表封面:图片*/
@property (nonatomic, copy) NSString *poster;
/**商品名字*/
@property (nonatomic, copy) NSString *gname;
/**商品介绍*/
@property (nonatomic, copy) NSString *keywords;
/**评论数*/
@property (nonatomic, copy) NSString *commentnums;
/**收藏数*/
@property (nonatomic, copy) NSString *collectnums;
/**视频关联商品表的唯一标识*/
@property (nonatomic, copy) NSString *ID;
/**品牌id*/
@property (nonatomic, copy) NSString *brandid;
/**商品的分类id*/
@property (nonatomic, copy) NSString *catid;
/**商品id*/
@property (nonatomic, copy) NSString *gid;
@property (nonatomic, copy) NSString *pid;
/***/
@property (nonatomic, copy) NSString *supplyid;
/**货号*/
@property (nonatomic, copy) NSString *gnum;
/**售价*/
@property (nonatomic, copy) NSString *sale_price;
/**库存*/
@property (nonatomic, copy) NSString *nums;



@end
