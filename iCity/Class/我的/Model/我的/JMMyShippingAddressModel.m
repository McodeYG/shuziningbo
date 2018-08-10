//
//  JMMyShippingAddressModel.m
//  Exquisite
//
//  Created by 数字宁波 on 16/6/12.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import "JMMyShippingAddressModel.h"

@implementation JMMyShippingAddressModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end
