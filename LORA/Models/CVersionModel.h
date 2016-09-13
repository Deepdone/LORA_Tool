//
//  CVersionModel.h
//  SmartKit
//
//  Created by SlightlySweetPro on 16/3/23.
//  Copyright © 2016年 Winext Corporation. All rights reserved.
//

#import "ParentModel.h"

@interface CVersionModel : ParentModel

@property (nonatomic,copy) NSString *url;     // 下载新版本压缩包地址

@property (nonatomic,copy) NSString *v;      // 版本号

@end
