//
//  UIColor+XY.m
//  Exquisite
//
//  Created by 赵涛 on 16/3/16.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import "NSDate+Util.h"

@implementation NSDate (Util)

+ (NSString *)compareCurrentTimeWithTimeString:(NSString *)timeString
{
    if (timeString == nil || [timeString isEqualToString:@""] || timeString.length < 10) {
        return timeString;
    }
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *currentDate =  [NSDate dateWithTimeIntervalSinceNow:8 * 3600];
    NSString *currentTimeStr = [NSString stringWithFormat:@"%lld", (long long)[currentDate timeIntervalSince1970]];

    NSDate *getTimeDate  = [[formatter dateFromString:timeString] dateByAddingTimeInterval:8 * 3600];
    NSString *getTimeStr = [NSString stringWithFormat:@"%lld", (long long)[getTimeDate timeIntervalSince1970]];
    
    NSInteger dTime = [currentTimeStr integerValue] - [getTimeStr integerValue];
    
    if (dTime < 60) {
        return @"刚刚";
    }
    
    if (dTime < 60 * 60) {
        return [NSString stringWithFormat:@"%ld分钟前", dTime / 60];
    }
    
    if (dTime < 60 * 60 * 24) {
        return [NSString stringWithFormat:@"%ld小时前", dTime / (60 * 60)];
    }
    if (dTime < 60 * 60 * 24 *4) {
        return [NSString stringWithFormat:@"%ld天前", dTime / (60 * 60 * 24)];
    }
    
    if (timeString.length > 9) {
        return [timeString substringWithRange:NSMakeRange(0, 10)];
    }
    return timeString;
}

+ (NSString *)currentTimeString
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateNow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:dateNow];
    return currentTimeString;
}

@end
