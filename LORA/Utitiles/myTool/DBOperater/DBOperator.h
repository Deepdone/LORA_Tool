//
//  DBOperater.h
//  MSDDataCache
//
//  Created by TszFung D. Lam on 15/7/19.
//  Copyright (c) 2015年 TszFung D. Lam. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  管理数据库的类 支持多线程操作
 */
@interface DBOperator : NSObject

@property (nonatomic, copy, readonly)NSString *basePath;

- (NSString *)dbPath:(NSString *)dbName;

/**
 *  全局的数据库管理实例
 *
 *  @return
 */
+ (DBOperator *)sharedDBOperater;

/**
 *  以basePath初始化
 *
 *  @param basePath 
 */
- (void)initWithBasePath:(NSString *)basePath;

/**
 *  关闭并销毁
 */
- (void)close;

/**
 *  保存到数据库
 *
 *  @param model
 *  @param completion
 */
- (void)storeToDB:(id<NSCoding>)data key:(NSString *)key completion:(void(^)(BOOL success))completion;

/**
 *  根据key从数据库获取
 *
 *  @param key
 *  @param completion
 */
- (void)queryWithKey:(NSString *)key completion:(void(^)(id<NSCoding> data, NSString *storeDate))completion;

/**
 *  获取数据库所有的条目
 *
 *  @param completion
 */
- (void)query:(void(^)(NSArray *array))completion;

/**
 *  根据key从数据库删除条目
 *
 *  @param key
 *  @param completion
 */
- (void)removeDataFromDB:(NSString *)key completion:(void(^)(BOOL success))completion;

/**
 *  删除所有条目
 *
 *  @param completion
 */
- (void)removeAll:(void(^)(BOOL success))completion;

/**
 *  根据指定数量删除条目
 *
 *  @param count
 *  @param completion
 */
- (void)removeOfLimitCount:(NSUInteger)count completion:(void(^)(BOOL success))completion;

/**
 *  数据库的条目总数
 *
 *  @param completion
 */
- (void)count:(void(^)(NSUInteger count))completion;

/**
 *  根据key更新所有条目
 *
 *  @param newModel
 *  @param key
 *  @param completion
 */
- (void)update:(id<NSCoding>)data key:(NSString *)key completion:(void(^)(BOOL success))completion;

@end
