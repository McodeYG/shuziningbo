//
//  JstyleNewsNetworkManager.h
//  JstyleNews
//
//  Created by 王磊 on 2017/9/13.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
//#import <AFURLRequestSerialization.h>

@interface JstyleNewsNetworkManager : AFHTTPSessionManager


/**
 封装网络管理工具类
 */
+ (instancetype)shareManager;

/**
 封装GET请求(无进度回调)
 
 @param url 请求url
 @param paramaters 请求参数
 @param success 成功回调数据
 @param failure 失败回调数据
 */
- (void)GETURL:(NSString *)url parameters:(id)paramaters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

/**
 封装GET请求
 
 @param url 请求url
 @param paramaters 请求参数
 @param success 成功回调数据
 @param failure 失败回调数据
 */
- (void)GETURL:(NSString *)url parameters:(id)paramaters  progress:(void(^)(NSProgress *))progress success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

/**
 封装POST请求(无进度回调)
 
 @param url 请求url
 @param paramaters 请求参数
 @param success 成功回调
 @param failure 失败回调
 */
- (void)POSTURL:(NSString *)url parameters:(id)paramaters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

/**
 封装POST请求

 @param url 请求url
 @param paramaters 请求参数
 @param progress 加载进度
 @param success 成功回调
 @param failure 失败回调
 */
- (void)POSTURL:(NSString *)url parameters:(id)paramaters progress:(void(^)(NSProgress *))progress success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;


NS_ASSUME_NONNULL_BEGIN
/**
 封装上传表单数据(POST)

 @param url 请求url
 @param parameters 请求参数
 @param block 拼接表单数据block
 @param uploadProgress 上传进度
 @param success 成功回调
 @param failure 失败回调
 @return 数据任务
 */
- (nullable NSURLSessionDataTask *)UPLoadFormdataWithURL:(nullable NSString *)url
                   parameters:(nullable id)parameters
    constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                     progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                      success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                      failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;
NS_ASSUME_NONNULL_END

@end
