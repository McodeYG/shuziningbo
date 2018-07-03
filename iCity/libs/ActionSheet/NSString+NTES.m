//
//  NSString+NTES.m
//  LiveStream_IM_Demo
//
//  Created by Netease on 17/1/9.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NSString+NTES.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (NTES)


- (CGSize)stringSizeWithFont:(UIFont *)font{
    return [self sizeWithAttributes:@{NSFontAttributeName:font}];
}

- (NSUInteger)getBytesLength
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [self lengthOfBytesUsingEncoding:enc];
}


- (NSString *)stringByDeletingPictureResolution{
    NSString *doubleResolution  = @"@2x";
    NSString *tribleResolution = @"@3x";
    NSString *fileName = self.stringByDeletingPathExtension;
    NSString *res = [self copy];
    if ([fileName hasSuffix:doubleResolution] || [fileName hasSuffix:tribleResolution]) {
        res = [fileName substringToIndex:fileName.length - 3];
        if (self.pathExtension.length) {
            res = [res stringByAppendingPathExtension:self.pathExtension];
        }
    }
    return res;
}

//房间号，纯数字
+ (BOOL)checkRoomNumber:(NSString *)roomNumber
{
    NSString *pattern =@"^[0-9]*$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    
    BOOL isMatch = [pred evaluateWithObject:roomNumber];
    
    return isMatch;
}

+ (BOOL)checkPullUrl: (NSString *) pullUrl
{
    BOOL isMatch = YES;
    
    if (pullUrl == nil || pullUrl.length == 0) {
        isMatch = NO;
    }
    
    if (![pullUrl hasPrefix:@"http://"] && ![pullUrl hasPrefix:@"rtmp://"]) {
        isMatch = NO;
    }
    
    return isMatch;
}

//1-20位数字或者字母
+ (BOOL)checkUserName:(NSString*) username
{
    NSString *pattern =@"^[A-Za-z0-9]{1,20}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    
    BOOL isMatch = [pred evaluateWithObject:username];
    
    return isMatch;
}

//6-20位字母或数字
+ (BOOL)checkPassword:(NSString*) password
{
    NSString *pattern =@"^[A-Za-z0-9]{6,20}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    
    BOOL isMatch = [pred evaluateWithObject:password];
    
    return isMatch;
}

//6-20位数字或者字母
+ (BOOL)checkNickName : (NSString*) nickName
{
    NSString *pattern =@"^[\u4E00-\u9FA5A-Za-z0-9]{1,10}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    
    BOOL isMatch = [pred evaluateWithObject:nickName];
    
    return isMatch;
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName: font};
    CGSize textSize = [self boundingRectWithSize:maxSize
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:dict
                                         context:nil].size;
    return textSize;
}

@end
