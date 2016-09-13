//
//  OneKeyallocation.h
//  WinFamily
//
//  Created by winext on 15/11/11.
//  Copyright © 2015年 Momon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OneKeyAllocation : NSObject
MMSingletonH(OneKeyAllocation)
/**
 *  <#Description#>
 *
 *  @param isAllocation 授权 //取消
 *  @param apSsid       wifi
 *  @param apBssid      Bssid
 *  @param passWord     密码
 *  @param taskCount    任务数
 *  @param ResultBlock  配置结果 NSArray
 */
- (void)allocationWithIsAlloction :(BOOL)isAllocation andSsid:(NSString *)apSsid andBssid:(NSString *)apBssid andPassWord:(NSString *)passWord andTaskCount:(int)taskCount esptouchResultBlock:(void(^)(NSArray *resultArr))ResultBlock;
/**
 *  取消 中断
 */
- (void)cancel;

@end
