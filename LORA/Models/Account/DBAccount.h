//
//  Account.h
//  WinDevelopmentBoard
//
//  Created by winext on 15/11/17.
//  Copyright © 2015年 Momon. All rights reserved.
//

#import "ParentModel.h"

@interface DBAccount : ParentModel <NSCopying>

@property (nonatomic, copy) NSString *code;     // 代号


@property (nonatomic, copy) NSString *email; // 用户昵称
@property (nonatomic, copy) NSString *phone; // 号码

@property (nonatomic,copy) NSString *access_token; // 登录获取

@property (nonatomic,strong) NSDate *expiresTime; // 账号过期时间


@property (nonatomic,copy) NSString *keepPassword; // 1 记住密码

// 如果服务器返回的数字很大, 建议用long long(比如主键, ID)
@property (nonatomic, assign) long long expires_in; // 有效期
@property (nonatomic, assign) long long remind_in;  //
@property (nonatomic, assign) long long uid;



@end
