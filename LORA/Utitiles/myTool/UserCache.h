//
//  LogInStateCache.h
//  WinFamily
//
//  Created by winext on 15/9/29.
//  Copyright (c) 2015年 Momon. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBAccount;

@interface UserCache : NSObject

/**
 *  存储账号信息
 *
 *  @param account 需要存储的账号
 */
+ (void)saveAccount:(DBAccount *)account;

/**
 *  返回存储的账号信息
 */
+ (DBAccount *)account;

+ (void)clearAccess; // 退出登录 清除存储的账号信息




/**
 *  缓存数组
 *  @param muArr 保存的可变数组
 *  @param key   key
 */
+ (void)saveMutableArray:(NSMutableArray *)muArr withKey:(NSString *)key;
+ (NSMutableArray *)getMutableArrayWithKey:(NSString *)key;


/**
 *  缓存字典
 *  @param muArr 保存的可变字典
 *  @param key   key
 */
+ (void)saveMutableDictionary:(NSMutableDictionary *)muDic withKey:(NSString *)key;
+ (NSMutableDictionary *)getMutableDictionaryWithKey:(NSString *)key;



/**
 *  缓存bool
 *  @param boolValue bool值
 *  @param key       key
 */
+ (void)saveBool:(BOOL)boolValue withKey:(NSString *)key;
+ (BOOL)getBoolWithKey:(NSString *)key;


/**
 *  缓存string
 *  @param string值
 *  @param key       key
 */
+ (void)saveString:(NSString *)str withKey:(NSString *)key;
+ (NSString *)getStringWithKey:(NSString *)key;

/**
 *  缓存Integer
 *  @param Integer值
 *  @param key       key
 */
+ (void)saveInteger:(NSInteger)value withKey:(NSString *)key;
+ (NSInteger)getIntegerWithKey:(NSString *)key;


/**
 *  保存Data
 *
 *  @param data
 *  @param key
 */
+ (void)saveData:(NSData *)data WithKey:(NSString *)key;

/**
 *  获取Data
 *
 *  @param key  获取key
 *
 *  @return 取得Data
 */
+ (NSData *)getDataWithKey:(NSString *)key;

/**
 *  使用Key 清除缓存数据
 *  @param key    key
 */
+ (void)clearDataWithKey:(NSString *)key;

@end
