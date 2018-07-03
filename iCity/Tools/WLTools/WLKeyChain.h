//
//  WLKeyChain.h
//  JstyleNews
//
//  Created by 王磊 on 2018/2/12.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface WLKeyChain : NSObject

/**
 *  存储字符串到 KeyChain
 *
 *  @param string NSString
 */
+ (void)keyChainSave:(NSString *)string;

/**
 *  从 KeyChain 中读取存储的字符串
 *
 *  @return NSString
 */
+ (NSString *)keyChainLoad;

/**
 *  删除 KeyChain 信息
 */
+ (void)keyChainDelete;

@end
