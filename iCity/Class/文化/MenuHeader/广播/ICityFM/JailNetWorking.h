//
//  JailNetWorking.h
//  LeaonWorking
//
//  Created by mac on 15/8/27.
//  Copyright (c) 2015年 leaon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JailNetWorking : NSObject

+ (void)netWorkingHanderGetGataWithUrl:(NSString *)urlStr resultBlock:(void(^)(id result))resultBlock;

@end
