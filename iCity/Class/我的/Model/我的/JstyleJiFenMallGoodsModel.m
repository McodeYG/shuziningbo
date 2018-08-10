//
//  JstyleJiFenMallGoodsModel.m
//  Exquisite
//
//  Created by 数字宁波 on 2017/2/28.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleJiFenMallGoodsModel.h"

@implementation JstyleJiFenMallGoodsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end
