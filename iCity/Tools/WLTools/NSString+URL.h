//
//  NSString+URL.h
//  Exquisite
//
//  Created by 数字宁波 on 2017/1/20.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)

- (NSString *)URLEncodedString;

- (BOOL)isIncludeSpecialCharacter;

@end
