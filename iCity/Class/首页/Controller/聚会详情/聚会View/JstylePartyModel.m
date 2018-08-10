//
//  JstylePartyModel.m
//  Exquisite
//
//  Created by 数字宁波 on 2017/7/5.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstylePartyModel.h"

@implementation JstylePartyHomeModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end

@implementation JstyleMyPartyModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end

@implementation JstylePartySuccessInfoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
