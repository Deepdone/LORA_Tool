//
//  ParsingRemoteData.m
//  WinDevelopmentBoard
//
//  Created by SlightlySweetPro on 15/12/8.
//  Copyright © 2015年 Momon. All rights reserved.
//

#import "ParsingRemoteData.h"
#import "CallBackDataModel.h"
#import "CoapRe.h"

@implementation ParsingRemoteData
+ (void)parsingRemoteData:(id)data{
    
    NSLog(@"remote  data:%@",data);
    
    @synchronized(self) {
        // 字典--》模型
        CallBackDataModel *backModel = [CallBackDataModel objectWithKeyValues:data];
        
        NSString *coreId = backModel.coreid;
        
        NSString *name = backModel.name;
        int val = [backModel.val intValue];

        // 在控制界面 id为当前设备id才处理
        if ([coreId isEqualToString:[UserCache getCurrentCoreID]]) {
            
//            NSLog(@"backModel.name:%@,val:%d",name,val);
            
            // 升级状态
            if ([name isEqualToString:@"UpdateStatus"]) {
                [CoapRe callBackUpdateStatusWithVal:val];
            }
            // 下载大小
            else if ([name isEqualToString:@"UpdateSize"]){
                [CoapRe callBackUpdateSizeWithVal:val];
            }
            // 连接状态 
            else if ([name isEqualToString:@"connected"]){
                
                [CoapRe callBackIsOnLine:[backModel.val isEqualToString:@"false"]? NO :YES];
            /*
             {"name":"connected","val":"false","coreid":"8s2obb024eb8igfch6ylg5su"}
             */
            }
            
            return;
            
            const char* nameChar = [name cStringUsingEncoding:NSUTF8StringEncoding];
            switch ([UserCache getCurrentDeviceType]) {
                case Development_Type: // 开发板
                {
                    
                    switch (*nameChar) {
                        case 'a':// 开关
                        {
                            BOOL isOpen = val ? YES : NO;
                            [CoapRe callBackDevPowerSwitch:isOpen];
                        }
                            break;
                        case 'b'://蜂鸣器
                        {
                            [CoapRe callBackDevBeep:val];
                        }
                            break;
                        case 'c':// key 1
                        {
                            BOOL isOpen = val ? YES : NO;
                            [CoapRe callBackDevKey1:isOpen];
                        }
                            break;
                        case 'd':// key2
                        {
                            BOOL isOpen = val ? YES : NO;
                            [CoapRe callBackDevKey2:isOpen];
                        }
                            break;
                        case 'e'://
                        {
                        }
                            break;
                        case 'f'://
                        {
                        }
                            break;
                        case 'g':// 压力开关
                        {
                            BOOL isOpen = val ? YES : NO;
                            [CoapRe callBackDevSensorPress:isOpen];
                        }
                            break;
                        case 'h'://继电器
                        {
                            BOOL isOpen = val ? YES : NO;
                            [CoapRe callBackDevRelay:isOpen];
                        }
                            break;
                        case 'i':// 温度
                        {
                            [CoapRe callBackDevSensorTemp:val];
                        }
                            break;
                        case 'j':// led
                        {
                            [CoapRe callBackDevLed:val];
                        }
                            break;
                        default:
                            break;
                    }
                }
                    break;
                case PressureCooker_Type: // 压力锅
                {
                    
                    switch (*nameChar) {
                        case 'a':// 开关
                        {
                            BOOL isOpen = val ? YES : NO;
                            [CoapRe callBackSwitch:isOpen];
                        }
                            break;
                        case 'b':// 预约
                        {
                            [CoapRe callBackYuYueTime:val];
                        }
                            break;
                        case 'c':// 保压
                        {
                            [CoapRe callBackBaoYaTime:val];
                        }
                            break;
                        case 'd':// 模式
                        {
                            [CoapRe callBackMode:val];
                        }
                            break;
                        default:
                            break;
                    }
                }
                    break;
                default:
                    break;
            }
        }
    }
}
@end
