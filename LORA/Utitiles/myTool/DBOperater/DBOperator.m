//
//  DBOperater.m
//  MSDDataCache
//
//  Created by TszFung D. Lam on 15/7/19.
//  Copyright (c) 2015年 TszFung D. Lam. All rights reserved.
//

#import "DBOperator.h"
#import "FMDB.h"
#import "NSString+wrapper.h"

#define kDBPath @"msdcache.db"
#define kTableNAME @"MSDCache"
#define kMid @"Mid"
#define kAddDate @"addDate"
#define kIdentify @"identify"
#define kDatas @"datas"

#define TODAY [NSData data]

@interface DBOperator () {
    FMDatabaseQueue *_dbQueue;
}
@property (nonatomic, copy) NSString *basePath; // 库名

@end

@implementation DBOperator

#pragma mark - 初始化

static DBOperator *_shareInstance;
// 全局的数据库管理实例
+ (DBOperator *)sharedDBOperater {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _shareInstance = [self new];
        [_shareInstance initWithBasePath:kDBPath];// 初始化库
    });
    return _shareInstance;
}
// 关闭并销毁数据库
- (void)close {
    [_dbQueue close];
    _shareInstance = nil;
}

#pragma mark - private

- (NSString *)dbPath:(NSString *)dbName {
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
             objectAtIndex:0]
            stringByAppendingPathComponent:dbName];
}
// 以basePath（库名）初始化
- (void)initWithBasePath:(NSString *)basePath {
    self.basePath = basePath; // 保存
    [self dataBaseInit:basePath];
}

- (void)dataBaseInit:(NSString *)path {
    
    // 取得队列 （拼接文件路径）
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:[self dbPath:path]];
    if (!_dbQueue) return NSLog(@"open membersDB failed");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [_dbQueue inDatabase:^(FMDatabase *db) {
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' BLOB)",kTableNAME,kMid,kAddDate,kIdentify,kDatas];
            [db executeUpdate:sql];
        }];
    });
    
}

- (void)executeWithSuccess:(BOOL)success
                  rollback:(BOOL)rollback
                completion:(void(^)(BOOL success))completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"--store-");
        if (rollback) {
            completion(NO);
        }else{
            completion(success);
        }
    });
}

- (void)asynchronousOperatDBInTransaction:(void(^)(FMDatabase *db, BOOL *rollback))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_dbQueue inTransaction:completion];
    });
}

- (void)asynchronousOperatDBInDB:(void(^)(FMDatabase *db))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_dbQueue inDatabase:completion];
    });
}

#pragma mark - 数据库操作

#pragma mark - 存储 保存到数据库
- (void)storeToDB:(id<NSCoding>)data key:(NSString *)key completion:(void(^)(BOOL success))completion {
    
    if (!data || [NSString isEmptyOrNull:key]) {
//        NSLog(@"---no store---");
        if (completion) return completion(NO);
        
    }
    
    [self asynchronousOperatDBInTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO MSDCache(%@,%@,%@) VALUES(?,?,?)",kAddDate,kIdentify,kDatas];
        BOOL success = [db executeUpdate:sql,[NSString timestamp],key,[NSKeyedArchiver archivedDataWithRootObject:data]];
//        NSLog(@"success = %d",success);
        [self executeWithSuccess:success
                        rollback:*rollback
                      completion:completion];
    }];
}
// 根据key从数据库获取
- (void)queryWithKey:(NSString *)key completion:(void(^)(id<NSCoding> data, NSString *storeDate))completion {
    
    [self asynchronousOperatDBInDB:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@=?",kTableNAME,kIdentify];
        FMResultSet *rs = [db executeQuery:sql,key];
        if ([rs next]) {
            id data = [rs dataForColumn:kDatas];
            NSString *storeDate = [rs stringForColumn:kAddDate];
            [rs close];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(data,storeDate);
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil,nil);
        });

    }];
}

#pragma makr - 查询  获取数据库所有的条目
- (void)query:(void(^)(NSArray *array))completion {
    
    [self asynchronousOperatDBInDB:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",kTableNAME];
        FMResultSet *rs = [db executeQuery:sql];
        NSMutableArray *arrM = [NSMutableArray array];
        
        while ([rs next]) {
            NSDictionary *dict = @{
                                   @"data":[rs dataForColumn:kDatas],
                                   @"storeDate":[rs stringForColumn:kAddDate]
                                   };
            [arrM addObject:dict];
        }
        [rs close];
        completion(arrM);
    }];
}

#pragma mark - 指定删除  根据key从数据库删除条目
- (void)removeDataFromDB:(NSString *)key completion:(void(^)(BOOL success))completion {
    
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@=?",kTableNAME,kIdentify];
        [self executeWithSuccess:[db executeUpdate:sql,key] rollback:*rollback completion:completion];
    }];
}

#pragma mark - 删除所有  删除所有条目
- (void)removeAll:(void(^)(BOOL success))completion {
    
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",kTableNAME];
        [self executeWithSuccess:[db executeUpdate:sql] rollback:*rollback completion:completion];
    }];
}

#pragma mark - 删除  根据指定数量删除条目
- (void)removeOfLimitCount:(NSUInteger)count completion:(void(^)(BOOL success))completion {
    
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ IN (SELECT %@ FROM %@ ORDER BY %@ LIMIT 0,%lu)",kTableNAME,kMid,kMid,kTableNAME,kMid,(unsigned long)count];
        [self executeWithSuccess:[db executeUpdate:sql] rollback:*rollback completion:completion];
    }];
}

#pragma mark - 查询数量  数据库的条目总数
- (void)count:(void(^)(NSUInteger count))completion {
    
    [self asynchronousOperatDBInDB:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) as c FROM %@",kTableNAME];
        FMResultSet *rs = [db executeQuery:sql];
        NSUInteger count = 0;
        if ([rs next]) {
            count = [rs intForColumn:@"c"];
        }
        completion(count);
        [rs close];
    }];
}

#pragma mark - 更新  根据key更新所有条目
- (void)update:(id<NSCoding>)data key:(NSString *)key completion:(void(^)(BOOL success))completion {
    
    [self asynchronousOperatDBInTransaction:^(FMDatabase *db, BOOL *rollback) {
        [self queryWithKey:key completion:^(id<NSCoding> newData, NSString *storeDate) {
            if (!newData) {
                return completion(NO);
            }
            NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@=?,%@=? WHERE %@=?",kTableNAME,kAddDate,kDatas,kIdentify];
            BOOL success = [db executeUpdate:sql,[NSString timestamp],[NSKeyedArchiver archivedDataWithRootObject:data],key];
            [self executeWithSuccess:success rollback:*rollback completion:completion];
        }];
    }];
}

@end
