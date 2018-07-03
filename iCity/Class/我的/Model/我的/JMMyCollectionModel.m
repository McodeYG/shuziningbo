//
//  JMMyCollectionGoodsModel.m
//  Exquisite
//
//  Created by 赵涛 on 16/6/13.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import "JMMyCollectionModel.h"

@implementation JMMyCollectionGoodsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end

@implementation JMMyCollectionZixunModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end

@implementation JMMyCollectionDianboModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end