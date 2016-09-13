//
//  LogInStateCache.m
//  WinFamily
//
//  Created by winext on 15/9/29.
//  Copyright (c) 2015年 Momon. All rights reserved.
//


#define WFAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:@"account.data"]

 
#import "UserCache.h"

#import "DBAccount.h"
@implementation UserCache


#pragma mark   ========  帐号 =========
+ (void)saveAccount:(DBAccount *)account{
    // 计算过期时间
    NSDate *nowDate = [NSDate date];
    account.expiresTime = [nowDate dateByAddingTimeInterval:account.expires_in];
    
    [NSKeyedArchiver archiveRootObject:account toFile:WFAccountFile];
}


+ (DBAccount *)account
{
    // 取出账号
    DBAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:WFAccountFile];
    
    // 判断账号是否过期
    NSDate *nowTime = [NSDate date];
    if (([nowTime compare:account.expiresTime] == NSOrderedAscending) || (account.access_token)) { // 还没有过期 NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending
        return account;
    } else { // 过期
        return nil;
    }
}
// 清除 access_token
+ (void)clearAccess{
    // 取出账号
    DBAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:WFAccountFile];
    [account setValue:nil forKey:@"access_token"];
    [NSKeyedArchiver      archiveRootObject:account toFile:WFAccountFile];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    [fileManager removeItemAtPath:WFAccountFile error:&error];
    if (error) {
        NSLog(@"removeFile error:%@",error);
    }
}






/**
 *  缓存可变数组
 *  @param muArr 保存的可变数组
 *  @param key   key
 */
+ (void)saveMutableArray:(NSMutableArray *)muArr withKey:(NSString *)key{
    [USER_DEFAULTS setValue:muArr forKey:key];
}

+ (NSMutableArray *)getMutableArrayWithKey:(NSString *)key{
    return [USER_DEFAULTS valueForKey:key];
}

/**
 *  缓存字典
 *  @param muArr 保存的可变字典
 *  @param key   key
 */
+ (void)saveMutableDictionary:(NSMutableDictionary *)muDic withKey:(NSString *)key{
    [USER_DEFAULTS setValue:muDic forKey:key];
}

+ (NSMutableDictionary *)getMutableDictionaryWithKey:(NSString *)key{
    return [USER_DEFAULTS valueForKey:key];
}


/**
 *  缓存bool
 *  @param boolValue bool值
 *  @param key       key
 */
+ (void)saveBool:(BOOL)boolValue withKey:(NSString *)key{
    [USER_DEFAULTS setValue:@(boolValue) forKey:key];
}
+ (BOOL)getBoolWithKey:(NSString *)key{
    return [[USER_DEFAULTS valueForKey:key] boolValue];
}


/**
 *  缓存string
 *  @param string值
 *  @param key       key
 */
+ (void)saveString:(NSString *)str withKey:(NSString *)key{
    [USER_DEFAULTS setValue:str forKey:key];
}

+ (NSString *)getStringWithKey:(NSString *)key{
    return [USER_DEFAULTS valueForKey:key];
}

/**
 *  缓存Integer
 *  @param Integer值
 *  @param key       key
 */
+ (void)saveInteger:(NSInteger)value withKey:(NSString *)key{
    [USER_DEFAULTS setValue:@(value) forKey:key];
}
+ (NSInteger)getIntegerWithKey:(NSString *)key{
    return [[USER_DEFAULTS valueForKey:key] integerValue];
}




/**
 *  保存Data
 *
 *  @param data
 *  @param key
 */
+ (void)saveData:(NSData *)data WithKey:(NSString *)key{
    [USER_DEFAULTS setValue:data forKey:key];
}



/**
 *  获取Data
 *
 *  @param key  获取key
 *
 *  @return 取得Data
 */
+ (NSData *)getDataWithKey:(NSString *)key{
   return [USER_DEFAULTS valueForKey:key];
}


/**
 *  使用Key 清除缓存数据
 *
 *  @param key key
 */
+ (void)clearDataWithKey:(NSString *)key{
    [USER_DEFAULTS removeObjectForKey:key];
    [USER_DEFAULTS synchronize];
}
@end
