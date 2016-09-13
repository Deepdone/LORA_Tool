//
//  OneKeySharePopView.m
//  IceboxPartner
//
//  Created by SlightlySweetPro on 16/8/12.
//  Copyright © 2016年 SlightlySweet. All rights reserved.
//

#import "OneKeySharePopView.h"
//#import "LeftMenuController.h"

//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKExtension/SSEShareHelper.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>
//#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
//#import <ShareSDK/ShareSDK+Base.h>
//
//#import <ShareSDKExtension/ShareSDK+Extension.h>
//#import <MOBFoundation/MOBFoundation.h>

@interface OneKeySharePopView()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat _oX;
    CGFloat _oY;
    CGFloat _mainVw;
    CGFloat _mainVh;
    
    UIView *_contenView;
    
}
@property (nonatomic,strong) UIWindow *keyWindow;

@property (nonatomic,strong) UITableView *popTableView;

@end

@implementation OneKeySharePopView


#pragma mark   -----------------  弹性 显示view
- (void)show{
    
    self.keyWindow = [UIApplication sharedApplication].keyWindow;
    self.frame     = self.keyWindow.bounds;
    [self.keyWindow addSubview:self];
    
    
    
    _mainVw = self.bounds.size.width - 100;
    _mainVh = (self.bounds.size.height - 64) / 2.0;
    
    _oX     = 50.0f;
    _oY     = 64 + (self.bounds.size.height - 64 - _mainVh) / 2.0;
    
    /**
     *  backgroundView 背景
     */
    UIView *backgroundView                = [UIView new];
    backgroundView.frame                  = self.keyWindow.bounds;
    backgroundView.backgroundColor        = [UIColor blackColor];
    backgroundView.alpha                  = 0.5f;
    backgroundView.userInteractionEnabled = YES;
    
    [self addSubview:backgroundView];
    
    
    // 点击背景 收起
    UITapGestureRecognizer *tapBGView = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(hide)];
    [backgroundView addGestureRecognizer:tapBGView];
    
    
    /**
     *  基底视图
     */
    [self drawView];


}

#pragma mark  -------------- 隐藏 Popview ------------

- (void)hide{
    
//    [UIView animateWithDuration:0.25 animations:^{
//        
//        self.transform  = CGAffineTransformMakeScale(0.1, 0.1);
//
//        [self removeFromSuperview];
//    }];

    [UIView animateWithDuration:0.25 animations:^{
        _contenView.transform  = CGAffineTransformMakeScale(1, 0.1);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    
//    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
//        
//        _contenView.bounds = CGRectMake(0, 0, _mainVw, 0.0f);
//
////        _contenView.bounds = CGRectMake(0, 0, _mainVw, 0.0f);
//
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
}



#pragma mark  -----------  绘制底部View  ----------
- (void)drawView{
    
    _contenView            = [UIView new];
    _contenView.layer.anchorPoint  = CGPointMake(0, 0);// 设置锚点
    _contenView.center             = CGPointMake(_oX , _oY);
    _contenView.bounds             = CGRectMake(0, 0, _mainVw,_mainVh);
    
    
    _contenView.layer.cornerRadius = 8.0f;
    _contenView.tag                = 10;
    _contenView.backgroundColor    = [UIColor whiteColor];
    [self addSubview:_contenView];
    
    // 弹性动画执行
    [self showAniamation:_contenView];

    
}


#pragma mark   -----------------  弹性 显示view
-(void)showAniamation:(UIView *)main
{
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        
        main.bounds = CGRectMake(0, 0, _mainVw, _mainVh - 30.0f);
        main.alpha  = 1;
        [self initUI:main];
        
    } completion:nil];
}


#pragma mark   ----------------- 绘制
-(void)initUI:(UIView *)view
{
    
    CGFloat tableViewCenterX = view.bounds.size.width / 2.0;
    CGFloat tableViewCenterY = view.bounds.size.height / 2.0 - 6.0f;
    
    self.popTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height - 50.0f) style:UITableViewStylePlain];
    self.popTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.popTableView.tableFooterView  = [[UIView alloc] init];
    self.popTableView.center     = CGPointMake(tableViewCenterX, tableViewCenterY);
    self.popTableView.delegate   = self;
    self.popTableView.dataSource = self;
    [view addSubview:self.popTableView];
    
    
    CGFloat btnCenterX = view.bounds.size.width  / 2.0f;
    CGFloat btnCenterY = view.bounds.size.height - 25.0f;
    
    // 修改按钮
    UIButton *btn       = [[UIButton alloc] initWithFrame:CGRectMake(0,0,80,44)];
    btn.center          = CGPointMake(btnCenterX, btnCenterY);
    btn.tag             = view.tag;
    btn.backgroundColor = ClearColor;
    //    btn.backgroundColor = RedColor  ;
    [btn setTitle:@"一键分享" forState:0];
    [btn setTitleColor:OrangeColor forState:0];
    [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
  
}

#pragma mark  ---------  tableView Delegate  ----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *platCellId = [NSString stringWithFormat:@"tableVieCellID%d",0];
    
    
    
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:platCellId];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:platCellId];
        
        UISwitch *switchControl = [[UISwitch alloc] initWithFrame:CGRectZero];
        [switchControl sizeToFit];
        [switchControl addTarget:self action:@selector(switchChangeHandler:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchControl;
    }
    ((UISwitch *)cell.accessoryView).tag = 100;
    ((UISwitch *)cell.accessoryView).on  = [ShareSDK hasAuthorized:SSDKPlatformTypeSinaWeibo];
    
    
    //一键分享
    switch (indexPath.row)
    {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:platCellId];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:platCellId];
                
                UISwitch *switchControl = [[UISwitch alloc] initWithFrame:CGRectZero];
                [switchControl sizeToFit];
                [switchControl addTarget:self action:@selector(switchChangeHandler:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = switchControl;
            }
            ((UISwitch *)cell.accessoryView).tag = 100;
            MMLog(@"新浪微博分享开关 %d", ((UISwitch *)cell.accessoryView).on);

            ((UISwitch *)cell.accessoryView).on = [ShareSDK hasAuthorized:SSDKPlatformTypeSinaWeibo];
            MMLog(@"新浪微博分享 %d",[ShareSDK hasAuthorized:SSDKPlatformTypeSinaWeibo]);
            cell.textLabel.text = @"新浪微博";
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:platCellId];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:platCellId];
                
                UISwitch *switchControl = [[UISwitch alloc] initWithFrame:CGRectZero];
                [switchControl sizeToFit];
                [switchControl addTarget:self action:@selector(switchChangeHandler:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = switchControl;
            }
            ((UISwitch *)cell.accessoryView).tag = 101;
            ((UISwitch *)cell.accessoryView).on = [ShareSDK hasAuthorized:SSDKPlatformTypeTencentWeibo];
            cell.textLabel.text = @"腾讯微博";
            break;
            //        case 2:
            //            cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
            //            if (!cell)
            //            {
            //                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
            //            }
            //
            //            cell.textLabel.text = @"点击进行分享";
            //            break;
        default:
            break;
    }
    
    
    
    
    
    return cell;
}



#pragma mark   ---------- 按钮响应 ----------
- (void)BtnClick:(UIButton *)sender{
    
//    if (self.delegate && [self.delegate respondsToSelector:@selector(oneKeyShare:)]) {
//        [self.delegate oneKeyShare:sender];
//    }
//    
//    [self hide];

        /**
         * 使用ShareSDKExtension插件可以实现一键分享到多个平台。
         *
         * 注：
         * 1、在分享之前必须先保证平台的分享不是使用客户端进行。
         * 2、分享平台必须要先确保已经授权，否则会分享失败。
         *
         **/
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(loadingNow)]) {
        [self.delegate loadingNow];
    }
        NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
        
        if (imageArray)
        {
            
            //构造分享参数
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:@"我在使用ShareSDK的一键分享。"
                                             images:imageArray
                                                url:nil
                                              title:@"哈哈"
                                               type:SSDKContentTypeImage];
            
            MMLog(@"新浪是否授权：%d",[ShareSDK hasAuthorized:SSDKPlatformTypeSinaWeibo]);
            
            [SSEShareHelper oneKeyShare:@[@(SSDKPlatformTypeSinaWeibo), @(SSDKPlatformTypeTencentWeibo)]
                             parameters:shareParams
                         onStateChanged:^(SSDKPlatformType platformType, SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                             
                             NSString *platformName = nil;
                             switch (platformType)
                             {
                                 case SSDKPlatformTypeSinaWeibo:
                                     platformName = @"新浪微博";
                                     break;
                                 case SSDKPlatformTypeTencentWeibo:
                                     platformName = @"腾讯微博";
                                     break;
                                 default:
                                     break;
                             }
                             
                             switch (state) {
                                 case SSDKResponseStateSuccess:
                                 {
                                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@分享成功", platformName]
                                                                                         message:nil
                                                                                        delegate:nil
                                                                               cancelButtonTitle:@"确定"
                                                                               otherButtonTitles:nil];
                                     [alertView show];
                                     break;
                                 }
                                 case SSDKResponseStateFail:
                                 {
                                     if (error.code == 205)
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@用户尚未授权, 授权后再试!", platformName]
                                                                                             message:nil
                                                                                            delegate:nil
                                                                                   cancelButtonTitle:@"确定"
                                                                                   otherButtonTitles:nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@分享失败", platformName]
                                                                                             message:[NSString stringWithFormat:@"%@", error]
                                                                                            delegate:nil
                                                                                   cancelButtonTitle:@"确定"
                                                                                   otherButtonTitles:nil];
                                         [alertView show];
                                     }
                                     break;
                                 }
                                 case SSDKResponseStateCancel:
                                 {
                                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@分享已取消", platformName]
                                                                                         message:nil
                                                                                        delegate:nil
                                                                               cancelButtonTitle:@"确定"
                                                                               otherButtonTitles:nil];
                                     [alertView show];
                                     break;
                                 }
                                 default:
                                     break;
                             }
                             
                             if (end)
                             {

                                 if (self.delegate && [self.delegate respondsToSelector:@selector(loadingEnd)]) {
                                     [self.delegate loadingEnd];
                                 }
                                 [self.popTableView reloadData];
                             }
                         }];
        }
}




#pragma  mark   ===============  分享授权   ================
- (void)switchChangeHandler:(UISwitch *)sender
{
//    __weak ViewController *theController = self;
    switch (sender.tag)
    {
        case 100:
        {
            //新浪微博
            if (sender.on)
            {
                //授权
                [ShareSDK authorize:SSDKPlatformTypeSinaWeibo
                           settings:nil
                     onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
                         switch (state) {
                                  // 成功
                             case SSDKResponseStateSuccess:
                             {
                                 [ShowPromptMessageTool showMessage:@"授权成功"];
                             }
                                 break;
                                  //  失败
                                 case SSDKResponseStateFail:
                             {
                                 [ShowPromptMessageTool showMessage:@"授权失败"];
                             }
                                 break;
                             default:
                                 break;
                         }
                         
                         
                         [self reloadPopTableView];
                     }];
            }
            else
            {
                //取消授权
                [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
                [self reloadPopTableView];
            }
            break;
        }
        case 101:
        {
            //腾讯微博
            if (sender.on)
            {
                //授权
                [ShareSDK authorize:SSDKPlatformTypeTencentWeibo
                           settings:nil
                     onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
                         [self reloadPopTableView];
                     }];
            }
            else
            {
                //取消授权
                [ShareSDK cancelAuthorize:SSDKPlatformTypeTencentWeibo];
                [self reloadPopTableView];
            }
            break;
        }
        default:
            break;
    }
}


#pragma mark   --------------- 刷新 TableView  ----------
- (void)reloadPopTableView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.popTableView reloadData];
    });
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
