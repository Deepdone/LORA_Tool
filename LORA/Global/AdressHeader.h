//
//  AdressHeader.h
//  WinFamily
//
//  Created by winext on 15/10/10.
//  Copyright (c) 2015年 Momon. All rights reserved.
//

#ifndef WinFamily_AdressHeader_h
#define WinFamily_AdressHeader_h

#define LORA_LoginUrlStr    @"http://lora.smartkit.io/index/login"
#define LORA_SetNetUrlStr   @"http://192.168.3.1"

/**
 域名:   m2c.smartkit.io
 ip：   120.25.56.173
 端口：  5683（设备），8081（APP）正式服务器
 */
#define ALLREQUEST_HTTPAPI @"http://120.24.75.48:8082"


static NSString *httpAPI = ALLREQUEST_HTTPAPI;




/*
Curl –X DELETE  http://localhost/v1/bx/food/1?access_token=b4a3c70618d2cb7243602cada9aa981ce5dff704
 
 响应
 "code":200
 */

#pragma mark ********  M200C升级 ********
#define M200CUPGRADE_URL @"%@/v1/update/%@"
#define M200CUPGRADE__PARAMETERS @{@"type":@"1",@"access_token":@""}

//POST /v1/update/:coreid
//{
//access_token: /token/
//type:  1 =升级， 2 = 取消升级
//    }

#pragma mark ********  检查应用版本 ********
//  http://m200c.smartkit.io:8080/v1/version?t=android
#define GETAppVersion_URL @"%@/v1/version?t=ios"
/*
 {"code": 200,”info”:{“version”:”0.1.2”,”is_effect”:1/2,’url’:’http://m200c.smartkit.io:8080/v1/down?t=android&v=0.1.2’}
 Is_effect  = 1   必须升级
 Is_effect = 2    选择升级
 */

#pragma mark  ************ app store 检查更新  ************* 

#define GetAppVersionMessage @"https://itunes.apple.com/lookup?id=%@" 


#pragma mark *********** Delete ************** =============
#pragma mark ********  取消绑定 ********
// 注意，此时用户是作为使用者出现的，而不是开发者的角色
#define CANCELBINDING_URL @"%@/v1/d/%@/devices?access_token=%@"

/*响应
 {"code": 200}
 */

#endif
