//
//  JstylePersonalMediaModel.m
//  Exquisite
//
//  Created by 数字宁波 on 2017/8/7.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstylePersonalMediaModel.h"

@implementation JstylePersonalMediaListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end

@implementation JstylePersonalMediaIntroModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end

@implementation JstylePersonalMediaDetailModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end

@implementation JstyleJmNumsDetailTitleModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end

