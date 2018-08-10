//
//  JstyleLiveAnchorTalkModel.m
//  Exquisite
//
//  Created by 数字宁波 on 16/10/11.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import "JstyleLiveAnchorTalkModel.h"

@implementation JstyleLiveAnchorTalkModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end
