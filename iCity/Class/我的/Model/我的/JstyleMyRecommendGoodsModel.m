//
//  JstyleMyRecommendGoodsModel.m
//  Exquisite
//
//  Created by 数字宁波 on 2016/11/24.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import "JstyleMyRecommendGoodsModel.h"

@implementation JstyleMyRecommendGoodsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end

@implementation JstyleGoodsTuijianBrandModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}

@end
