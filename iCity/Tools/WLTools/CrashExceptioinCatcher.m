//
//  CrashExceptioinCatcher.m
//  异常退出demo
//
//  Created by 数字跃动 on 2017/9/19.
//  Copyright © 2017年 王磊. All rights reserved.
//

#import "CrashExceptioinCatcher.h"
#import "FMDatabase.h"
// 提交异常Log信息
void uncaughtExceptionHandler(NSException *exception) {
    // 异常Log信息
    NSString *logInfo = [NSString stringWithFormat:@"崩溃了:\n%@\nStack Trace:\n%@\n",
                         [exception description], [exception callStackSymbols]];
    NSLog(@"%@", logInfo);
}

@implementation CrashExceptioinCatcher

+ (void)startCrashExceptionCatch
{
    // Sets the top-level error-handling function where you can perform last-minute logging before the program terminates.
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler); //设置异常Log信息的处理
}

@end
