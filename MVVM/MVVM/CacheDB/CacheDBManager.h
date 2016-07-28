//
//  CacheDBManager.h
//  MVVM
//
//  Created by TomatoPeter on 16/7/27.
//  Copyright © 2016年 ChenJianglin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheDBManager : NSObject
+ (instancetype)shareCacheDBManager;
- (void)createGroupPersonInfoTable;
- (void)insertData:(int)fromIndex useTransaction:(BOOL)useTransaction;
- (NSMutableArray *)query:(NSString *)table where:(NSString *)where, ...;
//版本升级
- (void)versionUpdate;
@end
