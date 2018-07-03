//
//  JailNetWorking.m
//  LeaonWorking
//
//  Created by mac on 15/8/27.
//  Copyright (c) 2015年 leaon. All rights reserved.
//

#import "JailNetWorking.h"
#import <AFNetworking.h>

@implementation JailNetWorking

- (void)getDataWithUrl:(NSString *)urlStr resultBlock:(void(^)(id result))block
{
    NSLog(@"%@", urlStr);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain", nil];

    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        block(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"Request Error : %@", error);
        }
    }];
}


/* 网络请求直接带上文件名参数 文件存储  */
+ (void)netWorkingHanderGetGataWithUrl:(NSString *)urlStr resultBlock:(void(^)(id result))resultBlock {
    JailNetWorking *jailWork = [[JailNetWorking alloc] init];
    [jailWork getDataWithUrl:urlStr resultBlock:resultBlock];
}
@end
