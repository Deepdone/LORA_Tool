//
//  EnumBtnTag.h
//  WinFamily
//
//  Created by winext on 15/9/28.
//  Copyright (c) 2015年 Momon. All rights reserved.
//

#ifndef WinFamily_EnumBtnTag_h
#define WinFamily_EnumBtnTag_h

typedef enum {
    getRequest_Type    = 111121,
    postRequest_Type   = 111122,
    deleteRequest_Type = 111123,
    putRequest_Type    = 111124,
} AFRequestType;


// 网络状态
typedef enum {
    
    Wifi_Type    = 1,
    WWAN_Type    = 2,
    NotNet_Type  = 3,
    Unknown_Type = 4,
    
}NetWorkStatus;

#endif
