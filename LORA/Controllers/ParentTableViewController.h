//
//  ParentTableViewController.h
//  SmartKit
//
//  Created by SlightlySweetPro on 16/1/19.
//  Copyright © 2016年 Winext Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ControllerBtnClickBlock) (NSInteger ControllerBtnTag);

@interface ParentTableViewController : UITableViewController <MBProgressHUDDelegate>

@property (nonatomic,weak)  MJRefreshHeaderView *headerView;

@property (nonatomic,copy) ControllerBtnClickBlock controllerBtnClickBlock;

// HUD
@property (nonatomic,strong) MBProgressHUD *HUD;

- (void)loadingNow;
- (void)loadingEnd;


// btnClick
//- (void)controllerBtnClick:(UIButton *)sender;


// 系统设置
- (void)openSystemUrlWithStr:(NSString *)urlStr;


#pragma mark =============  刷新TableView ==============
- (void)reloadTableviewWith:(UITableView *)tableView;

@end
