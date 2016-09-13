//
//  ChangeRootController.h
//  WinDevelopmentBoard
//
//  Created by winext on 15/11/17.
//  Copyright © 2015年 Momon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChangeRootController : NSObject
// 模式选择
+ (void)intoTypeChangedControl;


// 直联模式进入
+(void)intoDirectMode;
// 远程模式进入
+ (void)intoRemoteMode;
// 登录/注册
+ (void)intoLoginContoller;
// 设备列表
+ (void)intoEquimentListController;

// 初始化开发板
+ (void)createDevelopmentBoardController;

// superApp
+ (void)createSuperControllerWith:(id)dataModel andInitDic:(NSMutableDictionary *)initDataDic fromTarget:(UINavigationController *)nav;

// FireplaceApp
+ (void)createFireplaceControllerWith:(id)dataModel andInitDataModel:(id)initDataModel fromTarget:(UINavigationController *)nav;

// waterClarifier
+ (void)createWaterClarifierControllerWith:(id)dataModel andInitDataModel:(id)initDataModel fromTarget:(UINavigationController *)nav;


@end
