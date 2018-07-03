//
//  JMStarHomeModel.m
//  Exquisite
//
//  Created by 赵涛 on 16/6/8.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import "JMStarHomeModel.h"

@implementation JMStarHomeModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end
