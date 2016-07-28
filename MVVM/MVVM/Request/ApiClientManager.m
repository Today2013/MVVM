//
//  ApiClientManager.m
//  MVVM
//
//  Created by TomatoPeter on 16/7/25.
//  Copyright © 2016年 ChenJianglin. All rights reserved.
//

#import "ApiClientManager.h"
#import "NetURLCache.h"
@interface ApiClientManager ()
{
    AFHTTPSessionManager *_manager;
}
//并发量
@property(nonatomic, strong)NSMutableArray *queueArray;

@end

@implementation ApiClientManager
+ (instancetype)shareClientManager
{
    static dispatch_once_t onceToken;
    static ApiClientManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[ApiClientManager alloc] init];
    });
    return manager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.queueArray = [NSMutableArray arrayWithCapacity:1];
        _manager = [AFHTTPSessionManager manager];
        _manager.operationQueue.maxConcurrentOperationCount = 4;
    }
    return self;
}
//默认返回的是post请求
- (RequestMethod)requestMethod
{
    return RequestMethodPost;
}
- (NSString *)baseUrl
{
    return nil;
}
- (RequestSerializerType)requestSerializerType
{
    return RequestSerializerTypeHTTP;
}
- (ResponseSerializerType)responseSerializerType
{
    return ResponseSerializerTypeHTTP;
}
- (id)requestArgument;
{
    return nil;
}
- (NSURLSessionDataTask *)requestWithMethod:(RequestMethod)method
                                 requestUrl:(NSString *)requestUrl
                                   argument:(id)argument
                            successCallback:(void(^)(id responseObject))successCallback
                               failCallback:(void(^)(NSError * _Nonnull error, id cachedata))failCallback
                               UseCacheData:(BOOL)isUseCache

{
    NSMutableURLRequest *urlRequest = nil;
    NSURLSessionDataTask *dataTask = nil;
    if (method == RequestMethodGet) {
        dataTask = [_manager GET:requestUrl parameters:argument progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successCallback) {
                successCallback(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            id jsonCache = [ApiClientManager cachedResponseForRequest:task.currentRequest];
            if (isUseCache) {
                if (successCallback) {
                    if (jsonCache) {
                        successCallback(jsonCache);
                    }else{
                        failCallback(error, jsonCache);
                    }
                }
            }else{
                failCallback(error, jsonCache);
            }
            
        }];
        _manager.requestSerializer.timeoutInterval = 15;
    }else if (method == RequestMethodPost){
        dataTask = [_manager POST:requestUrl parameters:argument progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successCallback) {
                successCallback(responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            id jsonCache = [ApiClientManager cachedResponseForRequest:task.currentRequest];
            if (isUseCache) {
                if (successCallback) {
                    if (jsonCache) {
                        successCallback(jsonCache);
                    }else{
                        failCallback(error, jsonCache);
                    }
                }
            }else{
                failCallback(error, jsonCache);
            }
        }];
    }
    urlRequest = [dataTask.currentRequest mutableCopy];
    
    //如果网络不通达
//    if (!_manager.reachabilityManager.isReachable) {
//        //返回缓存数据
//        id cacheJSON = [ApiClientManager cachedResponseForRequest:urlRequest];//查找缓存数据
//        if (cacheJSON) {
//            successCallback(cacheJSON);
//            return dataTask;
//        }
//        
//    }
    
    if (isUseCache) {
        urlRequest.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        //设置request是否可以被缓存
        [urlRequest setValue:@"YES" forHTTPHeaderField:URLCACHE_CACHE_KEY];
        
        //设置request的缓存超时限制
        [urlRequest setValue:[NSString stringWithFormat:@"%f",15.0] forHTTPHeaderField:URLCACHE_EXPIRATION_AGE_KEY];

        //返回缓存数据
        id cacheJSON = [ApiClientManager cachedResponseForRequest:urlRequest];
        if (successCallback) {
            if (cacheJSON) {
                successCallback(cacheJSON);
            }
            
        }
        
    }
    [dataTask resume];
    return dataTask;
    
}
#pragma mark - 返回request的缓存数据
/**
 *  该方法来2次：
 *
 *      第一次，使用缓存数据时
 *      第二次，Operation被调度执行网络操作时
 */
+ (id)cachedResponseForRequest:(NSURLRequest *)request {
    
    NSCachedURLResponse* cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    
    AFHTTPResponseSerializer* serializer = [AFJSONResponseSerializer serializer];
    
    id responseObject = [serializer responseObjectForResponse:cachedResponse.response data:cachedResponse.data error:nil];
    
    return responseObject;
}


@end

