//
//  JstyleLiveWatchBuyModel.m
//  Exquisite
//
//  Created by 数字宁波 on 16/10/14.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import "JstyleLiveWatchBuyModel.h"

@implementation JstyleLiveWatchBuyModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end
