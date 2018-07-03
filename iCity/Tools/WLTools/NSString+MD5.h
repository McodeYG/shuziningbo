//
//  NSString+Base64.h
//  MD5加密
//
//  Created by 赵涛 on 16/3/14.
//  Copyright © 2016年 Dark Knight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

/**
 *  MD5加密
 */
+ (NSString *)getMD5StringFromString:(NSString *)str;

@end
