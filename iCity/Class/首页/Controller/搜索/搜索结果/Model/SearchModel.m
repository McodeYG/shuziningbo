//
//  SearchModel.m
//  iCity
//
//  Created by mayonggang on 2018/6/12.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _sendId = value;
    }
}

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{ @"sendId" : @"id"  };
}

//相当于泛型说明
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"searchRsResult" : [SearchAboutPersonModel class],
             @"authorList"     : [SearchAboutPersonModel class]
             };
}


@end


@implementation SearchAboutPersonModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
   
}



@end
