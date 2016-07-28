//
//  NetRequestClass.h
//  MVVM
//
//  Created by TomatoPeter on 16/7/22.
//  Copyright © 2016年 ChenJianglin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetRequestClass : NSObject
#pragma 监测网络的可链接性
+ (void) netWorkReachabilityWithURLString:(NSString *)strUrl
                                    block:(void(^)(BOOL))block;
@end
