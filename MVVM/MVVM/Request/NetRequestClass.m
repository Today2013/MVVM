//
//  NetRequestClass.m
//  MVVM
//
//  Created by TomatoPeter on 16/7/22.
//  Copyright © 2016年 ChenJianglin. All rights reserved.
//

#import "NetRequestClass.h"

@implementation NetRequestClass
#pragma 监测网络的可链接性
+ (void) netWorkReachabilityWithURLString:(NSString *)strUrl
                                    block:(void(^)(BOOL))block
{
    NSURL *url = [NSURL URLWithString:strUrl];
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    NSOperationQueue *operationQueue = sessionManager.operationQueue;
    [sessionManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                //继续queue
                [operationQueue setSuspended:NO];
                block(YES);
                break;
            case AFNetworkReachabilityStatusNotReachable:
                //暂停queue
                [operationQueue setSuspended:YES];
                block(NO);
            default:
                break;
        }
        
    }];
    [sessionManager.reachabilityManager startMonitoring];
}
@end
