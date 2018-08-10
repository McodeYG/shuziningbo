//
//  NSString+Extension.h
//  Exquisite
//
//  Created by 数字宁波 on 2017/1/20.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (NSString *)URLEncodedString;

/**是否含有特殊字符*/
- (BOOL)isIncludeSpecialCharacter;

/**是否是空串*/
- (BOOL)isEmptyEstring;

/**数字字符串处理*/
- (NSString *)dealNumberStr;

/**城市百科数字字符串处理*/
//- (NSString *)dealWanNumberStr;

/**时间戳*/
- (NSString *)dealTimeStr;

/**阅览室期刊类型*/
- (NSString *)bookType;

/**判断是否有emoji*/
+(BOOL)stringContainsEmoji:(NSString *)string;
///**获取字符创高度*/
//-(float)heightWithfont:(float)font width:(float)width

@end
