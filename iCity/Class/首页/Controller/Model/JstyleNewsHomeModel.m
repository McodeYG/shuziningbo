//
//  JstyleNewsHomeModel.m
//  JstyleNews
//
//  Created by 数字宁波 on 2017/10/25.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsHomeModel.h"

@implementation JstyleNewsHomePageModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    if ([key isEqualToString:@"id"]) {
//        self.ID = value;
//    }
}



//相当于泛型说明
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"otherBanner"     : [OtherBannerModel class]
             };
}



@end

@implementation OtherBannerModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
        if ([key isEqualToString:@"id"]) {
            self.sendid = value;
        }
}

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{ @"sendId" : @"id"  };
}

@end

