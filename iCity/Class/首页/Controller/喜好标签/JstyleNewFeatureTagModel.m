//
//  JstyleNewFeatureTagModel.m
//  Exquisite
//
//  Created by 数字跃动 on 2017/8/24.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleNewFeatureTagModel.h"

@implementation JstyleNewFeatureTagModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)newFeatureTagModelWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}
@end
