//
//  NewspaperModel.m
//  iCity
//
//  Created by mayonggang on 2018/6/14.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "NewspaperModel.h"

@implementation NewspaperModel



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
