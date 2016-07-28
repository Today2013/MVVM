//
//  CacheDBManager.m
//  MVVM
//
//  Created by TomatoPeter on 16/7/27.
//  Copyright © 2016年 ChenJianglin. All rights reserved.
//

#import "CacheDBManager.h"
#import "FMDB.h"
@interface CacheDBManager ()
@property(nonatomic, strong)FMDatabase *ifmDB;
@end
@implementation CacheDBManager
+ (instancetype)shareCacheDBManager
{
    static dispatch_once_t onceToken;
    static CacheDBManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[CacheDBManager alloc] init];
    });
    return manager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
//        通常一次 sqlite3_exec 就是一次事务，假如你要对数据库中的Stutent表插入新数据，那么该事务的具体过程是：开始新事物->插入数据->提交事务，那么当我们要往该表内插入500条数据，如果按常规操作处理就要执行500次“开始新事物->插入数据->提交事务”的过程。
        
    }
    return self;
}
//版本升级
- (void)versionUpdate
{
    [self openDB];
    if (![self.ifmDB columnExists:@"userId" inTableWithName:@"GroupPersonInfo"]) {
        NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ text", @"GroupPersonInfo", @"userId"];
       BOOL BO = [self.ifmDB executeUpdate:sql];
        NSString *update = [NSString stringWithFormat:@"UPDATE %@ SET %@=? WHERE %@='%@'", @"GroupPersonInfo", @"userId", @"100"];
        [self.ifmDB executeUpdate:update];
    }
    
    
    [self closeDB];
    
    NSLog(@"%d", [FMDatabase FMDBVersion]);
}
- (BOOL)openDB
{
    NSString *DBFilePath = [self getFilePathWithDBName:@"mydatadb"];
    if (!self.ifmDB) {
        self.ifmDB = [[FMDatabase alloc] initWithPath:DBFilePath];
        [self.ifmDB setShouldCacheStatements:YES];
    }
    if (![self.ifmDB open]) {
        [self.ifmDB close];
        return NO;
    }
    return YES;
    
}
- (void)insertData:(int)fromIndex useTransaction:(BOOL)useTransaction
{
    [self openDB];
    if (useTransaction) {
        [self.ifmDB beginTransaction];
        BOOL isRollBack = NO;
        @try {
            for (int i = fromIndex; i<500+fromIndex; i++) {
                NSString *nId = [NSString stringWithFormat:@"%d",i];
                NSString *phone= [[NSString alloc] initWithFormat:@"phone_%d",i];
                NSString *strName = [[NSString alloc] initWithFormat:@"name_%d",i];
                NSString *roomID= [[NSString alloc] initWithFormat:@"roomid_%d",i];
                NSString *userId = [[NSString alloc] initWithFormat:@"userId_%d",i];
                NSString *sql = @"INSERT INTO GroupPersonInfo(phone,name,userId,groupRoomId) VALUES (?,?,?,?)";
                
                BOOL a = [self.ifmDB executeUpdate:sql,phone,strName, userId,roomID];
                if (!a) {
                    NSLog(@"插入失败1");
                }
            }
        }
        @catch (NSException *exception) {
            isRollBack = YES;
            [self.ifmDB rollback];
        }
        @finally {
            if (!isRollBack) {
                [self.ifmDB commit];
            }
        }
    }else{
        for (int i = fromIndex; i<500+fromIndex; i++) {
            NSString *nId = [NSString stringWithFormat:@"%d",i];
            NSString *phone= [[NSString alloc] initWithFormat:@"phone_%d",i];
            NSString *strName = [[NSString alloc] initWithFormat:@"name_%d",i];
            NSString *roomID= [[NSString alloc] initWithFormat:@"roomid_%d",i];
            NSString *sql = @"INSERT INTO GroupPersonInfo(phone,name,groupRoomId) VALUES (?,?,?)";
            BOOL a = [self.ifmDB executeUpdate:sql,phone,strName,roomID];
            if (!a) {
                NSLog(@"插入失败2");
            }
        }
    }
    [self closeDB];
}
- (BOOL) closeDB
{
    NSLog(@"closeDB");
    if (self.ifmDB)
    {
        return [self.ifmDB close];
    }
    return NO;
}
- (void)createGroupPersonInfoTable
{
    if ([self openDB]) {
        if (![self.ifmDB tableExists:@"GroupPersonInfo"]) {
            BOOL sucess = [self.ifmDB executeUpdate:@"CREATE TABLE GroupPersonInfo (uid INTEGER PRIMARY KEY AUTOINCREMENT,\
                           phone TEXT,\
                           name TEXT,\
                           userId TEXT,\
                           groupRoomId TEXT)"];
            if (!sucess) {
                NSLog(@"创建个人信息表失败");
            }else{
                NSLog(@"创建个人信息表成功");
            }
        }
    }
}
//- (NSMutableArray *)qureyRemindSleepTimeUserId:(NSString *)userId type:(NSString *)type
//{
//    return [self query:@"GroupPersonInfo" where:nil];
//}
- (NSMutableArray *)query:(NSString *)table where:(NSString *)where, ...
{
    @autoreleasepool {
        NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:1];
        NSString *sql = nil;
        va_list args;
        if (where) {
            va_start(args, where);
            sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@", table, where];
        }else{
            sql = [NSString stringWithFormat:@"SELECT * FROM %@", table];
        }
        
        if ([self openDB]) {
            FMResultSet * rs = [self.ifmDB executeQuery:sql withVAList:args];
            while ([rs next]) {
                [result addObject:[rs resultDictionary]];
            }
        }
        
        [self.ifmDB close];
        va_end(args);
        return result;
    }
}
/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}
/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithDBName:(NSString *)DBName
{
    if (DBName) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:DBName];
        return filePath;
    }
    return nil;
}

@end




