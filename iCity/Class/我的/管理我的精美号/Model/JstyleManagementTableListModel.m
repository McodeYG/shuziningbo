//
//  JstyleManagementTableListModel.m
//  Exquisite
//
//  Created by 数字跃动 on 2017/10/11.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleManagementTableListModel.h"

@implementation JstyleManagementTableListModel


@end

@implementation JstyleManagementMyMessageModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end


