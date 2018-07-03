//
//  ICityTVModel.m
//  ICityTable
//
//  Created by chunzheng wang on 2018/5/1.
//  Copyright © 2018年 chunzheng wang. All rights reserved.
//

#import "ICityTVModel.h"

@implementation ICityTVModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        _sendId = value;
    }
}



+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{ @"sendId" : @"id"  };
}

@end
