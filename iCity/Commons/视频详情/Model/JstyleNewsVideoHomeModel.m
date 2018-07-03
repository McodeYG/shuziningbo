//
//  JstyleNewsVideoHomeModel.m
//  JstyleNews
//
//  Created by 赵涛 on 2017/10/30.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsVideoHomeModel.h"

@implementation JstyleNewsVideoHomeModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _sendId = value;
    }
}
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{ @"sendId" : @"id"  };
}

@end
