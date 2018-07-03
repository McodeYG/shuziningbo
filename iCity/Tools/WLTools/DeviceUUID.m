//
//  DeviceUUID.m
//  Exquisite
//
//  Created by 赵涛 on 2017/9/15.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "DeviceUUID.h"
#import "KeyChainStore.h"
#define  KEY_USERNAME_PASSWORD @"cn.jstylenews.app.usernamepassword"
#define  KEY_USERNAME @"cn.jstylenews.app.username"
#define  KEY_PASSWORD @"cn.jstylenews.app.password"

@implementation DeviceUUID

+ (NSString *)getUUID
{
    NSString * strUUID = (NSString *)[KeyChainStore load:KEY_USERNAME_PASSWORD];
    //首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || !strUUID)
    {
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        //将该uuid保存到keychain
        [KeyChainStore save:KEY_USERNAME_PASSWORD data:strUUID];
        
    }
    return strUUID;
}

@end
