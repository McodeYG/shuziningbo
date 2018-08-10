//
//  JMHomeHotSearchModel.m
//  Exquisite
//
//  Created by 数字宁波 on 16/6/16.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import "JMHomeSearchModel.h"

@implementation JMHomeHotSearchModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end



@implementation JMHomeHistorySearchModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end


@implementation JMHomeSearchGoodsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end

@implementation JMHomeSearchScreeningModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end



