//
//  DateHelper.h
//  IceboxPartner
//
//  Created by SlightlySweetPro on 16/6/16.
//  Copyright © 2016年 SlightlySweet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject
// 时间戳转时间的方法:
+ (NSDate *)turnToDateWithDateFormatter:(NSString *)dateFormatterStr andIsMillisecond:(BOOL)isMS;

// 时间戳转时间的方法:
+ (NSString *)turnToDateFormatterWithDate:(NSDate *)date;


//获取今天的日期：年月日
+(NSDictionary *)getTodayDate;


// 日期 转换为 字符串
+ (NSString *)turnToDateStrWithDate:(NSDate *)date;

// 时间比较
+(NSInteger)compareFromDate:(NSDate *)from toDate:(NSDate *)to;

@end
