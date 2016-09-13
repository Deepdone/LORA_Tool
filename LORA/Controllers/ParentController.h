//
//  ParentController.h
//  WinFamily
//
//  Created by winext on 15/9/25.
//  Copyright (c) 2015年 Momon. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ControllerBtnClickBlock) (NSInteger ControllerBtnTag);

@interface ParentController : UIViewController <MBProgressHUDDelegate>

@property (nonatomic,copy) ControllerBtnClickBlock controllerBtnClickBlock;


@property (nonatomic,weak)  MJRefreshHeaderView *headerView;


// HUD
@property (nonatomic,strong) MBProgressHUD *HUD;

- (void)loadingNow;
- (void)loadingEnd;

// btnClick
- (void)controllerBtnClick:(UIButton *)sender;

#pragma mark  -----  系统设置 -------
- (void)openSystemUrlWithStr:(NSString *)urlStr;

#pragma mark =============  刷新TableView ==============
- (void)reloadTableviewWith:(UITableView *)tableView;

#pragma mark ============= 侧滑  ==============
// 左边栏
- (void)showLeftSideView;
// 右边栏
- (void)showRightSideView;

// 返回主界面
- (void)showMainView;

#pragma mark ============= 弹出提示框 ==============
- (void)showAlertViewWith:(NSString *)alertTitle andMessage:(NSString *)alertMessageStr;

@end
