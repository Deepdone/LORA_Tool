//
//  NSString+wrapper.m
//
//  Created by TszFung D. Lam on 15/7/14.
//  Copyright (c) 2015年 Shenzhen mesada technology co., LTD. All rights reserved.
//

#import "NSString+wrapper.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (wrapper)

+ (BOOL) isEmptyOrNull:(NSString *)string {
    if (!string) {
        return YES;
    } else if ([string isEqual:[NSNull null]]) {
        return YES;
    } else {
        if (string.length == 0 || [string isEqualToString:@""]) {
            return YES;
        }
        NSString *trimedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimedString length] == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}


- (NSString *)trim {
    
    NSString *temp = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableString *string = [temp mutableCopy];
    CFStringTrimWhitespace((CFMutableStringRef)string);
    NSString *result = [string copy];
    return result;
    
}

+ (NSString *)timestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timeInterval = [date timeIntervalSince1970] * 1000;
    NSString *timestamp = [NSString stringWithFormat:@"%f", timeInterval];
    return timestamp;
}

- (NSString *)MD5_16
{
    const char *str = [self UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    return  [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
             r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];

}



@end
