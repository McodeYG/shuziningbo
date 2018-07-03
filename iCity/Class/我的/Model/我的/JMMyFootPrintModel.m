//
//  JMMyFootPrintModel.m
//  Exquisite
//
//  Created by 赵涛 on 16/6/15.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import "JMMyFootPrintModel.h"

@implementation JMMyFootPrintGoodsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end

@implementation JMMyFootPrintZixunModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end

@implementation JMMyFootPrintDianboModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end