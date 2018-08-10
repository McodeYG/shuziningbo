//
//  JMMyJiFenModel.m
//  Exquisite
//
//  Created by 数字宁波 on 16/6/15.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import "JMMyJiFenModel.h"

@implementation JMMyJiFenModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end
