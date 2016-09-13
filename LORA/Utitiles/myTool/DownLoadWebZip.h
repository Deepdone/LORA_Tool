//
//  DownLoadWebZip.h
//  SmartKit
//
//  Created by SlightlySweetPro on 16/3/8.
//  Copyright © 2016年 Winext Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownLoadWebZip : NSObject
HMSingletonH(DownLoadWebZip)

- (void)loadNewData;

// 比较两数组 
- (void)compareWithOldModelArr:(NSMutableArray *)oModelArr withNewModelArr:(NSMutableArray *)nModelArr;

- (void)downLoadModelWith:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath andModel:(EquipmentModel *)model;

@end
