//
//  JMHomeHotSearchModel.h
//  Exquisite
//
//  Created by 数字宁波 on 16/6/16.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMHomeHotSearchModel : NSObject

/**热词id标识符*/
@property (nonatomic, copy) NSString *ID;
/**热词名字*/
@property (nonatomic, copy) NSString *name;

@end



@interface JMHomeHistorySearchModel : NSObject

/**历史搜索词*/
@property (nonatomic, copy) NSString *hissearch_content;

@end



@interface JMHomeSearchGoodsModel : NSObject

/**标识符id*/
@property (nonatomic, copy) NSString *ID;
/**catid*/
@property (nonatomic, copy) NSString *catid;
/**supplyid*/
@property (nonatomic, copy) NSString *supplyid;
/**brandid*/
@property (nonatomic, copy) NSString *brandid;
/**商品名字*/
@property (nonatomic, copy) NSString *gname;
/**品牌名字*/
@property (nonatomic, copy) NSString *rname;
/**商品简介*/
@property (nonatomic, copy) NSString *keywords;
/**商品图*/
@property (nonatomic, copy) NSString *poster;
/**货号*/
@property (nonatomic, copy) NSString *gnum;
/**售价*/
@property (nonatomic, copy) NSString *sale_price;
/**货存数量*/
@property (nonatomic, copy) NSString *nums;
/**销量*/
@property (nonatomic, copy) NSString *sales;
/**收藏数量*/
@property (nonatomic, copy) NSString *collectnums;
/**加入购物车数*/
@property (nonatomic, copy) NSString *carnums;
/***/
@property (nonatomic, copy) NSString *commentnums;
/**商品的gid*/
@property (nonatomic, copy) NSString *gid;
/***/
@property (nonatomic, copy) NSString *detailshow;
/***/
@property (nonatomic, copy) NSString *comments;

/**分享链接*/
@property (nonatomic, copy) NSString *shareurl;

@property (nonatomic, copy) NSString *spu_change_links;

@end


@interface JMHomeSearchScreeningModel : NSObject

/**分类id*/
@property (nonatomic, copy) NSString *ID;
/**分类名称*/
@property (nonatomic, copy) NSString *cname;
/**pid*/
@property (nonatomic, copy) NSString *pid;
/**开始时间*/
@property (nonatomic, copy) NSString *ctime;
/**结束时间*/
@property (nonatomic, copy) NSString *etime;
/**路径*/
@property (nonatomic, copy) NSString *path;


@end


