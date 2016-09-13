//
//  NetInfo.h
//  WinFamily
//
//  Created by winext on 15/11/11.
//  Copyright © 2015年 Momon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetInfo : NSObject
+ (NSDictionary *)fetchNetInfo; // 取 网络信息
+ (NSString *)fetchSsid;
+ (NSString *)fetchBssid;
@end
