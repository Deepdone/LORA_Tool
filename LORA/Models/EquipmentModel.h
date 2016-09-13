//
//  EquimentModel.h
//  WinDevelopmentBoard
//
//  Created by winext on 15/11/16.
//  Copyright © 2015年 Momon. All rights reserved.
//

#import "ParentModel.h"

@interface EquipmentModel : ParentModel

@property (nonatomic,copy) NSString *bind;          // 1：可删
@property (nonatomic,copy) NSString *connected;     // true 在线状态

@property (nonatomic,copy) NSString *coreid;       // 默认设备名 请求设备列表 获取
@property (nonatomic,copy) NSString *name;         // 设备名称

@property (nonatomic,copy) NSString *cname;       // 类型名称
@property (nonatomic,copy) NSString *bname;       // 牌品名称

@property (nonatomic,copy) NSString *category_id; // 设备类别 设备对应网页

@property (nonatomic,copy) NSString *icon;       // 设备图标

@property (nonatomic,copy) NSString *cVersion;   // 类别版本信息

@property (nonatomic,assign) BOOL isInLocalNetwork; // 在局域网内

@property (nonatomic,assign) BOOL isHaveNewVersion; // 存在新版本


/*
 
 {
 bind = 1;
 bname = "\U51a0\U4e3a";
 cname = "\U538b\U529b\U9505";
 connected = false;
 coreid = fqolwi024e4cbdl6n3ylgdfq;
 name = null;
 },
 {
 bind = 1;
 bname = "\U51a0\U4e3a";
 cname = "\U538b\U529b\U9505";
 connected = true;
 coreid = 7tiswi024e4940nhn00wlas1;
 name = null;
 }
 */
@end
