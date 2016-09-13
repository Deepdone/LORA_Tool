//
//  NSString+wrapper.h
//
//  Created by TszFung D. Lam on 15/7/14.
//  Copyright (c) 2015年 Shenzhen mesada technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (wrapper)

/**
 *  空字符串判断
 *
 *  @param string
 *
 *  @return
 */
+ (BOOL)isEmptyOrNull:(NSString *)string;


/**
 *  去除空白
 *
 *  @return
 */
- (NSString *)trim;

/**
 *  获取当前时间戳
 *
 *  @return
 */
+ (NSString *)timestamp;

/**
 *  16位的MD5
 *
 *  @return
 */
- (NSString *)MD5_16;

@end
