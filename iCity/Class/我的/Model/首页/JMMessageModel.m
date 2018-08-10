//
//  JMHomeMessageModel.m
//  Exquisite
//
//  Created by 数字宁波 on 16/7/5.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import "JMMessageModel.h"

@implementation JMMyMsgTradingRemindModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end


@implementation JMTradingRemindModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end


@implementation JMLogisticsRemindModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end


@implementation JMSystemRemindModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end

@implementation JMOtherRemindModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end




