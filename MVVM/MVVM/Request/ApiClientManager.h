//
//  ApiClientManager.h
//  MVVM
//
//  Created by TomatoPeter on 16/7/25.
//  Copyright © 2016年 ChenJianglin. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger , RequestMethod) {
    RequestMethodGet = 0,
    RequestMethodPost,
    RequestMethodHead,
    RequestMethodPut,
    RequestMethodDelete,
    RequestMethodPatch
};
typedef NS_ENUM(NSInteger, RequestSerializerType) {
    RequestSerializerTypeHTTP = 0,
    RequestSerializerTypeJSON = 1
};
typedef NS_ENUM(NSInteger, ResponseSerializerType) {
    ResponseSerializerTypeHTTP = 0,
    ResponseSerializerTypeJSON = 1
};
@interface ApiClientManager : NSObject
+ (instancetype)shareClientManager;
/**
 *  请求的方法
 *
 *  @return
 */
- (RequestMethod)requestMethod;
/**
 *  请求的BaseUrl
 *
 *  @return 字符串
 */
- (NSString *)baseUrl;
/**
 *  请求的SerializerType
 *
 *  @return <#return value description#>
 */
- (RequestSerializerType)requestSerializerType;
/**
 *  返回的responseSerializerType
 *
 *  @return <#return value description#>
 */
- (ResponseSerializerType)responseSerializerType;
/**
 *  请求的参数列表
 *
 *  @return <#return value description#>
 */
- (id)requestArgument;
- (NSURLSessionDataTask *)requestWithMethod:(RequestMethod)method
                                 requestUrl:(NSString *)requestUrl
                                   argument:(id)argument
                            successCallback:(void(^)(id responseObject))successCallback
                               failCallback:(void(^)(NSError * _Nonnull error, id cachedata))failCallback
                               UseCacheData:(BOOL)isUseCache;
@end
