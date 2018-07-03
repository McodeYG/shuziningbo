//
//  NSString+NTES.h
//  LiveStream_IM_Demo
//
//  Created by Netease on 17/1/9.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (NTES)

- (CGSize)stringSizeWithFont:(UIFont *)font;

- (NSUInteger)getBytesLength;

- (NSString *)stringByDeletingPictureResolution;

+ (BOOL)checkRoomNumber:(NSString *)roomNumber;

+ (BOOL)checkUserName:(NSString*) username;

+ (BOOL)checkPassword:(NSString*) password;

+ (BOOL)checkNickName : (NSString*) nickName;

+ (BOOL)checkPullUrl: (NSString *) pullUrl;

/**
 *  计算文本占用的宽高
 *
 *  @param font    显示的字体
 *  @param maxSize 最大的显示范围
 *
 *  @return 占用的宽高
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

@end
