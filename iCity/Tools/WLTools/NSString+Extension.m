//
//  NSString+Extension.m
//  Exquisite
//
//  Created by 赵涛 on 2017/1/20.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (NSString *)URLEncodedString
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,NULL ,CFSTR("!*'();:@&=+$,/?%#[]") ,kCFStringEncodingUTF8));
      return encodedString;
}

- (BOOL)isIncludeSpecialCharacter{
    NSRange urgentRange = [self rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€，。、/ "]];
    if (urgentRange.location == NSNotFound) return NO;
    return YES;
}

- (BOOL)isEmptyEstring
{
    if (self == nil || [self isEqualToString:@""] || [self isEqualToString:@"(null)"] || [self isEqualToString:@"<null>"] || [self isEqualToString:@"null"]) {
        return YES;
    }
    return NO;
}

/**数字字符串处理*/
- (NSString *)dealNumberStr {
    if ([self isEmptyEstring]) {
        return @"0";
    }
    float num = [self floatValue];
    if (num>9999999) {
        return [NSString stringWithFormat:@"%f千万",num/10000000];
        
    }
    if (num>9999) {
        return [NSString stringWithFormat:@"%.1f万",num/10000];
        
    }
    
    return self;
}

///**城市百科数字字符串处理*/
//- (NSString *)dealWanNumberStr {
//    if ([self isEmptyEstring]) {
//        return @"0";
//    }
//    float num = [self floatValue];
//    
//    if (num>9999) {
//        return [NSString stringWithFormat:@"%f万",num/10000];
//        
//    }
//    
//    return self;
//}
/**时间戳*/
- (NSString *)dealTimeStr {
    if ([self isEmptyEstring]) {
        return @" ";
    }
    

    NSTimeInterval interval    =[self doubleValue]/1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"]; // yyyy-MM-dd HH:mm:ss
    NSString *dateString       = [formatter stringFromDate: date];
    

    return dateString;
}
- (NSString *)bookType {
    
    if ([self integerValue]==1) {
        return  @"#图书";
    }else if ([self integerValue]==2) {
        return  @"#期刊";
    }else if ([self integerValue]==3) {
        return  @"#音频";
    }else {
        return  @"#视频";
    }
}


//判断是否有emoji
+(BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar high = [substring characterAtIndex: 0];
                                
                                // Surrogate pair (U+1D000-1F9FF)
                                if (0xD800 <= high && high <= 0xDBFF) {
                                    const unichar low = [substring characterAtIndex: 1];
                                    const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                    
                                    if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                        returnValue = YES;
                                    }
                                    
                                    // Not surrogate pair (U+2100-27BF)
                                } else {
                                    if (0x2100 <= high && high <= 0x27BF){
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}


@end
