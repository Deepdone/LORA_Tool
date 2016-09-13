//
//  ChangeRootController.m
//  WinDevelopmentBoard
//
//  Created by winext on 15/11/17.
//  Copyright © 2015年 Momon. All rights reserved.
//

#import "ChangeRootController.h"

//#import "WXDrawerController.h"
//#import "SettingController.h"


#import "SuperController.h"

#import "EquipmentTableController.h"

// 壁炉
#import "FireplaceController.h"

// 净水器
//#import "WaterClarifierController.h"



#define nextStoryboard [UIStoryboard storyboardWithName:storyboardName bundle:nil]
@implementation ChangeRootController
#pragma mark  ========  选择模式 ========
+ (void)intoTypeChangedControl{
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    RooViewController = [storyboard instantiateInitialViewController];
}
#pragma mark  ========  直联模式 ========
+ (void)intoDirectMode{
    [self createDevelopmentBoardController];
}
#pragma mark  ========  远程模式 ========
+ (void)intoRemoteMode{
    DBAccount *account = [UserCache account];
    if (account) {
        [self intoEquimentListController];
    }
    else{
        [self intoLoginContoller];
    }
}
#pragma mark  ========  登录/ 注册 ========
+ (void)intoLoginContoller{

//    NSString *storyboardName = @"LoginStoryboard";
    
    //    NSString *storyboardName = @"EquipmentListStoryboard";
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    //    RooViewController = [storyboard instantiateInitialViewController];
    
    
        NSString *storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        RooViewController = [storyboard instantiateInitialViewController];
}
#pragma mark ========== 列表 =========
+ (void)intoEquimentListController{
NSString *storyboardName = @"EquipmentListStoryboard";
    UIStoryboard *storyboard = nextStoryboard;
    RooViewController = [storyboard instantiateInitialViewController];
}


#pragma mark ==========  初始化 开发板 =========
+ (void)createDevelopmentBoardController {

    NSString *storyboardName = @"DevelopmentBoard";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    
    WXDrawerController *sideMainVC = [storyboard instantiateInitialViewController];
    RooViewController = sideMainVC;
    UIViewController *centerVC;
    switch ([UserCache getCurrentDeviceType]) {
        case PressureCooker_Type:
        {
            centerVC = [storyboard instantiateViewControllerWithIdentifier:@"PressureCookerNavStoryboardID"];
        }
            break;
        case Development_Type:
        {
             centerVC = [storyboard instantiateViewControllerWithIdentifier:@"DevelopmentNavStoryboardID"];
        }
            break;
        default:
            break;
    }
    SettingController *rightVC      = [storyboard instantiateViewControllerWithIdentifier:@"SettingControllerStoryboardID"];
    // 阻尼
    sideMainVC.springAnimationOn    = NO;
    
    sideMainVC.centerViewController = centerVC;
    sideMainVC.rightViewController  = rightVC;
}

+ (void)createSuperControllerWith:(id)dataModel andInitDic:(NSMutableDictionary *)dataInitDic fromTarget:(UINavigationController  *)nav{

    
    
    
    
//    NSString *storyboardName = @"SuperAppControllerStoryboard";
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
//     UINavigationController * controller = (UINavigationController *)[storyboard instantiateInitialViewController];
    
//    SuperController *superVC = (SuperController *)controller.childViewControllers[0];
    
//    EquipmentListController *equipmentTarget = (EquipmentListController *)target;
    
//    RooViewController    = controller;

    NSString *storyboardName = @"EquipmentListStoryboard";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    SuperController * superVC = [storyboard instantiateViewControllerWithIdentifier:@"SuperControllerStoryboardId"];
    
    
    superVC.dataModel    = dataModel;
    superVC.dataInitDic  = dataInitDic;
    
    [nav pushViewController:superVC animated:YES];
    
}
// FireplaceApp
+ (void)createFireplaceControllerWith:(id)dataModel andInitDataModel:(id)dataInitModel fromTarget:(UINavigationController *)nav{

NSString *storyboardName = @"EquipmentListStoryboard";
UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
FireplaceController * fireplaceVC = [storyboard instantiateViewControllerWithIdentifier:@"FireplaceControllerStoryboardId"];


fireplaceVC.dataModel      = dataModel;
fireplaceVC.dataInitModel  = dataInitModel;

[nav pushViewController:fireplaceVC animated:YES];

}

+ (void)createWaterClarifierControllerWith:(id)dataModel andInitDataModel:(id)initDataModel fromTarget:(UINavigationController *)nav{
    
//    NSString *storyboardName = @"EquipmentListStoryboard";
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
//    WaterClarifierController * fireplaceVC = [storyboard instantiateViewControllerWithIdentifier:@"WaterClarifierControllerStoryboardId"];
//    
//    
//    fireplaceVC.dataModel      = dataModel;
//    fireplaceVC.dataInitModel  = initDataModel;
////    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [nav pushViewController:fireplaceVC animated:YES];
//
////    });
    
}


@end
