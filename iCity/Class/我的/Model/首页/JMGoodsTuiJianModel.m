//
//  JMGoodsTuiJianModel.m
//  Exquisite
//
//  Created by 数字宁波 on 16/6/8.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import "JMGoodsTuiJianModel.h"

@implementation JMGoodsTuiJianModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}


@end
