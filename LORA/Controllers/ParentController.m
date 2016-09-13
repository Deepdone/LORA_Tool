//
//  ParentController.m
//  WinFamily
//
//  Created by winext on 15/9/25.
//  Copyright (c) 2015年 Momon. All rights reserved.
//

#import "ParentController.h"


@interface ParentController ()

@end

@implementation ParentController
//  btnClick
- (void)controllerBtnClick:(UIButton *)sender{
    if (self.controllerBtnClickBlock) {
        self.controllerBtnClickBlock(sender.tag);
    }
}
//


/*
// 左边栏
- (void)showLeftSideView {
    [self.drawerController toggleDrawerSide:WXDrawerSideLeft animated:YES completion:^(BOOL finished){
        
    }];
}
//// 右边栏
- (void)showRightSideView {
    

    [self.drawerController toggleDrawerSide:WXDrawerSideRight animated:YES completion:^(BOOL finished) {
    }];
}
// 显示主界面
- (void)showMainView{
    [self.drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
    }];
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;  // 在使用navi时，去除scrollView顶部的留白
   
    // 画UI
    [self createParentUI];
   
    // 统一修改界面风格
//    self.view.backgroundColor = RedColor;
    
    // Do any additional setup after loading the view.
}



#pragma mark --- createUI ---
- (void)createParentUI{
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view ];
    [self.view addSubview:self.HUD];
    
    
}

#pragma mark ---  加载指示
- (void)loadingNow{
    
    __weak __typeof(self)weakSelf = self;
//    NSLog(@"timeshow:%f", self.HUD.graceTime);
    
//    self.HUD.graceTime = 1;
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [weakSelf.HUD show:YES]; // 须在主线程显示
        });
    }
    else{
        [self.HUD show:YES];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [AFNetworkActivityIndicatorManager sharedManager].enabled         = YES;
    
}
- (void)loadingEnd{
    __weak __typeof(self)weakSelf = self;

    if (![[NSThread currentThread] isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (weakSelf.headerView && [weakSelf.headerView isRefreshing]) {
                [weakSelf.headerView endRefreshing];
            }
             [weakSelf.HUD hide:YES];
        });
    }
    else{
        [self.HUD hide:YES];
    }
    
    if (self.headerView && [self.headerView isRefreshing]) {
        [self.headerView endRefreshing];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [AFNetworkActivityIndicatorManager sharedManager].enabled         = NO;
}


#pragma mark  -----  系统设置 -------
- (void)openSystemUrlWithStr:(NSString *)urlStr{
    @synchronized(self) {
        NSURL *url = [NSURL URLWithString:urlStr];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }else{
            [ShowPromptMessageTool showMessage:@"can not open"];
        }
    }
}

#pragma mark --- 刷新Tableview ---
- (void)reloadTableviewWith:(UITableView *)tableView{
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [tableView reloadData];
        });
    }
    else {
        [tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ============= 弹出提示框 ==============
- (void)showAlertViewWith:(NSString *)alertTitle andMessage:(NSString *)alertMessageStr{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        
//    });
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
