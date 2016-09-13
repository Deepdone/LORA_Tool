//
//  DateHelper.m
//  IceboxPartner
//
//  Created by SlightlySweetPro on 16/6/16.
//  Copyright © 2016年 SlightlySweet. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper
#pragma  mark -  时间戳转时间的方法:  NSTimeInterval --- > NSDate
+ (NSDate *)turnToDateWithDateFormatter:(NSString *)dateFormatterStr andIsMillisecond:(BOOL)isMS{

    //    NSTimeIntervaltime=[str doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    
    NSTimeInterval time = [dateFormatterStr doubleValue];
    NSDate *date        = [NSDate dateWithTimeIntervalSince1970:  isMS ? time / 1000.0 : time];
    
    
    // test
//    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
//    
//    NSString *timeSp        = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970] - 28800];
//
//    MMLog(@"标准时间戳:%@  当前时间时间戳毫秒:%f",timeSp,interval);
//
    
    
//    str ---- > Date
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle]; // // 2012-10-29 下午2:51:43
//    [formatter setTimeStyle:NSDateFormatterShortStyle]; // 10/29/12, 2:27 PM
////    [formatter setDateFormat:@"yyyyMMddHHMMss"];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    
//    NSDate *dateFormatter = [formatter dateFromString:@"1990-3-23 12:22:1"];
//    
//    MMLog(@"dateStr : %@",dateFormatter);
//    NSDate *date = [formatter dateFromString:@"1283376197"];
    
    
    
    return date;
}


#pragma  mark -  时间转时间戳的方法:
+ (NSString *)turnToDateFormatterWithDate:(NSDate *)date{
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
//    NSLog(@"timeSp:%@",timeSp); //时间戳的值
    return timeSp;
}

#pragma  mark - 获取当天的日期：年月日
+ (NSDictionary *)getTodayDate
{
    //获取今天的日期
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = kCFCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay;
    
    NSDateComponents *components = [calendar components:unit fromDate:today];
    NSString *year = [NSString stringWithFormat:@"%ld", [components year]];
    NSString *month = [NSString stringWithFormat:@"%02ld", [components month]];
    NSString *day = [NSString stringWithFormat:@"%02ld", [components day]];
    
    NSMutableDictionary *todayDic = [[NSMutableDictionary alloc] init];
    [todayDic setObject:year forKey:@"year"];
    [todayDic setObject:month forKey:@"month"];
    [todayDic setObject:day forKey:@"day"];
    
    return todayDic;
    
}

#pragma  mark ----- 日期 转换为 字符串
+ (NSString *)turnToDateStrWithDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = kCFCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay;
    
    NSDateComponents *components = [calendar components:unit fromDate:date];
    NSString *year = [NSString stringWithFormat:@"%ld", [components year]];
    NSString *month = [NSString stringWithFormat:@"%02ld", [components month]];
    NSString *day = [NSString stringWithFormat:@"%02ld", [components day]];
    
//    return [NSString stringWithFormat:@"%@ 年 %@ 月 %@ 日",year,month,day];
//    return [NSString stringWithFormat:@"%@ - %@ - %@ ",year,month,day];
    return [NSString stringWithFormat:@"%@/%@/%@ ",year,month,day];
}

#pragma  mark - 时间比较
+(NSInteger)compareFromDate:(NSDate *)from toDate:(NSDate *)to{
    
    if (!to || !from) {
        return  -10000;
    }
    // 日历
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    // 时间片段 ：年  月  日  时 分 秒
    int unit = NSCalendarUnitYear | NSCalendarUnitMonth  | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents * com = [calendar components:unit fromDate:from toDate:to options:0];
    
    //    NSString *string = [NSString stringWithFormat:@"剩余%ld小时%ld分钟", com.hour, com.minute];

    NSInteger days = com.day + com.hour / 24.0 + com.minute / 60.0 / 24.0   + 0.5;// 四舍五入
  
    return days;
}


#pragma  mark - 时间比较
/*
+(NSString *)compareFromDate:(NSDate *)from toDate:(NSDate *)to
{
    
    if (!to || !from) {
        return @"已结束";
    }
    
    // 日历
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    // 时间片段 ：年  月  日  时 分 秒
    int unit = NSCalendarUnitYear | NSCalendarUnitMonth  | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents * com = [calendar components:unit fromDate:from toDate:to options:0];
    
    //    NSString *string = [NSString stringWithFormat:@"剩余%ld小时%ld分钟", com.hour, com.minute];
    NSString *timeString = [NSString stringWithFormat:@"剩%d小时",com.hour+com.minute/60];
    if (com.hour+com.minute/60 <= 0) {
        return @"已结束";
    }
    return timeString;
}
*/




@end
