//
//  JstyleNewsNetworkManager.m
//  JstyleNews
//
//  Created by 王磊 on 2017/9/13.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsNetworkManager.h"

@implementation JstyleNewsNetworkManager

+ (instancetype)shareManager {
    
    static JstyleNewsNetworkManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] initWithBaseURL:nil];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",nil];
        manager.requestSerializer.timeoutInterval = 8;
    });
    return manager;
}

- (void)GETURL:(NSString *)url parameters:(id)paramaters success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    if (url) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
        [manager GET:url parameters:paramaters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(responseObject);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (failure == nil) {
                NSLog(@"%@",error);
            }else {
                failure(error);
            }
        }];
    }
}

- (void)GETURL:(NSString *)url parameters:(id)paramaters progress:(void (^)(NSProgress *))progress success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    [manager GET:url parameters:paramaters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure == nil) {
            NSLog(@"%@",error);
        }else {
            failure(error);
        }
    }];
}

- (void)POSTURL:(NSString *)url parameters:(id)paramaters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    [manager POST:url parameters:paramaters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (failure == nil) {
            NSLog(@"%@",error);
        }else {
            failure(error);
        }
    }];
}

- (void)POSTURL:(NSString *)url parameters:(id)paramaters progress:(void (^)(NSProgress *))progress success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    [manager POST:url parameters:paramaters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure == nil) {
            NSLog(@"%@",error);
        }else {
            failure(error);
        }
    }];
}

- (NSURLSessionDataTask *)UPLoadFormdataWithURL:(NSString *)url parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> _Nonnull))block progress:(void (^)(NSProgress * _Nonnull))uploadProgress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    return [manager POST:url parameters:parameters constructingBodyWithBlock:block progress:uploadProgress success:success failure:failure];
}

@end
