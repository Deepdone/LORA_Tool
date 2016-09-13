//
//  NSString+Extension.m
//  正则表达式
//
//  Created by apple on 14/11/15.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (BOOL)match:(NSString *)pattern{
    // 1.创建正则表达式
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    // 2.测试字符串
    NSArray *results = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    return results.count > 0;
}

// 是否为qq
- (BOOL)isQQ{
    // 1.不能以0开头
    // 2.全部是数字
    // 3.5-11位
    return [self match:@"^[1-9]\\d{4,10}$"];
}

// 手机号
- (BOOL)isPhone{
    
    
    
    /**
     *手机号码
     *移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     *联通：130,131,132,152,155,156,185,186
     *电信：133,1349,153,180,189
     */
    NSString*MOBILE=@"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10    *中国移动：ChinaMobile
     11    *134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12    */
    NSString*CM=@"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15    *中国联通：ChinaUnicom
     16    *130,131,132,152,155,156,185,186
     17    */
    NSString*CU=@"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20    *中国电信：ChinaTelecom
     21    *133,1349,153,180,189
     22    */
    NSString*CT=@"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25    *大陆地区固话及小灵通
     26    *区号：010,020,021,022,023,024,025,027,028,029
     27    *号码：七位或八位
     28    */
    //NSString*PHS=@"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    // 1.全部是数字
    // 2.11位
    // 3.以13\15\18\17开头
//    return [self match:@"^1[3578]\\d{9}$"];
    // JavaScript的正则表达式:\^1[3578]\\d{9}$\
    
    
    return ([self match:MOBILE] || [self match:CM] || [self match:CU] || [self match:CT]);
    
}

// 邮箱
- (BOOL)isEmail{
    NSRange range = [self rangeOfString:@"@qq.com"];
    
    if (range.location != NSNotFound) {
        NSString *qq = [self substringToIndex:range.location];
        return [qq isQQ];
    }
    
    return [self match:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}

//+(BOOL)validateEmail:(NSString*)email
//{
//    NSString*emailRegex=@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
//    NSPredicate*emailTest=[NSPredicatepredicateWithFormat:@"SELFMATCHES%@",emailRegex];
//    return[emailTestevaluateWithObject:email];
//}

// 是否为IP地址
- (BOOL)isIPAddress{
    // 1-3个数字: 0-255
    // 1-3个数字.1-3个数字.1-3个数字.1-3个数字
    return [self match:@"^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}$"];
}


- (BOOL)isNumberStr{
    return [self match:@"^-?\\d+$"] && [self match:@"^[0-9]*$"];
}

/*
 验证数字：^[0-9]*$
 验证n位的数字：^\d{n}$
 验证至少n位数字：^\d{n,}$
 验证m-n位的数字：^\d{m,n}$
 验证数字和小数点:^[0-9]+([.]{0}|[.]{1}[0-9]+)$
 验证零和非零开头的数字：^(0|[1-9][0-9]*)$
 验证有两位小数的正实数：^[0-9]+(.[0-9]{2})?$
 验证有1-3位小数的正实数：^[0-9]+(.[0-9]{1,3})?$
 验证非零的正整数：^\+?[1-9][0-9]*$
 验证非零的负整数：^\-[1-9][0-9]*$
 验证非负整数（正整数 + 0）  ^\d+$
 验证非正整数（负整数 + 0）  ^((-\d+)|(0+))$
 验证长度为3的字符：^.{3}$
 验证由26个英文字母组成的字符串：^[A-Za-z]+$
 验证由26个大写英文字母组成的字符串：^[A-Z]+$
 验证由26个小写英文字母组成的字符串：^[a-z]+$
 验证由数字和26个英文字母组成的字符串：^[A-Za-z0-9]+$
 验证由数字、26个英文字母或者下划线组成的字符串：^\w+$
 验证用户密码:^[a-zA-Z]\w{5,17}$ 正确格式为：以字母开头，长度在6-18之间，只能包含字符、数字和下划线。
 验证是否含有 ^%&',;=?$\" 等字符：[^%&',;=?$\x22]+
 验证汉字：^[\u4e00-\u9fa5],{0,}$
 验证Email地址：^\w+[-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$
 验证InternetURL：^http://([\w-]+\.)+[\w-]+(/[\w-./?%&=]*)?$ ；^[a-zA-z]+://(w+(-w+)*)(.(w+(-w+)*))*(?S*)?$
 验证电话号码：^(\(\d{3,4}\)|\d{3,4}-)?\d{7,8}$：--正确格式为：XXXX-XXXXXXX，XXXX-XXXXXXXX，XXX-XXXXXXX，XXX-XXXXXXXX，XXXXXXX，XXXXXXXX。
 验证电话号码及手机:（\d{3}-\d{8}|\d{4}-\d{7}）｜（^((\(\d{3}\))|(\d{3}\-))?13\d{9}|15[89]\d{8}$）
 验证身份证号（15位或18位数字）：^\d{15}|\d{}18$
 验证一年的12个月：^(0?[1-9]|1[0-2])$ 正确格式为：“01”-“09”和“1”“12”
 验证一个月的31天：^((0?[1-9])|((1|2)[0-9])|30|31)$    正确格式为：01、09和1、31。
 整数：^-?\d+$
 非负浮点数（正浮点数 + 0）：^\d+(\.\d+)?$
 正浮点数   ^(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*))$
 非正浮点数（负浮点数 + 0） ^((-\d+(\.\d+)?)|(0+(\.0+)?))$
 负浮点数  ^(-(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*)))$
 浮点数  ^(-?\d+)(\.\d+)?$
 */
@end
