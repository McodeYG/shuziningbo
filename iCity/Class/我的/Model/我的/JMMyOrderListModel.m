//
//  JMMyOrderListModel.m
//  Exquisite
//
//  Created by 数字宁波 on 16/6/29.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import "JMMyOrderListModel.h"

@implementation JMMyAllOrderListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end


@implementation JMMyDaiFuKuanModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end


@implementation JMMyDaiFaHuoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end


@implementation JMMyDaiShouHuoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end


@implementation JMMyYiChengJiaoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end

