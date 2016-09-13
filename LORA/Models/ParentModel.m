//
//  ParentModel.m
//  WinFamily
//
//  Created by winext on 15/9/28.
//  Copyright (c) 2015年 Momon. All rights reserved.
//
#import "ParentModel.h"

@implementation ParentModel

//解档
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        unsigned int count = 0;
        //获取类中所有成员变量名
        Ivar *ivar = class_copyIvarList([self class], &count);
        for (int i = 0; i<count; i++) {
            Ivar iva = ivar[i];
            const char *name = ivar_getName(iva);
            NSString *strName = [NSString stringWithUTF8String:name];
            NSString *Name    = [strName substringFromIndex:1];
            //进行解档取值
            id value = [decoder decodeObjectForKey:Name];
//            NSLog(@" %@ qev %@",Name,value);
            //利用KVC对属性赋值
            [self setValue:value forKey:Name];
        }
        free(ivar);
    }
    return self;
}
//归档
- (void)encodeWithCoder:(NSCoder *)encoder
{
    unsigned int count;
    Ivar *ivar = class_copyIvarList([self class], &count);
    for (int i=0; i<count; i++) {
        Ivar iv = ivar[i];
        const char *name = ivar_getName(iv);
        NSString *strName = [NSString stringWithUTF8String:name];
        NSString *Name    = [strName substringFromIndex:1]; // _name
        //利用KVC取值
        id value = [self valueForKey:Name];
        //        NSLog(@" %@ -- q-- %@",Name,value);
        
        [encoder encodeObject:value forKey:Name];
    }
    free(ivar);
}
// 初始化
- (instancetype)initWithDict:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

+ (instancetype)initModelWithDict:(NSDictionary *)dictionary{
    return [[self alloc] initWithDict:dictionary];
}


/*
 *  KVC使用注意
 *  1.如果后台字段给你的是系统关键字，需要转换成一个非关键字
 *  2.如果后台给你的字段比你自己的实体字段多，需要重写undefineKey：方法
 *  3.如果后台给你的字段是NSNumber类型，需要做判断
 
 */

#pragma mark - ================= 缺少字段 ================
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    MMLog(@"%@类缺少%@字段",NSStringFromClass(self.class),key);
}

#pragma mark - ================= 类型转换 ================
- (void)setValue:(id)value forKey:(NSString *)key{
    // 策略模式，又是oc的运行时反射机制
    if([value isKindOfClass:[NSNumber class]]){
        // 将nsnumber转换为nsstring
        NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
        value = [format stringFromNumber:value];
    }
    else{
        [super setValue:value forKey:key];
    }
}

@end
