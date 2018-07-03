//
//  chinesePinYin.h
//  类通讯录首字母搜索Dome
//
//  Created by 数字跃动 on 16/8/1.
//  Copyright © 2016年 zhenyan_C. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pinyin.h"

@interface chinesePinYin : NSObject
@property(strong,nonatomic)NSString *string;
@property(strong,nonatomic)NSString *pinYin;

//-----  返回tableview右方indexArray
+(NSMutableArray*)IndexArray:(NSArray*)stringArr;

//-----  返回联系人
+(NSMutableArray*)LetterSortArray:(NSArray*)stringArr;


///----------------------
//返回一组字母排序数组(中英混排)
+(NSMutableArray*)SortArray:(NSArray*)stringArr;

@end
