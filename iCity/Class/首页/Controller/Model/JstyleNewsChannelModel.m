//
//  JstyleNewsChannelModel.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/8.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsChannelModel.h"

@implementation JstyleNewsChannelModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end
