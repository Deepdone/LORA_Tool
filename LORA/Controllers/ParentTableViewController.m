//
//  ParentTableViewController.m
//  SmartKit
//
//  Created by SlightlySweetPro on 16/1/19.
//  Copyright © 2016年 Winext Corporation. All rights reserved.
//

#import "ParentTableViewController.h"

@interface ParentTableViewController ()

@end

@implementation ParentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 画UI
    [self createUI];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
#pragma mark --- createUI ---
- (void)createUI{
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.tableView ];
    [self.tableView addSubview:self.HUD];

}


#pragma mark ---  加载指示
- (void)loadingNow{
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.HUD show:YES]; // 须在主线程显示
        });
    }
    else{
        [self.HUD show:YES];
    }
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled         = YES;
}


- (void)loadingEnd{
    
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (self.headerView && [self.headerView isRefreshing]) {
                [self.headerView endRefreshing];
            }
            [self.HUD hide:YES];
        });
    }
    else{
        [self.HUD hide:YES];
    }
    
    if (self.headerView && [self.headerView isRefreshing]) {
        [self.headerView endRefreshing];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [AFNetworkActivityIndicatorManager sharedManager].enabled = NO;
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

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
