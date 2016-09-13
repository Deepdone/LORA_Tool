//
//  Account.m
//  WinDevelopmentBoard
//
//  Created by winext on 15/11/17.
//  Copyright © 2015年 Momon. All rights reserved.
//

#import "DBAccount.h"

@implementation DBAccount

- (instancetype)copyWithZone:(NSZone *)zone{
    DBAccount *account = [[[self class] allocWithZone:zone] init];
    return  account;
}
/**
 *  从文件中解析对象的时候调
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.code         = [decoder decodeObjectForKey:@"code"];
        self.email        = [decoder decodeObjectForKey:@"email"];
        self.phone        = [decoder decodeObjectForKey:@"phone"];
        self.access_token = [decoder decodeObjectForKey:@"access_token"];
        self.expiresTime  = [decoder decodeObjectForKey:@"expiresTime"];
        self.keepPassword = [decoder decodeObjectForKey:@"keepPassword"];

        self.remind_in    = [decoder decodeInt64ForKey: @"remind_in"];
        self.expires_in   = [decoder decodeInt64ForKey: @"expires_in"];
        self.uid          = [decoder decodeInt64ForKey: @"uid"];
    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.code          forKey:@"code"];
    [encoder encodeObject:self.email         forKey:@"email"];
    [encoder encodeObject:self.phone         forKey:@"phone"];
    [encoder encodeObject:self.access_token  forKey:@"access_token"];
    [encoder encodeObject:self.expiresTime   forKey:@"expiresTime"];
    [encoder encodeObject:self.keepPassword  forKey:@"keepPassword"];
    
    
    [encoder encodeInt64: self.remind_in     forKey:@"remind_in"];
    [encoder encodeInt64: self.expires_in    forKey:@"expires_in"];
    [encoder encodeInt64: self.uid           forKey:@"uid"];
}

@end
