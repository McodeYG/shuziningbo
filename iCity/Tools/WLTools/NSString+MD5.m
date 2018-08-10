//
//  NSString+Base64.h
//  MD5加密
//
//  Created by 数字宁波 on 16/3/14.
//  Copyright © 2016年 Dark Knight. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)

/**
 *  MD5加密
 *
 *  @param str        传入的普通string
 *
 *  @return           返回的MD5加密过的string
 */
+ (NSString *)getMD5StringFromString:(NSString *)str
{
    // 把普通string转化为UTF8String
    const char *string = [str UTF8String];
    
    // 创建无符号字符的字节数组
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // 创建16byte的MD5散列值, 存入md5Buffer
    CC_MD5(string, (unsigned int)strlen(string), md5Buffer);
    
    // 在md5Buffer的MD5值转换为NSString十六进制值
    NSMutableString *md5String = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [md5String appendFormat:@"%02x",md5Buffer[i]];
    
    return md5String;
}

@end
